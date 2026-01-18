import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:permission_flow/permission_flow.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PermissionFlow.ensure returns a valid result',
      (WidgetTester tester) async {

    // Construimos una app mínima para tener BuildContext
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text("Test")),
        ),
      ),
    );

    final context = tester.element(find.text("Test"));

    // ⚠️ En integración real esto abrirá el diálogo de permiso del sistema.
    // En CI normalmente se marca como denied.
    final result = await PermissionFlow.ensure(
      PermissionType.camera,
      contextForDialog: context,
      rationale: const PermissionRationale(
        title: "Test",
        message: "Testing permission",
      ),
      openSettingsIfPermanentlyDenied: false, // evita abrir settings en test
    );

    // Solo validamos que retorna un estado válido
    expect(result.type, PermissionType.camera);
    expect(PermissionStatusX.values.contains(result.status), true);
  });
}
