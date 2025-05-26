import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend_request_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  Future<bool> _checkIfFriendRequestExists(
      String currentUserId, String otherUserId) async {
    final requests = await FirebaseFirestore.instance
        .collection('friend_requests')
        .where('senderId', whereIn: [currentUserId, otherUserId]).where(
            'receiverId',
            whereIn: [currentUserId, otherUserId]).get();

    return requests.docs.isNotEmpty;
  }

  Future<void> _sendFriendRequest(
      String currentUserId, String otherUserId) async {
    try {
      // Check if friend request already exists
      bool requestExists =
          await _checkIfFriendRequestExists(currentUserId, otherUserId);
      if (requestExists) {
        throw Exception('Permintaan pertemanan sudah ada');
      }

      // Create new friend request
      await FirebaseFirestore.instance.collection('friend_requests').add({
        'senderId': currentUserId,
        'receiverId': otherUserId,
        'status': 'pending',
        'createdAt': DateTime.now(),
      });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Teman'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isNotEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Belum ada pengguna lain'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userData = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFFFAB40),
                    child: Text(
                      userData['name']?[0]?.toUpperCase() ?? '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(userData['name'] ?? 'Nama tidak tersedia'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData['school'] ?? 'Sekolah tidak tersedia'),
                      Text('Level: ${userData['level'] ?? 'Pemula'}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _sendFriendRequest(currentUser.uid, userData.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Permintaan pertemanan terkirim!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6D3D),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      'Tambah Teman',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
