enum PermissionType {
  camera,
  microphone,
  photos,
  storage,
  locationWhenInUse,
  locationAlways,
  notifications,
  contacts,
  calendar,
  bluetooth,
  activityRecognition,
}


enum PermissionStatusX {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  notSupported,
}

class PermissionRationale {
  final String title;
  final String message;
  final String openSettingsText;
  final String cancelText;

  const PermissionRationale({
    required this.title,
    required this.message,
    this.openSettingsText = "Abrir ajustes",
    this.cancelText = "Cancelar",
  });
}

class PermissionResult {
  final PermissionType type;
  final PermissionStatusX status;

  const PermissionResult(this.type, this.status);

  bool get granted => status == PermissionStatusX.granted;
}
