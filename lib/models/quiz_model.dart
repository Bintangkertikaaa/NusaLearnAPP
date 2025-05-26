import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromFirestore(Map<String, dynamic> data, String id) {
    return QuizQuestion(
      id: id,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      explanation: data['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class QuizModel {
  final String id;
  final String materialId;
  final String title;
  final String description;
  final int timeLimit;
  final int points;
  final List<QuizQuestion> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizModel({
    required this.id,
    required this.materialId,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.points,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> questionsData =
        List<Map<String, dynamic>>.from(data['questions'] ?? []);

    return QuizModel(
      id: doc.id,
      materialId: data['materialId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      timeLimit: data['timeLimit']?.toInt() ?? 0,
      points: data['points']?.toInt() ?? 0,
      questions: questionsData
          .asMap()
          .entries
          .map((entry) =>
              QuizQuestion.fromFirestore(entry.value, entry.key.toString()))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'materialId': materialId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'points': points,
      'questions': questions.map((q) => q.toFirestore()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  QuizModel copyWith({
    String? id,
    String? materialId,
    String? title,
    String? description,
    int? timeLimit,
    int? points,
    List<QuizQuestion>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      points: points ?? this.points,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
