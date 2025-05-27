import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String school;
  final String level;
  final int points;
  final int awards;
  final List<String> friends;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.school,
    this.level = 'Pemula',
    this.points = 0,
    this.awards = 0,
    List<String>? friends,
  }) : friends = friends ?? [];

  // Mengubah data dari Firestore menjadi UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      school: data['school'] ?? '',
      level: data['level'] ?? 'Pemula',
      points: (data['points'] ?? 0).toInt(),
      awards: (data['awards'] ?? 0).toInt(),
      friends: List<String>.from(data['friends'] ?? []),
    );
  }

  // Mengubah UserModel menjadi data untuk Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'school': school,
      'level': level,
      'points': points,
      'awards': awards,
      'friends': friends,
    };
  }

  // Membuat salinan UserModel dengan nilai yang diperbarui
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? school,
    String? level,
    int? points,
    int? awards,
    List<String>? friends,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      school: school ?? this.school,
      level: level ?? this.level,
      points: points ?? this.points,
      awards: awards ?? this.awards,
      friends: friends ?? List<String>.from(this.friends),
    );
  }
}
