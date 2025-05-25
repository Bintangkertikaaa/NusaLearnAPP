import 'package:flutter/material.dart';

class MinigamesScreen extends StatefulWidget {
  const MinigamesScreen({Key? key}) : super(key: key);

  @override
  _MinigamesScreenState createState() => _MinigamesScreenState();
}

class _MinigamesScreenState extends State<MinigamesScreen> {
  // Store level completion status and scores
  final Map<String, Map<int, int>> _levelScores = {
    'alat_musik': {},
    'tarian': {},
    'makanan': {},
    'senjata': {},
  };

  bool isLevelUnlocked(String category, int level) {
    if (level == 1) return true;
    
    // Check if previous level is completed
    final previousLevelScore = _levelScores[category]?[level - 1] ?? 0;
    return previousLevelScore > 0;
  }

  int getLevelScore(String category, int level) {
    return _levelScores[category]?[level] ?? 0;
  }

  void updateLevelScore(String category, int level, int score) {
    if (_levelScores[category] == null) {
      _levelScores[category] = {};
    }
    
    // Only update if new score is higher
    final currentScore = _levelScores[category]?[level] ?? 0;
    if (score > currentScore) {
      setState(() {
        _levelScores[category]![level] = score;
      });
    }
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih jenis permainan yang ingin kamu mainkan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            
            // Word Puzzle Game Card
            _buildGameCard(
              context,
              title: 'Word Puzzle',
              description: 'Tebak kata budaya Indonesia dari petunjuk yang diberikan!',
              icon: Icons.quiz,
              color: Colors.purple,
              onTap: () {
                _showCategoryDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryTile(
                    context,
                    title: 'Alat Musik Tradisional',
                    icon: Icons.music_note,
                    color: Colors.purple,
                    category: 'alat_musik',
                  ),
                  _buildCategoryTile(
                    context,
                    title: 'Tarian Tradisional',
                    icon: Icons.directions_run,
                    color: Colors.blue,
                    category: 'tarian',
                  ),
                  _buildCategoryTile(
                    context,
                    title: 'Makanan Tradisional',
                    icon: Icons.restaurant,
                    color: Colors.orange,
                    category: 'makanan',
                  ),
                  _buildCategoryTile(
                    context,
                    title: 'Senjata Tradisional',
                    icon: Icons.gavel,
                    color: Colors.red,
                    category: 'senjata',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String category,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        _showLevelsDialog(context, category, title, color);
      },
    );
  }

  void _showLevelsDialog(BuildContext context, String category, String categoryTitle, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    categoryTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final level = index + 1;
                  final isUnlocked = isLevelUnlocked(category, level);
                  final score = getLevelScore(category, level);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isUnlocked ? () async {
                          Navigator.pop(context);
                          final result = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordPuzzleScreen(
                                category: category,
                                level: level,
                                onLevelComplete: (score) {
                                  updateLevelScore(category, level, score);
                                },
                              ),
                            ),
                          );
                          if (result != null) {
                            updateLevelScore(category, level, result);
                          }
                        } : null,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isUnlocked ? color.withOpacity(0.1) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isUnlocked ? color : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isUnlocked ? color : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$level',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Level $level',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isUnlocked ? Colors.black : Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '5 Soal',
                                      style: TextStyle(
                                        color: isUnlocked ? Colors.black54 : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isUnlocked)
                                const Icon(Icons.lock, color: Colors.grey)
                              else
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$score/50',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Word Puzzle Screen with category parameter
class WordPuzzleScreen extends StatefulWidget {
  final String category;
  final int level;
  final Function(int score)? onLevelComplete;
  
  const WordPuzzleScreen({
    Key? key,
    required this.category,
    required this.level,
    this.onLevelComplete,
  }) : super(key: key);

