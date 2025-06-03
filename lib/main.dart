import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/friend_requests_screen.dart';
import 'screens/minigames_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/users_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Mengatur pengaturan Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Mengaktifkan caching lokal
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Cache tidak terbatas
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'NusaLearn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFFFF3E0),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/friend-requests': (context) => const FriendRequestsScreen(),
          '/minigames': (context) => const MinigamesScreen(),
          '/users': (context) => const UsersScreen(),
        },
      ),
    );
  }
}
