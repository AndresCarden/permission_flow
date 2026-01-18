import 'package:flutter/material.dart';
import 'package:permission_flow/permission_flow.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PermissionDemoPage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class PermissionDemoPage extends StatefulWidget {
  const PermissionDemoPage({super.key});

  @override
  State<PermissionDemoPage> createState() => _PermissionDemoPageState();
}

class _PermissionDemoPageState extends State<PermissionDemoPage> {
  Future<void> _request(
  PermissionType type,
  String title,
  String message,
) async {
  final messenger = ScaffoldMessenger.of(context);

  final res = await PermissionFlow.ensure(
    type,
    contextForDialog: context,
    rationale: PermissionRationale(title: title, message: message),
  );

  messenger.showSnackBar(
    SnackBar(content: Text("$type → ${res.status}")),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("permission_flow – All Permissions")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _btn("Camera", () => _request(PermissionType.camera, "Camera permission", "We need camera access to take photos.")),
          _btn("Photos", () => _request(PermissionType.photos, "Photos permission", "We need access to your photos to attach files.")),
          _btn("Microphone", () => _request(PermissionType.microphone, "Microphone permission", "We need microphone access to record audio.")),
          _btn("Notifications", () => _request(PermissionType.notifications, "Notifications permission", "Enable notifications to receive important alerts.")),
          _btn("Location (while in use)", () => _request(PermissionType.locationWhenInUse, "Location permission", "We need your location while using the app.")),
          _btn("Location (always)", () => _request(PermissionType.locationAlways, "Background location permission", "We need your location even when the app is closed.")),
          _btn("Contacts", () => _request(PermissionType.contacts, "Contacts permission", "We need access to your contacts.")),
          _btn("Calendar", () => _request(PermissionType.calendar, "Calendar permission", "We need access to your calendar.")),
          _btn("Bluetooth", () => _request(PermissionType.bluetooth, "Bluetooth permission", "We need Bluetooth to connect to devices.")),
          _btn("Activity Recognition", () => _request(PermissionType.activityRecognition, "Activity permission", "We need this to count your steps.")),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(onPressed: onTap, child: Text(text)),
    );
  }
}