  @override
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
  late final Map<String, Map<int, List<String>>> _categoryLevelWords = {
    'alat_musik': {
      1: ['GAMELAN', 'ANGKLUNG', 'SASANDO', 'KOLINTANG', 'TIFA'],
      2: ['REBAB', 'KENDANG', 'BONANG', 'SARON', 'GONG'],
      3: ['TALEMPONG', 'SALUANG', 'SERUNAI', 'GAMBUS', 'TEHYAN'],
      4: ['KECAPI', 'SULING', 'GENDANG', 'REBANA', 'GAMBANG'],
      5: ['CALUNG', 'KARINDING', 'CELEMPUNG', 'SITER', 'GENGKONG'],
    },
    'tarian': {
      1: ['SAMAN', 'REOG', 'KECAK', 'PENDET', 'JAIPONG'],
      2: ['SERIMPI', 'GAMBYONG', 'TOPENG', 'PIRING', 'LILIN'],
      3: ['LEGONG', 'BARONG', 'GANDRUNG', 'YAPONG', 'ZAPIN'],
      4: ['SEKAPUR', 'SIRIH', 'MERAK', 'JANGER', 'LENSO'],
      5: ['BEDHAYA', 'REMONG', 'SEUDATI', 'MANDAU', 'PAKARENA'],
    },
    'makanan': {
      1: ['RENDANG', 'GUDEG', 'PAPEDA', 'PEMPEK', 'RAWON'],
      2: ['SOTO', 'SATE', 'GADO', 'BAKSO', 'RUJAK'],
      3: ['PECEL', 'KETOPRAK', 'SERABI', 'KERAK', 'TELOR'],
      4: ['LUMPIA', 'ASINAN', 'LAKSA', 'BIKA', 'KOLAK'],
      5: ['DODOL', 'LEMPER', 'KLEPON', 'ONDE', 'NAGASARI'],
    },
    'senjata': {
      1: ['KERIS', 'RENCONG', 'MANDAU', 'BADIK', 'CLURIT'],
      2: ['KUJANG', 'PEDANG', 'TOMBAK', 'GOLOK', 'CELURIT'],
      3: ['SIWAR', 'PISO', 'KARIH', 'DOHONG', 'PARANG'],
      4: ['KELEWANG', 'ALAMANG', 'WEDUNG', 'PISAU', 'MATA'],
      5: ['BELADAU', 'JENAWI', 'DUHUNG', 'SUNDU', 'BADAU'],
    },
  };

