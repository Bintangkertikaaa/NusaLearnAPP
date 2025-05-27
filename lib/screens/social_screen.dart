import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/chat_message.dart';
import '../services/friend_service.dart';
import '../services/chat_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:uuid/uuid.dart';
import 'forum_screen.dart';
import 'friend_list_screen.dart';

class ForumPost {
  final String id;
  final String authorName;
  final String authorInitial;
  final String title;
  final DateTime postedAt;
  int replies;
  List<ForumReply> replyList;

  ForumPost({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.title,
    required this.postedAt,
    this.replies = 0,
    List<ForumReply>? replyList,
  }) : replyList = replyList ?? [];
}

class ForumReply {
  final String authorName;
  final String authorInitial;
  final String text;
  final DateTime timestamp;

  ForumReply({
    required this.authorName,
    required this.authorInitial,
    required this.text,
    required this.timestamp,
  });
}

class Community {
  final String id;
  final String name;
  final String initial;
  int members;
  final String description;
  bool isJoined;

  Community({
    required this.id,
    required this.name,
    required this.initial,
    required this.members,
    required this.description,
    this.isJoined = false,
  });
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sosial',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF6D3D),
          labelColor: const Color(0xFFFF6D3D),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Forum'),
            Tab(text: 'Teman'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ForumScreen(),
          FriendListScreen(),
        ],
      ),
    );
  }
}
