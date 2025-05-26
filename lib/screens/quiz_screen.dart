import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/material_model.dart';
import '../data/material_data.dart' as material_data;
import '../services/learning_service.dart';
import '../providers/user_provider.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final LearningMaterial material;
  final VoidCallback onQuizCompleted;

  const QuizScreen({
    Key? key,
    required this.material,
    required this.onQuizCompleted,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  int? _selectedAnswerIndex;
  final Random _random = Random();
  bool _isQuizCompleted = false;
  final LearningService _learningService = LearningService();

  // Daftar pertanyaan sesuai dengan materi
  late List<Map<String, dynamic>> _questions;

  // Fungsi untuk mengacak array
  List<dynamic> _shuffleArray(List<dynamic> array) {
    var shuffled = List.from(array);
    for (var i = shuffled.length - 1; i > 0; i--) {
      var j = _random.nextInt(i + 1);
      var temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  // Fungsi untuk menyiapkan pertanyaan dengan jawaban teracak
  Map<String, dynamic> _prepareQuestionWithShuffledAnswers(
      Map<String, dynamic> originalQuestion) {
    var correctAnswer =
        originalQuestion['options'][originalQuestion['correctIndex']];
    var shuffledOptions = _shuffleArray(originalQuestion['options']);
    return {
      'question': originalQuestion['question'],
      'options': shuffledOptions,
      'correctIndex': shuffledOptions.indexOf(correctAnswer),
    };
  }

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> originalQuestions = [];

    // Inisialisasi pertanyaan berdasarkan materi
    if (widget.material.id == 'tari_1') {
      // Tari Saman
      originalQuestions = [
        {
          'question': 'Dari manakah asal Tari Saman?',
          'options': ['Aceh', 'Jawa Barat', 'Bali', 'Sulawesi'],
          'correctIndex': 0,
        },
        {
          'question':
              'Siapakah tokoh yang menggunakan Tari Saman sebagai media dakwah?',
          'options': [
            'Syekh Saman',
            'Sultan Iskandar Muda',
            'Cut Nyak Dien',
            'Teuku Umar'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Apa ciri khas gerakan Tari Saman?',
          'options': [
            'Tepuk tangan, tepuk dada, dan tepuk paha',
            'Gerakan melayang',
            'Putaran cepat',
            'Lompatan tinggi'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Pada tahun berapa Tari Saman diakui UNESCO?',
          'options': ['2011', '2009', '2013', '2015'],
          'correctIndex': 0,
        },
        {
          'question':
              'Apa makna dari gerakan tangan menyilang di dada pada Tari Saman?',
          'options': ['Persaudaraan', 'Keberanian', 'Kesedihan', 'Kegembiraan'],
          'correctIndex': 0,
        },
      ];
    } else if (widget.material.id == 'tari_2') {
      // Tari Pendet
      originalQuestions = [
        {
          'question': 'Dari manakah asal Tari Pendet?',
          'options': ['Bali', 'Jawa Tengah', 'Sumatera', 'Kalimantan'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa fungsi awal Tari Pendet?',
          'options': [
            'Tari pemujaan di pura',
            'Tari hiburan',
            'Tari perang',
            'Tari panen'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Apa yang dibawa penari dalam Tari Pendet?',
          'options': ['Bokor berisi bunga', 'Tombak', 'Kipas', 'Selendang'],
          'correctIndex': 0,
        },
        {
          'question': 'Bagaimana sifat gerakan Tari Pendet?',
          'options': [
            'Lembut dan anggun',
            'Keras dan tegas',
            'Cepat dan dinamis',
            'Kaku dan formal'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Apa musik pengiring Tari Pendet?',
          'options': ['Gamelan Bali', 'Gong', 'Kendang', 'Suling'],
          'correctIndex': 0,
        },
      ];
    } else if (widget.material.id == 'musik_1') {
      // Gamelan
      originalQuestions = [
        {
          'question': 'Dari mana asal Gamelan?',
          'options': ['Jawa dan Bali', 'Sumatera', 'Sulawesi', 'Papua'],
          'correctIndex': 0,
        },
        {
          'question': 'Sejak kapan Gamelan ada?',
          'options': ['Abad ke-8', 'Abad ke-10', 'Abad ke-12', 'Abad ke-14'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa fungsi Kendhang dalam Gamelan?',
          'options': [
            'Mengatur tempo dan ritme',
            'Memberikan melodi utama',
            'Memberi penanda struktur',
            'Memberi ornamentasi'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Berapa jenis laras dalam Gamelan Jawa?',
          'options': ['Dua (Slendro dan Pelog)', 'Tiga', 'Empat', 'Lima'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa perbedaan Gamelan Jawa dan Bali?',
          'options': [
            'Tempo Bali lebih cepat',
            'Gamelan Jawa lebih keras',
            'Gamelan Bali lebih sedikit',
            'Gamelan Jawa tanpa gong'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.material.id == 'musik_2') {
      // Angklung
      originalQuestions = [
        {
          'question': 'Dari mana asal Angklung?',
          'options': ['Jawa Barat', 'Jawa Timur', 'Jawa Tengah', 'Banten'],
          'correctIndex': 0,
        },
        {
          'question': 'Pada tahun berapa Angklung diakui UNESCO?',
          'options': ['2010', '2008', '2012', '2014'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa bahan utama pembuatan Angklung?',
          'options': ['Bambu', 'Kayu', 'Rotan', 'Besi'],
          'correctIndex': 0,
        },
        {
          'question': 'Bagaimana cara memainkan Angklung?',
          'options': [
            'Digetarkan ke kanan dan kiri',
            'Dipukul',
            'Ditiup',
            'Dipetik'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Apa fungsi awal Angklung?',
          'options': [
            'Upacara ritual panen',
            'Hiburan',
            'Alat komunikasi',
            'Pengiring tarian'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.material.id == 'budaya_1') {
      // Upacara Adat
      originalQuestions = [
        {
          'question': 'Di mana upacara Kasada dilaksanakan?',
          'options': [
            'Gunung Bromo',
            'Gunung Merapi',
            'Gunung Semeru',
            'Gunung Rinjani'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Apa yang dipersembahkan dalam upacara Kasada?',
          'options': ['Hasil bumi dan ternak', 'Uang', 'Pakaian', 'Perhiasan'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa fungsi upacara Ngaben di Bali?',
          'options': [
            'Upacara pembakaran jenazah',
            'Upacara pernikahan',
            'Upacara kelahiran',
            'Upacara panen'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Berapa lama upacara Rambu Solo biasanya berlangsung?',
          'options': ['Beberapa hari', 'Satu hari', 'Satu jam', 'Satu bulan'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa salah satu nilai penting dalam upacara adat?',
          'options': [
            'Gotong royong dan kebersamaan',
            'Kompetisi',
            'Individualisme',
            'Materialisme'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.material.id == 'budaya_2') {
      // Rumah Adat
      originalQuestions = [
        {
          'question': 'Apa bentuk atap Rumah Gadang?',
          'options': ['Tanduk kerbau', 'Persegi', 'Bulat', 'Segitiga'],
          'correctIndex': 0,
        },
        {
          'question': 'Dari mana asal Tongkonan?',
          'options': ['Toraja', 'Minang', 'Jawa', 'Bali'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa ciri khas Rumah Joglo?',
          'options': [
            'Atap berbentuk piramida bertingkat',
            'Atap berbentuk perahu',
            'Atap berbentuk kerucut',
            'Atap berbentuk kubah'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Ke mana arah hadap Tongkonan?',
          'options': ['Utara', 'Selatan', 'Timur', 'Barat'],
          'correctIndex': 0,
        },
        {
          'question': 'Apa fungsi Pendopo pada Rumah Joglo?',
          'options': ['Ruang tamu', 'Dapur', 'Kamar tidur', 'Gudang'],
          'correctIndex': 0,
        },
      ];
    }

    // Acak urutan pertanyaan
    List<Map<String, dynamic>> shuffledQuestions =
        List<Map<String, dynamic>>.from(_shuffleArray(originalQuestions));
    originalQuestions = shuffledQuestions.take(5).toList();

    // Siapkan pertanyaan dengan jawaban teracak
    _questions = originalQuestions
        .map((q) => _prepareQuestionWithShuffledAnswers(q))
        .toList();
  }

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _selectedAnswerIndex = selectedIndex;
      if (selectedIndex == _questions[_currentQuestionIndex]['correctIndex']) {
        _score++;
      }
    });

    // Tunggu sebentar sebelum pindah ke pertanyaan berikutnya
    Future.delayed(const Duration(seconds: 2), () async {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _hasAnswered = false;
          _selectedAnswerIndex = null;
        });
      } else {
        // Quiz selesai
        setState(() {
          _isQuizCompleted = true;
        });

        // Update learning progress dan points
        if (_score >= 3) {
          // Minimum 60% benar
          try {
            final userId =
                Provider.of<UserProvider>(context, listen: false).user?.id;
            if (userId != null) {
              await _learningService.completeQuiz(
                  userId, _score, _questions.length);
              widget.onQuizCompleted();
            }
          } catch (e) {
            print('Error updating quiz progress: $e');
          }
        }

        // Tampilkan dialog hasil
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              _score >= 3 ? 'Selamat! 🎉' : 'Coba Lagi 💪',
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skor kamu: $_score dari ${_questions.length}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  _score >= 3
                      ? 'Kamu telah menguasai materi ini!'
                      : 'Baca kembali materinya dan coba lagi ya!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _score >= 3 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke halaman materi
                },
                child: const Text('Selesai'),
              ),
              if (_score < 3)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    setState(() {
                      _currentQuestionIndex = 0;
                      _score = 0;
                      _hasAnswered = false;
                      _selectedAnswerIndex = null;
                      _isQuizCompleted = false;
                      _questions = _questions
                          .map((q) => _prepareQuestionWithShuffledAnswers(q))
                          .toList();
                    });
                  },
                  child: const Text('Coba Lagi'),
                ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        title: const Text(
          'Quiz',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.orange.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
            ),
            const SizedBox(height: 8),
            Text(
              'Pertanyaan ${_currentQuestionIndex + 1} dari ${_questions.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Question
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Answer Options
            ...List.generate(
              _questions[_currentQuestionIndex]['options'].length,
              (index) {
                final option =
                    _questions[_currentQuestionIndex]['options'][index];
                final isCorrect =
                    index == _questions[_currentQuestionIndex]['correctIndex'];
                final isSelected = _selectedAnswerIndex == index;
                final showCorrectness = _hasAnswered && isSelected;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: _hasAnswered ? null : () => _checkAnswer(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCorrectness
                          ? (isCorrect
                              ? Colors.green.shade100
                              : Colors.red.shade100)
                          : Colors.white,
                      foregroundColor: showCorrectness
                          ? (isCorrect
                              ? Colors.green.shade700
                              : Colors.red.shade700)
                          : Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: showCorrectness
                              ? (isCorrect
                                  ? Colors.green.shade200
                                  : Colors.red.shade200)
                              : Colors.orange.shade200,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (showCorrectness)
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
