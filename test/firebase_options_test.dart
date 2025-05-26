import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class MockFirebaseApp extends FirebaseAppPlatform {
  MockFirebaseApp({required String name, required FirebaseOptions options})
      : super(name, options);
}

class MockFirebasePlatform extends FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp(
      name: name ?? '[DEFAULT]',
      options: options ??
          const FirebaseOptions(
            apiKey: 'test-api-key',
            appId: 'test-app-id',
            messagingSenderId: 'test-sender-id',
            projectId: 'test-project-id',
            authDomain: 'test-project-id.firebaseapp.com',
            storageBucket: 'test-project-id.appspot.com',
          ),
    );
  }

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    return MockFirebaseApp(
      name: name,
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
        authDomain: 'test-project-id.firebaseapp.com',
        storageBucket: 'test-project-id.appspot.com',
      ),
    );
  }

  @override
  List<FirebaseAppPlatform> get apps => [app()];
}

void setupFirebaseTest() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebasePlatform.instance = MockFirebasePlatform();
}

void main() {
  test('Mock Firebase Platform is set up correctly', () {
    setupFirebaseTest();
    expect(FirebasePlatform.instance.apps.length, 1);
    expect(FirebasePlatform.instance.app().name, '[DEFAULT]');
  });
}