  late final Map<String, Map<int, List<String>>> _categoryLevelHints = {
    'alat_musik': {
      1: [
        'Alat musik tradisional dari Jawa yang terdiri dari berbagai instrumen',
        'Alat musik bambu dari Sunda yang dimainkan dengan cara digoyangkan',
        'Alat musik petik tradisional dari Nusa Tenggara Timur',
        'Alat musik pukul dari Sulawesi Utara',
        'Alat musik tabuh tradisional dari Papua',
      ],
      2: [
        'Alat musik gesek tradisional Jawa',
        'Alat musik pukul berbentuk tabung dari kayu',
        'Alat musik pukul berbentuk gong kecil',
        'Alat musik pukul berbentuk bilah logam',
        'Alat musik pukul berbentuk lingkaran besar',
      ],
      3: [
        'Alat musik pukul dari Minangkabau',
        'Alat musik tiup dari Minangkabau',
        'Alat musik tiup dari Sumatera Barat',
        'Alat musik petik dari Melayu',
        'Alat musik gesek dari Betawi',
      ],
      4: [
        'Alat musik petik dari Sunda',
        'Alat musik tiup dari bambu',
        'Alat musik pukul berbentuk tabung',
        'Alat musik pukul berbentuk bulat',
        'Alat musik pukul dari bilah kayu',
      ],
      5: [
        'Alat musik bambu dari Jawa Barat',
        'Alat musik bambu dari Sunda',
        'Alat musik petik dari Jawa',
        'Alat musik petik berbentuk siter',
        'Alat musik tiup dari Sunda',
      ],
    },
    'tarian': {
      1: [
        'Tarian tradisional dari Aceh dengan gerakan tangan yang cepat',
        'Tarian tradisional dari Ponorogo dengan topeng besar',
        'Tarian api dari Bali yang dimainkan berkelompok',
        'Tarian selamat datang dari Bali',
        'Tarian tradisional Sunda yang energik',
      ],
      2: [
        'Tarian klasik dari keraton Yogyakarta',
        'Tarian tradisional dari Jawa Tengah',
        'Tarian tradisional dengan topeng',
        'Tarian dengan piring sebagai properti',
        'Tarian dengan lilin sebagai properti',
      ],
      3: [
        'Tarian klasik dari Bali',
        'Tarian topeng sakral dari Bali',
        'Tarian dari Banyuwangi',
        'Tarian tradisional Betawi',
        'Tarian Melayu',
      ],
      4: [
        'Tarian persembahan dari Jambi',
        'Tarian dengan sirih',
        'Tarian yang menirukan burung merak',
        'Tarian gembira dari Bali',
        'Tarian dari Maluku',
      ],
      5: [
        'Tarian sakral dari keraton',
        'Tarian dari Jawa Timur',
        'Tarian pria dari Aceh',
        'Tarian perang dari Dayak',
        'Tarian dari Sulawesi Selatan',
      ],
    },
    'makanan': {
      1: [
        'Masakan daging dengan santan dari Padang',
        'Masakan nangka muda khas Yogyakarta',
        'Makanan dari sagu khas Papua',
        'Makanan dari ikan khas Palembang',
        'Sup daging hitam khas Jawa Timur',
      ],
      2: [
        'Sup tradisional Indonesia',
        'Makanan dari daging tusuk',
        'Sayuran dengan bumbu kacang',
        'Makanan dari daging dan tepung',
        'Buah dan sayur dengan bumbu',
      ],
      3: [
        'Sayuran dengan bumbu kacang',
        'Makanan dengan tahu dan bumbu kacang',
        'Kue tradisional dari tepung beras',
        'Makanan tradisional Betawi',
        'Makanan dari telur',
      ],
      4: [
        'Makanan goreng dari Semarang',
        'Makanan dengan bumbu kacang',
        'Sup dengan mie dan udang',
        'Kue tradisional dari Medan',
        'Makanan manis dengan santan',
      ],
      5: [
        'Makanan manis dari gula aren',
        'Makanan dari ketan dan ayam',
        'Kue dari tepung beras dan kelapa',
        'Kue bulat dengan kacang hijau',
        'Kue dari tepung beras dan pisang',
      ],
    },
    'senjata': {
      1: [
        'Senjata tradisional dari Jawa berbentuk pisau berlekuk',
        'Senjata tradisional dari Aceh',
        'Senjata tradisional suku Dayak Kalimantan',
        'Senjata tradisional dari Sulawesi Selatan',
        'Senjata tradisional dari Madura',
      ],
      2: [
        'Senjata tradisional dari Sunda',
        'Senjata panjang tradisional',
        'Senjata untuk melempar',
        'Senjata tradisional untuk menebas',
        'Senjata melengkung dari Madura',
      ],
      3: [
        'Senjata tradisional Minangkabau',
        'Senjata tradisional Batak',
        'Senjata tradisional Minangkabau',
        'Senjata tradisional Dayak',
        'Senjata untuk menebas',
      ],
      4: [
        'Pedang panjang tradisional',
        'Senjata tradisional Aceh',
        'Senjata pendek tradisional',
        'Senjata tajam tradisional',
        'Senjata dengan mata tajam',
      ],
      5: [
        'Senjata tradisional Melayu',
        'Senjata tradisional Jawa',
        'Senjata tradisional Dayak',
        'Senjata tradisional Bugis',
        'Senjata tradisional Banjar',
      ],
    },
  };

