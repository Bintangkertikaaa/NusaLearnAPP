import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final String userId;
  final String materialId;
  final bool isCompleted;
  final int score;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> notes;
  final int timeSpentMinutes;
  final Map<String, bool> checkpoints;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.materialId,
    required this.isCompleted,
    required this.score,
    required this.startedAt,
    this.completedAt,
    required this.notes,
    required this.timeSpentMinutes,
    required this.checkpoints,
  });

  factory ProgressModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProgressModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      materialId: data['materialId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      score: data['score']?.toInt() ?? 0,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      notes: List<String>.from(data['notes'] ?? []),
      timeSpentMinutes: data['timeSpentMinutes']?.toInt() ?? 0,
      checkpoints: Map<String, bool>.from(data['checkpoints'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'materialId': materialId,
      'isCompleted': isCompleted,
      'score': score,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'notes': notes,
      'timeSpentMinutes': timeSpentMinutes,
      'checkpoints': checkpoints,
    };
  }

  ProgressModel copyWith({
    String? id,
    String? userId,
    String? materialId,
    bool? isCompleted,
    int? score,
    DateTime? startedAt,
    DateTime? completedAt,
    List<String>? notes,
    int? timeSpentMinutes,
    Map<String, bool>? checkpoints,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      materialId: materialId ?? this.materialId,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }
}
