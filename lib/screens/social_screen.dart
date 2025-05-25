import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/chat_message.dart';

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
  final int initialTabIndex;
  
  const SocialScreen({
    Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _friendTabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  int _selectedMainTab = 0;
  Friend? _selectedFriend;
  
  final List<Friend> _friends = [];
  final List<ForumPost> _forumPosts = [];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _friendTabController = TabController(length: 2, vsync: this);
    
    _mainTabController.addListener(() {
      setState(() {
        _selectedMainTab = _mainTabController.index;
      });
    });

    _searchController.addListener(() {
      setState(() {});
    });

    // Data dummy untuk testing
    _friends.addAll([
      Friend(
        id: '1',
        name: 'Victor D',
        school: 'SD 5 Jakarta',
        initials: 'VD',
        messages: <ChatMessage>[
          ChatMessage(
            text: 'Besok jadi kumpul?',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 5)),
            isRead: false,
          ),
        ],
      ),
      Friend(
        id: '2',
        name: 'Isyana Macika',
        school: 'SMA 3 Bandung',
        initials: 'I',
        messages: <ChatMessage>[
          ChatMessage(
            text: 'Hai, apa kabar?',
            isMe: false,
            time: DateTime.now().subtract(const Duration(hours: 1)),
            isRead: false,
          ),
        ],
      ),
      Friend(
        id: '3',
        name: 'Jyotisa',
        school: 'SMA 3 Bandung',
        initials: 'J',
        messages: [],
      ),
      Friend(
        id: '4',
        name: 'Bintang',
        school: 'SD 1 Magelang',
        initials: 'B',
        messages: [],
      ),
    ]);

    // Data dummy untuk forum
    _forumPosts.addAll([
      ForumPost(
        id: '1',
        authorName: 'Jyotisa',
        authorInitial: 'J',
        title: 'Apa makna dari tarian pendet?',
        postedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        replies: 8,
      ),
      ForumPost(
        id: '2',
        authorName: 'Bintang',
        authorInitial: 'B',
        title: 'Apa perbedaan antara budaya...',
        postedAt: DateTime.now().subtract(const Duration(minutes: 23)),
        replies: 20,
      ),
    ]);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _friendTabController.dispose();
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String get _searchHint {
    switch (_selectedMainTab) {
      case 0:
        return 'Cari topik diskusi...';
      case 1:
        return 'Cari teman...';
      default:
        return 'Cari...';
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _searchHint,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              onChanged: (value) {
                // Trigger rebuild saat text berubah
                setState(() {});
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildForumPost(ForumPost post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFFFB74D),
                  child: Text(
                    post.authorInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${DateTime.now().difference(post.postedAt).inMinutes} menit yang lalu',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${post.replies} Balasan',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleForumReply(post),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green[700],
                    elevation: 0,
                  ),
                  child: const Text('Balas'),
                ),
              ],
            ),
          ),
          if (post.replyList.isNotEmpty) ...[
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: post.replyList.map((reply) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.orange[300],
                        child: Text(
                          reply.authorInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  reply.authorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTime(reply.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(reply.text),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildCommunity(Community community) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFFFB74D),
                  child: Text(
                    community.initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${community.members} Anggota',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        community.description,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleCommunityJoin(community),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: community.isJoined ? Colors.grey[100] : Colors.green[100],
                    foregroundColor: community.isJoined ? Colors.grey[700] : Colors.green[700],
                    elevation: 0,
                  ),
                  child: Text(community.isJoined ? 'Keluar' : 'Gabung'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  List<Friend> get _sortedFriends {
    final List<Friend> sorted = List.from(_friends);
    sorted.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return sorted;
  }

  List<Friend> get _friendsWithMessages {
    return _sortedFriends.where((friend) => friend.messages.isNotEmpty).toList();
  }

  List<Friend> get _friendsWithoutMessages {
    return _sortedFriends.where((friend) => friend.messages.isEmpty).toList();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty || _selectedFriend == null) return;

    _messageController.clear();
    setState(() {
      _selectedFriend!.messages.add(
        ChatMessage(
          text: text,
          isMe: true,
          time: DateTime.now(),
          isRead: true,
        ),
      );
      
      // Jika ini adalah pesan pertama dan kita di tab Semua Teman,
      // pindah ke tab Pesan
      if (_selectedFriend!.messages.length == 1 && 
          _friendTabController.index == 1) { // 1 adalah index untuk tab Semua Teman
        _friendTabController.animateTo(0); // 0 adalah index untuk tab Pesan
      }
    });
  }

  void _handleFriendSelect(Friend friend) {
    setState(() {
      _selectedFriend = friend;
      // Tandai pesan sebagai telah dibaca
      if (friend.messages.isNotEmpty) {
        for (var message in friend.messages) {
          if (!message.isMe) {
            message.isRead = true;
          }
        }
      }
    });
  }

  Widget _buildFriendItem(Friend friend) {
    final hasMessages = friend.messages.isNotEmpty;
    final hasUnread = friend.hasUnreadMessages;
    final isSelected = _selectedFriend?.id == friend.id;

    return InkWell(
      onTap: () => _handleFriendSelect(friend),
      child: Container(
        color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xFFFF5722),
                        child: Text(
                          friend.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (hasUnread)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (hasMessages)
                          Text(
                            friend.messages.first.text,
                            style: TextStyle(
                              color: hasUnread ? Colors.black : Colors.grey[600],
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            friend.school,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!hasMessages)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5722).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Mulai Chat',
                        style: TextStyle(
                          color: Color(0xFFFF5722),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    if (_selectedFriend == null) {
      return const Center(
        child: Text(
          'Pilih teman untuk memulai chat',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFB74D),
                child: Text(
                  _selectedFriend!.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedFriend!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _selectedFriend!.school,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Chat messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            reverse: true,
            itemCount: _selectedFriend!.messages.length,
            itemBuilder: (context, index) {
              final message = _selectedFriend!.messages[index];
              return _buildMessage(message);
            },
          ),
        ),
        // Input area
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.green[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF5722),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  void _handleForumReply(ForumPost post) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: Text('Balas ke ${post.authorName}'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Tulis balasan Anda...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  setState(() {
                    post.replyList.add(
                      ForumReply(
                        authorName: 'Saya',
                        authorInitial: 'S',
                        text: textController.text,
                        timestamp: DateTime.now(),
                      ),
                    );
                    post.replies++;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  void _handleCommunityJoin(Community community) {
    setState(() {
      community.isJoined = !community.isJoined;
      if (community.isJoined) {
        community.members++;
      } else {
        community.members--;
      }
    });
  }

  String _formatTime(DateTime time) {
    String hours = time.hour.toString().padLeft(2, '0');
    String minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  List<Friend> _getFilteredFriends() {
    final query = _searchController.text.toLowerCase().trim();
    List<Friend> baseList = [];

    // Tentukan list dasar berdasarkan tab yang aktif
    if (_friendTabController.index == 0) {
      baseList = _friends.where((friend) => friend.messages.isNotEmpty).toList();
    } else {
      baseList = _friends.where((friend) => friend.messages.isEmpty).toList();
    }

    // Jika tidak ada query pencarian, kembalikan semua teman
    if (query.isEmpty) {
      return baseList;
    }

    // Filter berdasarkan nama atau sekolah
    return baseList.where((friend) =>
      friend.name.toLowerCase().contains(query) ||
      friend.school.toLowerCase().contains(query)
    ).toList();
  }

  // Fungsi untuk memfilter forum posts berdasarkan pencarian
  List<ForumPost> get _filteredForumPosts {
    if (_searchController.text.isEmpty) {
      return _forumPosts;
    }
    final query = _searchController.text.toLowerCase();
    return _forumPosts.where((post) =>
      post.title.toLowerCase().contains(query) ||
      post.authorName.toLowerCase().contains(query)
    ).toList();
  }

  // Fungsi untuk memfilter friends berdasarkan pencarian
  List<Friend> get _filteredFriends {
    if (_searchController.text.isEmpty) {
      return _friends;
    }
    final query = _searchController.text.toLowerCase();
    return _friends.where((friend) =>
      friend.name.toLowerCase().contains(query) ||
      friend.school.toLowerCase().contains(query)
    ).toList();
  }

  // Widget untuk menampilkan pesan ketika hasil pencarian kosong
  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedMainTab == 0
                ? 'Coba kata kunci lain untuk mencari topik diskusi'
                : 'Coba kata kunci lain untuk mencari teman',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Sosial',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _mainTabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Forum'),
            Tab(text: 'Teman'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                // Forum Tab
                _searchController.text.isNotEmpty && _filteredForumPosts.isEmpty
                    ? _buildEmptySearchResult()
                    : ListView.builder(
                        itemCount: _filteredForumPosts.length,
                        itemBuilder: (context, index) {
                          return _buildForumPost(_filteredForumPosts[index]);
                        },
                      ),
                
                // Friends Tab
                Row(
                  children: [
                    // Left side - Friend list
                    SizedBox(
                      width: 350,
                      child: Column(
                        children: [
                          TabBar(
                            controller: _friendTabController,
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.orange,
                            tabs: const [
                              Tab(text: 'Pesan'),
                              Tab(text: 'Semua Teman'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _friendTabController,
                              children: [
                                // Tab Pesan
                                _searchController.text.isNotEmpty && _filteredFriendsWithMessages.isEmpty
                                    ? _buildEmptySearchResult()
                                    : ListView.builder(
                                        itemCount: _filteredFriendsWithMessages.length,
                                        itemBuilder: (context, index) {
                                          return _buildFriendItem(_filteredFriendsWithMessages[index]);
                                        },
                                      ),
                                // Tab Semua Teman
                                _searchController.text.isNotEmpty && _filteredFriendsWithoutMessages.isEmpty
                                    ? _buildEmptySearchResult()
                                    : ListView.builder(
                                        itemCount: _filteredFriendsWithoutMessages.length,
                                        itemBuilder: (context, index) {
                                          return _buildFriendItem(_filteredFriendsWithoutMessages[index]);
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Vertical divider
                    Container(
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    // Right side - Chat area
                    Expanded(
                      child: _buildChatArea(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memfilter teman dengan pesan berdasarkan pencarian
  List<Friend> get _filteredFriendsWithMessages {
    final List<Friend> friendsWithMessages = _friends.where((friend) => friend.messages.isNotEmpty).toList();
    if (_searchController.text.isEmpty) {
      return friendsWithMessages;
    }
    final query = _searchController.text.toLowerCase();
    return friendsWithMessages.where((friend) =>
      friend.name.toLowerCase().contains(query) ||
      friend.school.toLowerCase().contains(query)
    ).toList();
  }

  // Fungsi untuk memfilter teman tanpa pesan berdasarkan pencarian
  List<Friend> get _filteredFriendsWithoutMessages {
    final List<Friend> friendsWithoutMessages = _friends.where((friend) => friend.messages.isEmpty).toList();
    if (_searchController.text.isEmpty) {
      return friendsWithoutMessages;
    }
    final query = _searchController.text.toLowerCase();
    return friendsWithoutMessages.where((friend) =>
      friend.name.toLowerCase().contains(query) ||
      friend.school.toLowerCase().contains(query)
    ).toList();
  }
} 