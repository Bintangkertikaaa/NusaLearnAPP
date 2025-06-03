import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/friend_service.dart';
import '../models/friend.dart';
import 'chat_screen.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  void _showFriendOptions(BuildContext context, Friend friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFFFB74D),
                    radius: 25,
                    child: Text(
                      friend.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        friend.school,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFFFF6D3D),
              ),
              title: const Text('Mulai Obrolan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(friend: friend),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendList(List<Friend> friends, String title) {
    if (friends.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFF6D3D),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFB74D),
                child: Text(
                  friend.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(friend.name),
              subtitle: friend.messages.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            friend.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: friend.hasUnreadMessages
                                  ? Colors.black87
                                  : Colors.grey[600],
                              fontWeight: friend.hasUnreadMessages
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (friend.hasUnreadMessages)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6D3D),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    )
                  : Text(
                      friend.school,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${friend.points} Poin',
                    style: const TextStyle(
                      color: Color(0xFFFF6D3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (friend.messages.isNotEmpty)
                    Text(
                      _formatTime(friend.lastMessageTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: friend.hasUnreadMessages
                            ? const Color(0xFFFF6D3D)
                            : Colors.grey[600],
                      ),
                    ),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(friend: friend),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}h lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}j lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    if (user == null) return const SizedBox();

    return StreamBuilder<List<Friend>>(
      stream: FriendService().getFriends(user.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFriends = snapshot.data!;
        if (allFriends.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada teman',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        // Pisahkan teman yang sudah chat dan belum
        final chattedFriends = allFriends
            .where((f) => f.messages.isNotEmpty)
            .toList()
          ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        final nonChattedFriends = allFriends
            .where((f) => f.messages.isEmpty)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildFriendList(chattedFriends, 'OBROLAN'),
              if (chattedFriends.isNotEmpty && nonChattedFriends.isNotEmpty)
                const Divider(height: 1),
              _buildFriendList(nonChattedFriends, 'SEMUA KONTAK'),
            ],
          ),
        );
      },
    );
  }
}
