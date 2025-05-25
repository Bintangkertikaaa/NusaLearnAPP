import 'package:flutter/material.dart';
import 'friend_requests_screen.dart';
import 'social_screen.dart';
import 'profile_screen.dart';
import 'material_screen.dart';
import 'minigames_screen.dart';
import 'achievement_screen.dart';
import '../data/material_data.dart';  // Import material data

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    const ProfileScreen(),
    const FriendRequestsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFFFF7043),
            unselectedItemColor: Colors.grey,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Kontak Masuk'),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Dashboard ---------------- */

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/banner_nusantara.png',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Menjelajahi Kekayaan Budaya Nusantara',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          /* ---------- Menu Grid ---------- */
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              buildMenuBox(context, 'Materi', Icons.menu_book, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MaterialCategoryScreen(),
                  ),
                );
              }),
              buildMenuBox(context, 'Mini Games', Icons.videogame_asset, () {
                Navigator.pushNamed(context, '/minigames');
              }),
              buildMenuBox(context, 'Achievement', Icons.emoji_events, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AchievementScreen()));
              }),
              buildMenuBox(context, 'Sosial', Icons.group, () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SocialScreen()));
              }),
            ],
          ),
        ],
      ),
    );
  }

  /* ---------- Kotak Menu Reusable ---------- */
  Widget buildMenuBox(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.orange),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
} 