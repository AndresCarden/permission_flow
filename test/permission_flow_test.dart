import 'package:flutter_test/flutter_test.dart';
import 'package:permission_flow/permission_flow.dart';

void main() {
  test('PermissionResult.granted is true only when status is granted', () {
    const r1 = PermissionResult(PermissionType.camera, PermissionStatusX.granted);
    const r2 = PermissionResult(PermissionType.camera, PermissionStatusX.denied);

    expect(r1.granted, true);
    expect(r2.granted, false);
  });

  test('Enum values exist (sanity check)', () {
    expect(PermissionType.values.isNotEmpty, true);
    expect(PermissionStatusX.values.isNotEmpty, true);
  });
}
