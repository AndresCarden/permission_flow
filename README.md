# permission_flow

A unified permission request flow for Flutter that simplifies handling
permissions on **Android** and **iOS** with a single, consistent API.

Instead of manually checking permission states, showing rationale
dialogs, handling permanently denied cases, and opening system settings
--- **permission_flow** does it all for you.

------------------------------------------------------------------------

##  Features

-   One unified method: `PermissionFlow.ensure()`
-   Consistent permission statuses across Android & iOS
-   Built-in rationale dialog support
-   Automatically opens App Settings when permission is permanently
    denied
-   Handles Android "Don't ask again"
-   Handles iOS "Limited Photos" and "Restricted" states
-   Supports common permissions:
    -   Camera
    -   Photos / Media
    -   Microphone
    -   Notifications
    -   Location (While in use / Always)
    -   Contacts
    -   Calendar
    -   Bluetooth
    -   Activity Recognition

------------------------------------------------------------------------

##  Installation

Add to your `pubspec.yaml`:

``` yaml
dependencies:
  permission_flow: ^1.0.0
```

Run:

``` bash
flutter pub get
```

------------------------------------------------------------------------

##  Basic Usage

``` dart
import 'package:permission_flow/permission_flow.dart';

final result = await PermissionFlow.ensure(
  PermissionType.camera,
  contextForDialog: context,
  rationale: const PermissionRationale(
    title: "Camera permission",
    message: "We need camera access to take photos.",
    openSettingsText: "Open settings",
    cancelText: "Not now",
  ),
);

if (result.granted) {
  // Permission granted
} else {
  // Permission denied
}
```

------------------------------------------------------------------------

##  Permission Types

-   camera
-   photos
-   microphone
-   notifications
-   locationWhenInUse
-   locationAlways
-   contacts
-   calendar
-   bluetooth
-   activityRecognition

------------------------------------------------------------------------

## Permission Result Status

-   granted
-   denied
-   permanentlyDenied
-   restricted (iOS only)
-   limited (iOS Photos)
-   notSupported

------------------------------------------------------------------------

##  Rationale Dialog & Settings Redirect

If permission is permanently denied, `permission_flow` can:

1.  Show a customizable dialog
2.  Redirect the user to App Settings

Disable settings redirect:

``` dart
PermissionFlow.ensure(
  PermissionType.notifications,
  openSettingsIfPermanentlyDenied: false,
);
```

------------------------------------------------------------------------

##  Platform Setup

### iOS --- Info.plist

Add only the permissions your app uses:

``` xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos.</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access.</string>

<key>NSUserNotificationUsageDescription</key>
<string>We send important alerts.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location while using the app.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location in background.</string>

<key>NSContactsUsageDescription</key>
<string>We need contacts access.</string>

<key>NSCalendarsUsageDescription</key>
<string>We need calendar access.</string>

<key>NSBluetoothAlwaysUsageDescription</key>
<string>We need Bluetooth access.</string>

<key>NSMotionUsageDescription</key>
<string>We need activity recognition.</string>
```

------------------------------------------------------------------------

### Android --- AndroidManifest.xml

Add only the permissions your app needs:

``` xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.READ_CALENDAR"/>
<uses-permission android:name="android.permission.WRITE_CALENDAR"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
```

------------------------------------------------------------------------

##  Example App

Run the included demo:

``` bash
cd example
flutter run
```

------------------------------------------------------------------------

##  License

MIT License

------------------------------------------------------------------------

##  Author

Created to simplify permission handling in Flutter apps.\
**Andrés Cárdenas**
