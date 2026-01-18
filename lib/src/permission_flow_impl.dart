import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models.dart';

class PermissionFlow {
static Future<PermissionResult> ensure(
  PermissionType type, {
  PermissionRationale? rationale,
  bool openSettingsIfPermanentlyDenied = true,
  BuildContext? contextForDialog,
}) async {
  final perm = _map(type);

  if (perm == null) {
    return PermissionResult(type, PermissionStatusX.notSupported);
  }

  BuildContext? safeContext() =>
      (contextForDialog != null && contextForDialog.mounted)
          ? contextForDialog
          : null;

  var status = await perm.status;

  final normalized1 = _normalize(status);
  if (normalized1 == PermissionStatusX.granted ||
      normalized1 == PermissionStatusX.limited ||
      normalized1 == PermissionStatusX.restricted) {
    return PermissionResult(type, normalized1);
  }

  if (status.isPermanentlyDenied || status.isRestricted) {
    final result = await _maybeShowSettingsDialog(
      type,
      rationale,
      openSettingsIfPermanentlyDenied,
      safeContext(),
    );

    status = await perm.status;
    return PermissionResult(
      type,
      _normalize(status, fallbackIfDenied: result),
    );
  }

  status = await perm.request();

  if (status.isPermanentlyDenied) {
    await _maybeShowSettingsDialog(
      type,
      rationale,
      openSettingsIfPermanentlyDenied,
      safeContext(),
    );
    status = await perm.status;
  }

  return PermissionResult(type, _normalize(status));
}

  static Permission? _map(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.photos:
        return Permission.photos;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;
      case PermissionType.locationAlways:
        return Permission.locationAlways;
      case PermissionType.notifications:
        return Permission.notification;
      case PermissionType.contacts:
        return Permission.contacts;

      case PermissionType.calendar:
        return Permission.calendarFullAccess;

      case PermissionType.bluetooth:
        return Permission.bluetooth;

      case PermissionType.activityRecognition:
        return Permission.activityRecognition;
    }
  }

  static PermissionStatusX _normalize(
    PermissionStatus status, {
    PermissionStatusX? fallbackIfDenied,
  }) {
    if (status.isGranted) return PermissionStatusX.granted;
    if (status.isLimited) return PermissionStatusX.limited;
    if (status.isRestricted) return PermissionStatusX.restricted;
    if (status.isPermanentlyDenied) return PermissionStatusX.permanentlyDenied;

    if (status.isDenied) {
      return fallbackIfDenied ?? PermissionStatusX.denied;
    }

    return PermissionStatusX.denied;
  }

  static Future<PermissionStatusX?> _maybeShowSettingsDialog(
    PermissionType type,
    PermissionRationale? rationale,
    bool openSettingsIfPermanentlyDenied,
    BuildContext? context,
  ) async {
    if (!openSettingsIfPermanentlyDenied) return null;

    if (context == null || rationale == null) {
      await openAppSettings();
      return PermissionStatusX.permanentlyDenied;
    }

    if (!context.mounted) return PermissionStatusX.denied;

    final goSettings = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(rationale.title),
        content: Text(rationale.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(rationale.cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(rationale.openSettingsText),
          ),
        ],
      ),
    );

    if (!context.mounted) return PermissionStatusX.denied;

    if (goSettings == true) {
      await openAppSettings();
      return Platform.isIOS
          ? PermissionStatusX.denied
          : PermissionStatusX.permanentlyDenied;
    }

    return PermissionStatusX.denied;
  }
}
