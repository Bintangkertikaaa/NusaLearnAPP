import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String id;
  final String userId;
  final String userName;
  final int totalPoints;
  final int weeklyPoints;
  final int monthlyPoints;
  final int rank;
  final String userLevel;
  final String userAvatar;
  final DateTime lastUpdated;

  LeaderboardEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.totalPoints,
    required this.weeklyPoints,
    required this.monthlyPoints,
    required this.rank,
    required this.userLevel,
    required this.userAvatar,
    required this.lastUpdated,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      totalPoints: data['totalPoints']?.toInt() ?? 0,
      weeklyPoints: data['weeklyPoints']?.toInt() ?? 0,
      monthlyPoints: data['monthlyPoints']?.toInt() ?? 0,
      rank: data['rank']?.toInt() ?? 0,
      userLevel: data['userLevel'] ?? 'Pemula',
      userAvatar: data['userAvatar'] ?? '',
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'totalPoints': totalPoints,
      'weeklyPoints': weeklyPoints,
      'monthlyPoints': monthlyPoints,
      'rank': rank,
      'userLevel': userLevel,
      'userAvatar': userAvatar,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  LeaderboardEntry copyWith({
    String? id,
    String? userId,
    String? userName,
    int? totalPoints,
    int? weeklyPoints,
    int? monthlyPoints,
    int? rank,
    String? userLevel,
    String? userAvatar,
    DateTime? lastUpdated,
  }) {
    return LeaderboardEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      totalPoints: totalPoints ?? this.totalPoints,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      monthlyPoints: monthlyPoints ?? this.monthlyPoints,
      rank: rank ?? this.rank,
      userLevel: userLevel ?? this.userLevel,
      userAvatar: userAvatar ?? this.userAvatar,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class LeaderboardModel {
  final String id;
  final String type; // 'weekly', 'monthly', 'all-time'
  final DateTime startDate;
  final DateTime endDate;
  final List<LeaderboardEntry> entries;
  final DateTime lastUpdated;

  LeaderboardModel({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.entries,
    required this.lastUpdated,
  });

  factory LeaderboardModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> entriesData =
        List<Map<String, dynamic>>.from(data['entries'] ?? []);

    return LeaderboardModel(
      id: doc.id,
      type: data['type'] ?? 'all-time',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      entries: entriesData
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry(
                id: entry.key.toString(),
                userId: entry.value['userId'] ?? '',
                userName: entry.value['userName'] ?? '',
                totalPoints: entry.value['totalPoints']?.toInt() ?? 0,
                weeklyPoints: entry.value['weeklyPoints']?.toInt() ?? 0,
                monthlyPoints: entry.value['monthlyPoints']?.toInt() ?? 0,
                rank: entry.value['rank']?.toInt() ?? 0,
                userLevel: entry.value['userLevel'] ?? 'Pemula',
                userAvatar: entry.value['userAvatar'] ?? '',
                lastUpdated: entry.value['lastUpdated'] != null
                    ? (entry.value['lastUpdated'] as Timestamp).toDate()
                    : DateTime.now(),
              ))
          .toList(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'entries': entries.map((e) => e.toFirestore()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  LeaderboardModel copyWith({
    String? id,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    List<LeaderboardEntry>? entries,
    DateTime? lastUpdated,
  }) {
    return LeaderboardModel(
      id: id ?? this.id,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      entries: entries ?? this.entries,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