  late final Map<String, Map<int, List<String>>> _categoryLevelDescriptions = {
    'alat_musik': {
      1: [
        'Gamelan adalah ensembel musik tradisional yang terdiri dari berbagai instrumen seperti gong, kenong, dan saron. Gamelan merupakan warisan budaya yang sangat penting dalam tradisi Jawa.',
        'Angklung adalah alat musik bambu yang menghasilkan nada ketika digoyangkan. UNESCO mengakuinya sebagai Warisan Budaya Tak Benda pada tahun 2010.',
        'Sasando adalah alat musik petik tradisional dari Pulau Rote, NTT. Terbuat dari daun lontar yang dibentuk tabung dengan senar yang direntangkan.',
        'Kolintang adalah alat musik pukul tradisional yang terbuat dari kayu. Berasal dari Minahasa, Sulawesi Utara.',
        'Tifa adalah alat musik tabuh tradisional dari Papua, terbuat dari kayu yang dilubangi dan kulit rusa atau sapi sebagai membran.',
      ],
      2: [
        'Rebab adalah alat musik gesek tradisional yang penting dalam musik gamelan.',
        'Kendang adalah alat musik pukul yang mengatur irama dalam musik gamelan.',
        'Bonang adalah rangkaian gong kecil yang ditata horizontal.',
        'Saron adalah alat musik pukul berbentuk bilah logam.',
        'Gong adalah alat musik pukul besar yang menandai struktur gending.',
      ],
      3: [
        'Talempong adalah alat musik pukul dari kuningan khas Minangkabau.',
        'Saluang adalah alat musik tiup dari bambu khas Minangkabau.',
        'Serunai adalah alat musik tiup tradisional Minangkabau.',
        'Gambus adalah alat musik petik yang berasal dari Timur Tengah.',
        'Tehyan adalah alat musik gesek tradisional Betawi.',
      ],
      4: [
        'Kecapi adalah alat musik petik tradisional Sunda.',
        'Suling adalah alat musik tiup dari bambu.',
        'Gendang adalah alat musik pukul berbentuk tabung.',
        'Rebana adalah alat musik pukul berbentuk bulat.',
        'Gambang adalah alat musik pukul dari bilah kayu.',
      ],
      5: [
        'Calung adalah alat musik bambu dari Jawa Barat.',
        'Karinding adalah alat musik tiup dari bambu.',
        'Celempung adalah alat musik petik mirip siter.',
        'Siter adalah alat musik petik dari Jawa.',
        'Gengkong adalah alat musik tiup dari Sunda.',
      ],
    },
    'tarian': {
      1: [
        'Tari Saman adalah tarian tradisional Aceh yang menampilkan gerakan tangan dan tepukan yang terkoordinasi. UNESCO mengakuinya sebagai Warisan Budaya Tak Benda.',
        'Reog adalah tarian yang menampilkan topeng besar dengan bulu merak. Penari utama harus memiliki kekuatan khusus untuk membawa topeng yang berat.',
        'Tari Kecak adalah tarian Bali yang dimainkan oleh puluhan penari membentuk lingkaran. Mereka menyanyikan "cak" sambil menceritakan Ramayana.',
        'Tari Pendet awalnya adalah tarian pemujaan yang dipersembahkan di pura. Kini berkembang menjadi tarian selamat datang.',
        'Jaipong adalah tarian dinamis yang menggabungkan gerakan pencak silat, ketuk tilu, dan dogdog lojor.',
      ],
      2: [
        'Serimpi adalah tarian klasik sakral dari keraton Yogyakarta.',
        'Gambyong adalah tarian penyambutan dari Jawa Tengah.',
        'Topeng adalah tarian tradisional dengan menggunakan topeng.',
        'Piring adalah tarian dengan menggunakan piring sebagai properti.',
        'Lilin adalah tarian dengan lilin menyala di telapak tangan.',
      ],
      3: [
        'Legong adalah tarian klasik Bali yang anggun.',
        'Barong adalah tarian sakral yang menggambarkan kebaikan.',
        'Gandrung adalah tarian selamat datang dari Banyuwangi.',
        'Yapong adalah tarian pergaulan dari Betawi.',
        'Zapin adalah tarian Melayu yang dipengaruhi budaya Arab.',
      ],
      4: [
        'Sekapur Sirih adalah tarian persembahan dari Jambi.',
        'Sirih adalah tarian yang menggunakan properti daun sirih.',
        'Merak adalah tarian yang menirukan gerak burung merak.',
        'Janger adalah tarian pergaulan dari Bali.',
        'Lenso adalah tarian dengan sapu tangan dari Maluku.',
      ],
      5: [
        'Bedhaya adalah tarian sakral dari keraton.',
        'Remong adalah tarian dari Jawa Timur.',
        'Seudati adalah tarian pria dari Aceh.',
        'Mandau adalah tarian perang dari suku Dayak.',
        'Pakarena adalah tarian klasik dari Sulawesi Selatan.',
      ],
    },
    'makanan': {
      1: [
        'Rendang adalah masakan daging dengan santan dan rempah hingga kering dan kehitaman. CNN menyebutnya sebagai hidangan terlezat di dunia.',
        'Gudeg adalah masakan dari nangka muda yang dimasak dengan santan dan gula aren. Menjadi ikon kuliner Yogyakarta.',
        'Papeda adalah makanan khas Papua yang terbuat dari sagu. Biasanya disajikan dengan ikan kuah kuning.',
        'Pempek adalah makanan dari ikan dan sagu khas Palembang. Disajikan dengan kuah cuka yang khas.',
        'Rawon adalah sup daging dengan kuah hitam dari kluwek. Makanan khas Jawa Timur yang sangat populer.',
      ],
      2: [
        'Soto adalah sup tradisional dengan kuah kuning.',
        'Sate adalah daging tusuk yang dipanggang.',
        'Gado-gado adalah sayuran dengan bumbu kacang.',
        'Bakso adalah bola daging dengan kuah kaldu.',
        'Rujak adalah buah dan sayur dengan bumbu pedas.',
      ],
      3: [
        'Pecel adalah sayuran dengan bumbu kacang.',
        'Ketoprak adalah makanan dengan tahu dan bumbu kacang.',
        'Serabi adalah kue tradisional dari tepung beras.',
        'Kerak Telor adalah makanan tradisional Betawi.',
        'Telor adalah bahan utama makanan ini.',
      ],
      4: [
        'Lumpia adalah makanan goreng berisi rebung.',
        'Asinan adalah makanan dengan bumbu kacang.',
        'Laksa adalah sup dengan mie dan udang.',
        'Bika adalah kue tradisional dari Medan.',
        'Kolak adalah makanan manis dengan santan.',
      ],
      5: [
        'Dodol adalah makanan manis dari gula aren.',
        'Lemper adalah makanan dari ketan berisi ayam.',
        'Klepon adalah kue dari tepung beras isi gula.',
        'Onde-onde adalah kue bulat berisi kacang hijau.',
        'Nagasari adalah kue dari tepung beras berisi pisang.',
      ],
    },
    'senjata': {
      1: [
        'Keris adalah senjata tikam dengan bilah berlekuk. UNESCO mengakuinya sebagai Warisan Budaya Tak Benda pada tahun 2005.',
        'Rencong adalah senjata tradisional Aceh yang bentuknya mirip huruf L. Memiliki nilai spiritual dan simbol perjuangan.',
        'Mandau adalah senjata tradisional suku Dayak berupa pedang dengan ukiran di bilahnya.',
        'Badik adalah senjata tradisional Bugis-Makassar yang dianggap memiliki kekuatan spiritual.',
        'Clurit adalah senjata tradisional Madura berbentuk melengkung seperti bulan sabit.',
      ],
      2: [
        'Kujang adalah senjata tradisional dari Sunda.',
        'Pedang adalah senjata panjang tradisional.',
        'Tombak adalah senjata untuk melempar.',
        'Golok adalah senjata untuk menebas.',
        'Celurit adalah senjata melengkung dari Madura.',
      ],
      3: [
        'Siwar adalah senjata tradisional Minangkabau.',
        'Piso adalah senjata tradisional Batak.',
        'Karih adalah senjata tradisional Minangkabau.',
        'Dohong adalah senjata tradisional Dayak.',
        'Parang adalah senjata untuk menebas.',
      ],
      4: [
        'Kelewang adalah pedang panjang tradisional.',
        'Alamang adalah senjata tradisional Aceh.',
        'Wedung adalah senjata pendek tradisional.',
        'Pisau adalah senjata tajam tradisional.',
        'Mata adalah bagian tajam dari senjata.',
      ],
      5: [
        'Beladau adalah senjata tradisional Melayu.',
        'Jenawi adalah senjata tradisional Jawa.',
        'Duhung adalah senjata tradisional Dayak.',
        'Sundu adalah senjata tradisional Bugis.',
        'Badau adalah senjata tradisional Banjar.',
      ],
    },
  };

