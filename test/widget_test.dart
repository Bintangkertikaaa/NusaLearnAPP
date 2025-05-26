// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:nusa_learn/main.dart';
import 'package:nusa_learn/screens/login_screen.dart';
import 'package:nusa_learn/providers/user_provider.dart';
import 'firebase_options_test.dart';

void main() {
  setUpAll(() {
    setupFirebaseTest();
  });

  testWidgets('App should show splash screen first',
      (WidgetTester tester) async {
    // Set a fixed window size
    tester.binding.window.physicalSizeTestValue = const Size(1280, 720);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    final mockFirestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth();

    // Build our app with provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          Provider.value(value: mockFirestore),
          Provider.value(value: mockAuth),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that splash screen shows up
    expect(find.text('Nusa'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);

    // Wait for splash screen timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    // Verify navigation to login screen
    expect(find.text('Selamat Datang!'), findsOneWidget);
  });

  testWidgets('Login screen should validate input',
      (WidgetTester tester) async {
    // Set a fixed window size
    tester.binding.window.physicalSizeTestValue = const Size(1280, 720);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    final mockFirestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth();

    // Build our app with provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          Provider.value(value: mockFirestore),
          Provider.value(value: mockAuth),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      ),
    );

    // Find the login button
    final loginButton = find.widgetWithText(ElevatedButton, 'Masuk');
    expect(loginButton, findsOneWidget);

    // Try to login without input
    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should show validation errors
    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('Kata sandi tidak boleh kosong'), findsOneWidget);

    // Fill in email only
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should still show password error only
    expect(find.text('Email tidak boleh kosong'), findsNothing);
    expect(find.text('Kata sandi tidak boleh kosong'), findsOneWidget);

    // Fill in password
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should not show any validation errors
    expect(find.text('Email tidak boleh kosong'), findsNothing);
    expect(find.text('Kata sandi tidak boleh kosong'), findsNothing);
  });
}
