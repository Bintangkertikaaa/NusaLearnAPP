import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Bantuan',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            'FAQ',
            [
              _buildExpansionTile(
                'Bagaimana cara menggunakan aplikasi ini?',
                'Aplikasi ini dirancang untuk membantu Anda mempelajari budaya Indonesia. '
                'Anda dapat memulai dengan memilih kategori materi yang ingin dipelajari, '
                'membaca materi, dan mengerjakan quiz untuk menguji pemahaman Anda.',
              ),
              _buildExpansionTile(
                'Bagaimana cara mendapatkan achievement?',
                'Achievement dapat diperoleh dengan menyelesaikan semua materi dan quiz '
                'dalam satu kategori. Setiap kategori memiliki achievementnya '
                'masing-masing.',
              ),
              _buildExpansionTile(
                'Bagaimana cara menambah teman?',
                'Anda dapat menambah teman dengan mencari nama pengguna mereka di '
                'halaman Sosial, atau menerima permintaan pertemanan yang masuk.',
              ),
              _buildExpansionTile(
                'Apa yang terjadi jika saya lupa kata sandi?',
                'Jika Anda lupa kata sandi, gunakan fitur "Lupa Kata Sandi" di '
                'halaman login. Kami akan mengirimkan instruksi untuk mengatur '
                'ulang kata sandi ke email Anda.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Hubungi Kami',
            [
              _buildContactTile(
                'Email',
                'support@nusalearning.com',
                Icons.email,
              ),
              _buildContactTile(
                'WhatsApp',
                '+62 812-3456-7890',
                Icons.phone,
              ),
              _buildContactTile(
                'Instagram',
                '@nusalearning',
                Icons.camera_alt,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Laporkan Masalah',
            [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Temukan bug atau masalah?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bantu kami meningkatkan aplikasi dengan melaporkan masalah yang Anda temui.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showReportDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5722),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Laporkan Masalah',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5722),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF5722)),
      title: Text(title),
      subtitle: Text(value),
      onTap: () {
        // TODO: Implementasi aksi ketika kontak diklik
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Laporkan Masalah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Jelaskan masalah yang Anda temui',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tim kami akan segera menindaklanjuti laporan Anda.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terima kasih atas laporan Anda'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Kirim',
              style: TextStyle(color: Color(0xFFFF5722)),
            ),
          ),
        ],
      ),
    );
  }
} 