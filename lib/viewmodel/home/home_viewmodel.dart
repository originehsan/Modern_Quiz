import 'package:flutter/foundation.dart';
import '../../data/models/question_model.dart';
import '../../data/repositories/quiz_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final QuizRepository repository;

  // State
  List<QuizCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedDifficulty = 0; // 0 = all, 1 = easy, 2 = medium, 3 = hard
  int _selectedQuestionCount = 10;
  final Map<String, double> _categoryProgress = {}; // key: category name

  // Getters
  List<QuizCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedDifficulty => _selectedDifficulty;
  int get selectedQuestionCount => _selectedQuestionCount;
  Map<String, double> get categoryProgress => _categoryProgress;

  String get difficultyText {
    switch (_selectedDifficulty) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Any Difficulty';
    }
  }

  HomeViewModel({required this.repository});

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await repository.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDifficulty(int level) {
    _selectedDifficulty = level;
    notifyListeners();
  }

  void setQuestionCount(int count) {
    _selectedQuestionCount = count;
    notifyListeners();
  }

  String getDifficultyName(int level) {
    switch (level) {
      case 1:
        return 'easy';
      case 2:
        return 'medium';
      case 3:
        return 'hard';
      default:
        return '';
    }
  }

  /// Update stored progress for a given category (0.0 - 1.0).
  void updateCategoryProgress(String category, double percent) {
    final clamped = percent.clamp(0.0, 1.0);
    _categoryProgress[category] = clamped;
    notifyListeners();
  }
}
