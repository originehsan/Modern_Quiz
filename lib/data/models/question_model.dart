import 'package:equatable/equatable.dart';

// ══════════════════════════════════════════════════
// QUESTION MODEL
// ══════════════════════════════════════════════════
class Question extends Equatable {
  final String id;
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers;
  final String? type;

  const Question({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
    this.type,
  });

  @override
  List<Object?> get props =>
      [id, category, difficulty, question, correctAnswer, allAnswers, type];

  factory Question.fromJson(Map<String, dynamic> json) {
    // url3986 encoding → decode with Uri.decodeComponent
    String decode(String text) {
      try {
        return Uri.decodeComponent(text);
      } catch (_) {
        return text; // fallback if already plain text
      }
    }

    final correctAnswer = decode(json['correct_answer']?.toString() ?? '');

    final List<String> incorrectAnswers = [];
    if (json['incorrect_answers'] is List) {
      for (final a in json['incorrect_answers'] as List) {
        incorrectAnswers.add(decode(a.toString()));
      }
    }

    // Combine and shuffle answers
    final allAnswers = [correctAnswer, ...incorrectAnswers]..shuffle();

    return Question(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: decode(json['category']?.toString() ?? ''),
      difficulty: json['difficulty']?.toString() ?? 'medium',
      question: decode(json['question']?.toString() ?? ''),
      correctAnswer: correctAnswer,
      allAnswers: allAnswers,
      type: json['type']?.toString(),
    );
  }
}

// ══════════════════════════════════════════════════
// QUIZ RESULT MODEL
// ══════════════════════════════════════════════════
class QuizResult extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeSpent;
  final String category;
  final String difficulty;
  final DateTime completedAt;
  final int xpEarned;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeSpent,
    required this.category,
    required this.difficulty,
    required this.completedAt,
    required this.xpEarned,
  });

  double get percentage =>
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

  String get badge {
    if (percentage >= 80) return 'Gold';
    if (percentage >= 60) return 'Silver';
    return 'Bronze';
  }

  @override
  List<Object?> get props => [
        totalQuestions,
        correctAnswers,
        wrongAnswers,
        timeSpent,
        category,
        difficulty,
        completedAt,
        xpEarned,
      ];
}

// ══════════════════════════════════════════════════
// QUIZ CATEGORY MODEL
// ══════════════════════════════════════════════════
class QuizCategory extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String description;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, icon, description];
}
