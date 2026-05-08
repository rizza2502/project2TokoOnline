import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Dashboard page test', (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardView(),
      ),
    );

    // cek apakah text muncul
    expect(find.text('Welcome back'), findsOneWidget);

    expect(find.text('Agung'), findsOneWidget);

    expect(find.text('Manage Store'), findsOneWidget);
  });
}
