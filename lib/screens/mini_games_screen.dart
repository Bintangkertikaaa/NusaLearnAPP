import 'package:flutter/material.dart';

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Mini Games',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGameGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    final List<Map<String, dynamic>> games = [
      {
        'title': 'Tebak Alat Musik',
        'description': 'Dengarkan suara dan tebak alat musik tradisionalnya!',
        'icon': Icons.music_note,
        'color': Colors.purple,
        'onTap': () {
          // TODO: Implementasi game tebak alat musik
          _showComingSoonDialog(context, 'Tebak Alat Musik');
        },
      },
      {
        'title': 'Puzzle Pakaian Adat',
        'description': 'Susun gambar pakaian adat dari berbagai daerah',
        'icon': Icons.extension,
        'color': Colors.blue,
        'onTap': () {
          // TODO: Implementasi game puzzle
          _showComingSoonDialog(context, 'Puzzle Pakaian Adat');
        },
      },
      {
        'title': 'Kuis Budaya',
        'description': 'Jawab pertanyaan seputar budaya Indonesia',
        'icon': Icons.quiz,
        'color': Colors.green,
        'onTap': () {
          // TODO: Implementasi kuis budaya
          _showComingSoonDialog(context, 'Kuis Budaya');
        },
      },
      {
        'title': 'Memory Match',
        'description': 'Temukan pasangan kartu budaya yang sama',
        'icon': Icons.grid_view,
        'color': Colors.orange,
        'onTap': () {
          // TODO: Implementasi memory match game
          _showComingSoonDialog(context, 'Memory Match');
        },
      },
      {
        'title': 'Tebak Daerah',
        'description': 'Tebak asal daerah dari berbagai budaya Indonesia',
        'icon': Icons.place,
        'color': Colors.red,
        'onTap': () {
          // TODO: Implementasi game tebak daerah
          _showComingSoonDialog(context, 'Tebak Daerah');
        },
      },
      {
        'title': 'Word Puzzle',
        'description': 'Temukan kata-kata yang berhubungan dengan budaya',
        'icon': Icons.abc,
        'color': Colors.teal,
        'onTap': () {
          // TODO: Implementasi word puzzle
          _showComingSoonDialog(context, 'Word Puzzle');
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(
          title: game['title'],
          description: game['description'],
          icon: game['icon'],
          color: game['color'],
          onTap: game['onTap'],
        );
      },
    );
  }

  Widget _buildGameCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String gameName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gameName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/coming_soon.png',
              height: 120,
              // Jika gambar tidak ada, gunakan icon
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.games,
                size: 80,
                color: Color(0xFFFF5722),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Game ini akan segera hadir!\nTunggu update selanjutnya ya!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 