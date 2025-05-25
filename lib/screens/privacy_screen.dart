import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showProfile = true;
  bool _showProgress = true;
  bool _allowFriendRequests = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Privasi',
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
            'Pengaturan Privasi',
            [
              _buildSwitchTile(
                'Tampilkan Profil',
                'Izinkan pengguna lain melihat profil Anda',
                _showProfile,
                (value) {
                  setState(() {
                    _showProfile = value;
                  });
                  _showSettingChangedSnackbar('Tampilkan Profil', value);
                },
              ),
              _buildSwitchTile(
                'Tampilkan Progress',
                'Izinkan pengguna lain melihat progress pembelajaran Anda',
                _showProgress,
                (value) {
                  setState(() {
                    _showProgress = value;
                  });
                  _showSettingChangedSnackbar('Tampilkan Progress', value);
                },
              ),
              _buildSwitchTile(
                'Terima Permintaan Pertemanan',
                'Izinkan pengguna lain mengirim permintaan pertemanan',
                _allowFriendRequests,
                (value) {
                  setState(() {
                    _allowFriendRequests = value;
                  });
                  _showSettingChangedSnackbar('Terima Permintaan Pertemanan', value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Informasi',
            [
              _buildInfoTile(
                'Kebijakan Privasi',
                'Pelajari bagaimana kami melindungi data Anda',
                onTap: () {
                  _showPrivacyPolicyDialog();
                },
              ),
              _buildInfoTile(
                'Ketentuan Layanan',
                'Baca ketentuan penggunaan aplikasi',
                onTap: () {
                  _showTermsOfServiceDialog();
                },
              ),
              _buildInfoTile(
                'Data Saya',
                'Kelola data pribadi Anda',
                onTap: () {
                  _showMyDataDialog();
                },
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

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF5722),
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showSettingChangedSnackbar(String setting, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$setting ${value ? 'diaktifkan' : 'dinonaktifkan'}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: const SingleChildScrollView(
          child: Text(
            'Kami menghargai privasi Anda. Data yang kami kumpulkan hanya digunakan '
            'untuk meningkatkan pengalaman belajar Anda. Kami tidak akan membagikan '
            'data pribadi Anda kepada pihak ketiga tanpa izin Anda.\n\n'
            'Data yang kami kumpulkan:\n'
            '• Informasi profil\n'
            '• Progress pembelajaran\n'
            '• Aktivitas dalam aplikasi\n\n'
            'Anda dapat mengontrol data apa yang ingin Anda bagikan melalui '
            'pengaturan privasi.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ketentuan Layanan'),
        content: const SingleChildScrollView(
          child: Text(
            'Dengan menggunakan aplikasi ini, Anda setuju untuk:\n\n'
            '1. Menggunakan aplikasi sesuai dengan tujuannya\n'
            '2. Tidak menyalahgunakan fitur yang tersedia\n'
            '3. Menghormati pengguna lain\n'
            '4. Menjaga kerahasiaan akun Anda\n'
            '5. Tidak membagikan konten yang melanggar hukum\n\n'
            'Kami berhak menonaktifkan akun yang melanggar ketentuan ini.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showMyDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Saya'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataItem('Nama', 'Tasya'),
            _buildDataItem('Email', 'tasya@example.com'),
            _buildDataItem('Sekolah', 'SMA N 1 Jakarta'),
            _buildDataItem('Bergabung sejak', '1 Januari 2024'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteAccountDialog();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Hapus Akun'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus akun? '
          'Tindakan ini tidak dapat dibatalkan dan semua data Anda akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementasi penghapusan akun
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Akun berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 