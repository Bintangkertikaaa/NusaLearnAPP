// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_learn_app/main.dart';

void main() {
  testWidgets('App should show splash screen first', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(NusaLearnApp());

    // Verify that splash screen shows up
    expect(find.text('Nusa'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);

    // Wait for splash screen timer
    await tester.pump(const Duration(seconds: 3));

    // Verify navigation to login screen
    await tester.pumpAndSettle();
    expect(find.text('Selamat Datang!'), findsOneWidget);
  });
}
