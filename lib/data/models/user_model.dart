import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? profileImage;
  final int level;
  final int xpPoints;
  final int totalQuizzesTaken;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastQuizDate;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.profileImage,
    this.level = 1,
    this.xpPoints = 0,
    this.totalQuizzesTaken = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastQuizDate,
    required this.createdAt,
  });

  int get nextLevelXp => (level * 500);
  int get xpProgress => xpPoints % 500;
  int get xpToNextLevel => nextLevelXp - xpProgress;
  double get levelProgress => xpProgress / nextLevelXp;

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profileImage,
    int? level,
    int? xpPoints,
    int? totalQuizzesTaken,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastQuizDate,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      level: level ?? this.level,
      xpPoints: xpPoints ?? this.xpPoints,
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastQuizDate: lastQuizDate ?? this.lastQuizDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profileImage': profileImage,
      'level': level,
      'xpPoints': xpPoints,
      'totalQuizzesTaken': totalQuizzesTaken,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastQuizDate': lastQuizDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profileImage'],
      level: json['level'] ?? 1,
      xpPoints: json['xpPoints'] ?? 0,
      totalQuizzesTaken: json['totalQuizzesTaken'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastQuizDate: json['lastQuizDate'] != null
          ? DateTime.parse(json['lastQuizDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    profileImage,
    level,
    xpPoints,
    totalQuizzesTaken,
    currentStreak,
    longestStreak,
    lastQuizDate,
    createdAt,
  ];
}

class AuthResponse extends Equatable {
  final User user;
  final String token;
  final bool success;
  final String? message;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [user, token, success, message];
}
