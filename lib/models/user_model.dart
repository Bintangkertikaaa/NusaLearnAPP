class UserModel {
  final String id;
  final String name;
  final String email;
  final String school;
  final String level;
  final int points;
  final int awards;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.school,
    required this.level,
    this.points = 0,
    this.awards = 0,
  });

  // Mengubah data dari Firestore menjadi UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      school: data['school'] ?? '',
      level: data['level'] ?? 'Pemula',
      points: data['points']?.toInt() ?? 0,
      awards: data['awards']?.toInt() ?? 0,
    );
  }

  // Mengubah UserModel menjadi format yang bisa disimpan di Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'school': school,
      'level': level,
      'points': points,
      'awards': awards,
    };
  }

  // Method untuk membuat salinan objek dengan nilai yang diperbarui
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? school,
    String? level,
    int? points,
    int? awards,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      school: school ?? this.school,
      level: level ?? this.level,
      points: points ?? this.points,
      awards: awards ?? this.awards,
    );
  }
}