  late List<String> _words;
  late List<String> _hints;
  late List<String> _descriptions;
  late String _currentWord;
  late String _currentHint;
  late List<String> _shuffledWord;
  List<String> _selectedLetters = [];
  bool _isCorrect = false;
  int _score = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _words = _categoryLevelWords[widget.category]![widget.level]!;
    _hints = _categoryLevelHints[widget.category]![widget.level]!;
    _descriptions = _categoryLevelDescriptions[widget.category]![widget.level]!;
    _initializeGame();
  }

  void _initializeGame() {
    _currentWord = _words[_currentIndex];
    _currentHint = _hints[_currentIndex];
    _shuffledWord = _shuffleWord(_currentWord);
    _selectedLetters = [];
    _isCorrect = false;
  }

  List<String> _shuffleWord(String word) {
    List<String> letters = word.split('');
    for (int i = letters.length - 1; i > 0; i--) {
      int j = (DateTime.now().millisecondsSinceEpoch % (i + 1));
      String temp = letters[i];
      letters[i] = letters[j];
      letters[j] = temp;
    }
    return letters;
  }

  void _selectLetter(String letter) {
    if (_selectedLetters.length < _currentWord.length && !_isCorrect) {
      setState(() {
        _selectedLetters.add(letter);
        if (_selectedLetters.length == _currentWord.length) {
          _checkAnswer();
        }
      });
    }
  }

