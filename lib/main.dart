import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/friend_requests_screen.dart';
import 'screens/minigames_screen.dart';

void main() {
  runApp(const NusaLearnApp());
}

class NusaLearnApp extends StatelessWidget {
  const NusaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/friend-requests': (context) => const FriendRequestsScreen(),
        '/minigames': (context) => const MinigamesScreen(),
      },
    );
  }
}
