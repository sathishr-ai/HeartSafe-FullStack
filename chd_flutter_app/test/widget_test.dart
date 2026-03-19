// Widget tests for HeartSafe CHD App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chd_flutter_app/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders HeartSafe title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginScreen()),
    );
    expect(find.text('HeartSafe'), findsOneWidget);
  });
}
