import 'package:flutter/material.dart';
import 'social_screen.dart';

class FriendRequest {
  final String id;
  final String name;
  final String school;
  final String time;
  final String initials;
  bool isAccepted;
  bool isPast;

  FriendRequest({
    required this.id,
    required this.name,
    required this.school,
    required this.time,
    required this.initials,
    this.isAccepted = false,
    this.isPast = false,
  });
}

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final List<FriendRequest> _todayRequests = [];
  final List<FriendRequest> _pastRequests = [];

  @override
  void initState() {
    super.initState();
    // Data permintaan hari ini
    _todayRequests.addAll([
      FriendRequest(
        id: '1',
        name: 'Isyana Macika',
        school: 'SMA N 1 Tangerang',
        time: '20:00',
        initials: 'IM',
      ),
      FriendRequest(
        id: '2',
        name: 'Bintang Kartika',
        school: 'SD 1 Magelang',
        time: '11:50',
        initials: 'BK',
      ),
      FriendRequest(
        id: '3',
        name: 'Victor D',
        school: 'SD 5 Jakarta',
        time: '10:55',
        initials: 'VD',
      ),
    ]);

    // Data permintaan 5 hari lalu
    _pastRequests.add(
      FriendRequest(
        id: '4',
        name: 'Jyotisa',
        school: 'SMF 5 Bandung',
        time: '15:30',
        initials: 'J',
        isPast: true,
      ),
    );
  }

  void _acceptRequest(FriendRequest request) {
    setState(() {
      // Hapus dari daftar permintaan hari ini
      _todayRequests.remove(request);
      // Ubah status dan tambahkan ke daftar yang sudah diterima
      request.isPast = true;
      _pastRequests.add(request);
    });
  }

  Widget _buildRequestItem(FriendRequest request) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFFFB74D),
                  child: Text(
                    request.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.school,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Time
                Text(
                  request.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                // Action buttons
                if (!request.isPast) ...[
                  ElevatedButton(
                    onPressed: () => _acceptRequest(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
                    child: const Text('Terima'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
    setState(() {
                        _todayRequests.remove(request);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
                    child: const Text('Tolak'),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add),
                    label: const Text('Berteman'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Kontak Masuk',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SocialScreen(initialTabIndex: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permintaan Pertemanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_todayRequests.length} permintaan pertemanan baru',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ..._todayRequests.map((request) => _buildRequestItem(request)),
                if (_pastRequests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '5 hari lalu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ..._pastRequests.map((request) => _buildRequestItem(request)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Untuk menggunakan halaman ini, tambahkan ke main.dart
// Contoh:
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friend Requests App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const FriendRequestsScreen(),
    );
  }
}
*/