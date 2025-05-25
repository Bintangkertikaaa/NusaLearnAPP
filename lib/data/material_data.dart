import '../models/material_model.dart';

final List<Category> categories = [
  Category(
    id: 'tari',
    name: 'Tari Tradisional',
    icon: '💃',
    description: 'Pelajari berbagai tarian tradisional Indonesia',
  ),
  Category(
    id: 'musik',
    name: 'Alat Musik Tradisional',
    icon: '🎵',
    description: 'Kenali alat musik tradisional nusantara',
  ),
  Category(
    id: 'budaya',
    name: 'Budaya Kita',
    icon: '🏛️',
    description: 'Jelajahi kekayaan budaya Indonesia',
  ),
];

final List<LearningMaterial> materials = [
  // Tari Tradisional
  LearningMaterial(
    id: 'tari_1',
    categoryId: 'tari',
    title: 'Tari Saman',
    description: 'Tarian tradisional dari Aceh yang menampilkan gerakan ritmis dan kompak',
    content: '''
Tari Saman adalah tarian tradisional yang berasal dari suku Gayo, Aceh. Tarian ini mencerminkan pendidikan, keagamaan, sopan santun, kepahlawanan, dan kekompakan. Tari Saman ditetapkan UNESCO sebagai Warisan Budaya Tak Benda Dunia pada tahun 2011.

Sejarah:
Tari Saman diciptakan oleh Syekh Saman, seorang ulama yang menyebarkan agama Islam di Aceh. Awalnya, tarian ini merupakan media dakwah untuk menyebarkan agama Islam di Aceh.

Gerakan:
- Gerakan tangan menyilang di dada melambangkan persaudaraan
- Tepuk dada menandakan semangat dan keberanian
- Gerakan serempak menunjukkan kekompakan dan persatuan

Kostum:
Para penari mengenakan pakaian adat Gayo dengan warna-warna cerah dan dilengkapi dengan ornamen khas Aceh.

Musik:
Tari Saman tidak menggunakan alat musik. Musik pengiring hanya berupa nyanyian syair dalam bahasa Gayo dan tepukan tangan para penari.
    ''',
    category: 'Tari Tradisional',
  ),
  LearningMaterial(
    id: 'tari_2',
    categoryId: 'tari',
    title: 'Tari Pendet',
    description: 'Tarian tradisional Bali yang penuh keanggunan',
    content: '''
Tari Pendet adalah tarian tradisional yang berasal dari Bali. Tarian ini awalnya merupakan tari pemujaan yang dilakukan di pura-pura di Bali, namun sekarang juga dipentaskan sebagai tari penyambutan.

Sejarah:
Tari Pendet mulanya adalah tarian sakral yang dilakukan di pura sebagai persembahan kepada para dewa. Seiring waktu, tarian ini berkembang menjadi tarian selamat datang yang hangat dan mengundang.

Gerakan:
- Gerakan lembut dan anggun mencerminkan keramahan
- Gerakan menabur bunga sebagai simbol pemberian restu dan kebahagiaan
- Gerakan tangan dan tubuh yang gemulai menggambarkan keanggunan wanita Bali

Kostum:
- Penari mengenakan pakaian adat Bali
- Kain songket atau kamen
- Kemben atau angkin
- Hiasan kepala dengan bunga kamboja

Properti:
- Bokor berisi bunga yang ditaburkan sebagai simbol persembahan
- Dupa atau canang sari

Musik Pengiring:
Tarian ini diiringi gamelan Bali dengan irama yang lembut dan mengalun, menciptakan suasana sakral dan khidmat.
    ''',
    category: 'Tari Tradisional',
  ),

  // Alat Musik Tradisional
  LearningMaterial(
    id: 'musik_1',
    categoryId: 'musik',
    title: 'Gamelan',
    description: 'Alat musik tradisional dari Jawa dan Bali yang dimainkan secara ansambel',
    content: '''
Gamelan adalah ensembel musik tradisional yang berasal dari pulau Jawa dan Bali. Gamelan terdiri dari berbagai instrumen musik perkusi yang dimainkan bersama secara harmonis.

Sejarah:
Gamelan telah ada sejak abad ke-8 dan berkembang di keraton-keraton Jawa. Gamelan menjadi bagian penting dalam upacara kerajaan, pertunjukan wayang kulit, dan berbagai ritual budaya.

Instrumen Utama:
- Gong: Memberikan penanda struktur musik
- Kendhang: Mengatur tempo dan ritme
- Bonang: Memainkan melodi
- Saron: Memainkan melodi utama
- Gambang: Memberikan ornamentasi melodi

Jenis Gamelan:
1. Gamelan Jawa
- Nada lebih halus dan lembut
- Terdiri dari dua laras: Slendro dan Pelog
- Sering mengiringi pertunjukan wayang kulit

2. Gamelan Bali
- Tempo lebih cepat dan dinamis
- Memiliki variasi ritme yang kompleks
- Sering digunakan dalam upacara keagamaan

Fungsi dan Penggunaan:
- Mengiringi tarian tradisional
- Pertunjukan wayang kulit
- Upacara adat dan keagamaan
- Pertunjukan mandiri (klenengan)
    ''',
    category: 'Alat Musik Tradisional',
  ),
  LearningMaterial(
    id: 'musik_2',
    categoryId: 'musik',
    title: 'Angklung',
    description: 'Alat musik tradisional dari Jawa Barat yang terbuat dari bambu',
    content: '''
Angklung adalah alat musik tradisional yang berasal dari Jawa Barat. Alat musik ini terbuat dari bambu yang dirangkai dan menghasilkan bunyi merdu saat digetarkan.

Sejarah:
Angklung sudah ada sejak zaman Kerajaan Sunda. Awalnya digunakan dalam upacara ritual panen padi dan upacara adat Sunda. Pada tahun 2010, UNESCO mengakui Angklung sebagai Warisan Budaya Dunia.

Bagian-bagian Angklung:
- Rangka: Tempat menggantung tabung bambu
- Tabung suara: Terbuat dari bambu, menghasilkan nada
- Dasar: Penopang rangka
- Tali pengikat: Menghubungkan bagian-bagian angklung

Cara Memainkan:
- Pegang angklung dengan tangan kanan pada rangka atas
- Tangan kiri memegang bagian bawah
- Getarkan dengan gerakan ke kanan dan kiri
- Bisa dimainkan sendiri atau berkelompok

Nilai-nilai yang Terkandung:
- Gotong royong (dalam permainan berkelompok)
- Kesabaran dan ketelitian
- Pelestarian lingkungan (penggunaan bambu)
    ''',
    category: 'Alat Musik Tradisional',
  ),

  // Budaya
  LearningMaterial(
    id: 'budaya_1',
    categoryId: 'budaya',
    title: 'Upacara Adat',
    description: 'Mengenal berbagai upacara adat di Indonesia',
    content: '''
Upacara adat adalah bagian penting dari kehidupan masyarakat Indonesia yang mencerminkan kearifan lokal dan nilai-nilai budaya yang diwariskan secara turun-temurun.

Beberapa Upacara Adat di Indonesia:

1. Kasada (Suku Tengger, Jawa Timur)
- Dilaksanakan di Gunung Bromo
- Ritual persembahan kepada Sang Hyang Widhi
- Mempersembahkan hasil bumi dan ternak
- Dilakukan pada bulan ke-12 penanggalan Tengger

2. Ngaben (Bali)
- Upacara pembakaran jenazah
- Simbol pelepasan roh dari dunia
- Prosesi yang sangat sakral
- Membutuhkan persiapan yang panjang

3. Rambu Solo (Toraja, Sulawesi Selatan)
- Upacara pemakaman adat
- Berlangsung selama beberapa hari
- Melibatkan seluruh keluarga besar
- Simbol penghormatan kepada leluhur

Nilai-nilai dalam Upacara Adat:
- Penghormatan kepada leluhur
- Keseimbangan alam dan manusia
- Gotong royong dan kebersamaan
- Pelestarian tradisi dan budaya
    ''',
    category: 'Budaya Kita',
  ),
  LearningMaterial(
    id: 'budaya_2',
    categoryId: 'budaya',
    title: 'Rumah Adat',
    description: 'Mengenal keragaman rumah adat di Indonesia',
    content: '''
Rumah adat adalah warisan arsitektur tradisional Indonesia yang mencerminkan kearifan lokal dan adaptasi terhadap lingkungan. Setiap daerah memiliki keunikan dalam bentuk dan filosofi rumah adatnya.

Beberapa Rumah Adat Terkenal:

1. Rumah Gadang (Minangkabau)
- Atap berbentuk tanduk kerbau
- Terbagi menjadi beberapa ruang
- Sistem matrilineal
- Filosofi "Adat basandi syarak, syarak basandi Kitabullah"

2. Tongkonan (Toraja)
- Atap melengkung seperti perahu
- Terdiri dari tiga bagian utama
- Arah hadap ke utara
- Simbol status sosial

3. Rumah Joglo (Jawa)
- Atap berbentuk piramida bertingkat
- Tiang utama (soko guru)
- Pendopo sebagai ruang tamu
- Filosofi kesatuan dengan alam

Fungsi Rumah Adat:
- Tempat tinggal
- Tempat musyawarah
- Tempat upacara adat
- Simbol status sosial

Nilai Arsitektur:
- Adaptasi terhadap iklim
- Penggunaan bahan lokal
- Teknik konstruksi tradisional
- Filosofi kehidupan masyarakat
    ''',
    category: 'Budaya Kita',
  ),
]; 