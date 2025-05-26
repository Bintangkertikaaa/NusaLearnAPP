import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend_request_model.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  Future<void> _handleFriendRequest(String requestId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({'status': status});

      if (status == 'accepted') {
        // TODO: Add both users to each other's friends list
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Silakan login terlebih dahulu'),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Kontak Masuk',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFFF5722),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFFF5722),
            tabs: [
              Tab(text: 'Diterima'),
              Tab(text: 'Menunggu'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Permintaan Diterima
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('friend_requests')
                  .where('receiverId', isEqualTo: currentUser.uid)
                  .where('status', isEqualTo: 'accepted')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada teman',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var request = snapshot.data!.docs[index];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(request['senderId'])
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox();
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFFFB74D),
                              child: Text(
                                userData['name']?[0]?.toUpperCase() ?? '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: Text(
                              userData['name'] ?? 'Nama tidak tersedia',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              userData['school'] ?? 'Sekolah tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            // Tab Permintaan Menunggu
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('friend_requests')
                  .where('receiverId', isEqualTo: currentUser.uid)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada permintaan pertemanan baru',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var request = snapshot.data!.docs[index];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(request['senderId'])
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox();
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFFFB74D),
                              child: Text(
                                userData['name']?[0]?.toUpperCase() ?? '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: Text(
                              userData['name'] ?? 'Nama tidak tersedia',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  userData['school'] ??
                                      'Sekolah tidak tersedia',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _handleFriendRequest(
                                          request.id,
                                          'accepted',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFF5722),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Terima'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _handleFriendRequest(
                                          request.id,
                                          'rejected',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.grey[700],
                                          side: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Tolak'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
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