  void _removeLetter() {
    if (_selectedLetters.isNotEmpty && !_isCorrect) {
      setState(() {
        _selectedLetters.removeLast();
      });
    }
  }

  void _checkAnswer() {
    String answer = _selectedLetters.join();
    if (answer == _currentWord) {
      setState(() {
        _isCorrect = true;
        _score += 10;
        Future.delayed(const Duration(seconds: 1), () {
          _showSuccessDialog();
        });
      });
    }
  }

  void _nextWord() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _initializeGame();
      });
    } else {
      _showGameCompleteDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFFFF5722),
            ),
            const SizedBox(width: 8),
            const Text('Selamat!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jawaban Anda benar: ${_words[_currentIndex]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tahukah kamu?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5722),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _descriptions[_currentIndex],
                style: const TextStyle(height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              Text(
                'Skor saat ini: $_score',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5722),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextWord();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF5722),
            ),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  void _showGameCompleteDialog() {
    if (widget.onLevelComplete != null) {
      widget.onLevelComplete!(_score);
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFFF5722)),
            const SizedBox(width: 8),
            const Text('Level Selesai!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat! Anda telah menyelesaikan Level ${widget.level}'),
            const SizedBox(height: 8),
            Text('Skor level ini: $_score'),
            if (widget.level < 5)
              const Text('\nLevel selanjutnya telah dibuka!'),
          ],
        ),
        actions: [
          if (widget.level < 5)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordPuzzleScreen(
                      category: widget.category,
                      level: widget.level + 1,
                      onLevelComplete: widget.onLevelComplete,
                    ),
                  ),
                );
              },
              child: const Text('Level Selanjutnya'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, _score);
            },
            child: const Text('Kembali ke Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String categoryTitle = '';
    switch (widget.category) {
      case 'alat_musik':
        categoryTitle = 'Alat Musik';
        break;
      case 'tarian':
        categoryTitle = 'Tarian';
        break;
      case 'makanan':
        categoryTitle = 'Makanan';
        break;
      case 'senjata':
        categoryTitle = 'Senjata';
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: Text(
          'Level ${widget.level} - $categoryTitle',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Score
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skor: $_score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kata ${_currentIndex + 1}/${_words.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Hint
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Petunjuk:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Selected Letters
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _currentWord.length,
                (index) => Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isCorrect ? Colors.green : const Color(0xFFFF5722),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      index < _selectedLetters.length ? _selectedLetters[index] : '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Letter Buttons
          if (!_isCorrect)
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _shuffledWord.map((letter) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _selectLetter(letter),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Delete Button
          if (!_isCorrect)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _removeLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.backspace, color: Colors.white),
                label: const Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 