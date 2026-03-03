import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../../data/models/question_model.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../core/constants/app_constants.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizRepository repository;

  // State
  List<Question> _questions = [];
  List<QuizCategory> _categories = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _timeSpent = 0;
  int _timeRemaining = AppConstants.questionTimeLimit;
  bool _isLoading = false;
  bool _isAnswered = false;
  bool _showResult = false; // whether to show correct/wrong feedback
  String? _selectedAnswer;
  String? _errorMessage;
  final Map<int, String> _answers = {};
  late DateTime _quizStartTime;

  /// Per‑category quiz completion progress (0.0 ‑ 1.0)
  final Map<String, double> _categoryProgress = {};

  /// Countdown timer controller managed from the view model
  final CountDownController _timerController = CountDownController();
  Timer? _timeUpdateDebounce;

  // Simple in-memory quiz history
  final List<QuizResult> _history = [];
  String? lastCompletedCategory; // Track selected category for progress display

  // Getters
  List<Question> get questions => _questions;
  List<QuizCategory> get categories => _categories;
  int get currentQuestionIndex => _currentQuestionIndex;
  Question? get currentQuestion => _currentQuestionIndex < _questions.length
      ? _questions[_currentQuestionIndex]
      : null;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  int get timeSpent => _timeSpent;
  int get timeRemaining => _timeRemaining;
  bool get isLoading => _isLoading;
  bool get isAnswered => _isAnswered;
  bool get showResult => _showResult; // show correct/wrong feedback
  String? get selectedAnswer => _selectedAnswer;
  String? get errorMessage => _errorMessage;
  int get totalQuestions => _questions.length;
  double get progressPercent =>
      _questions.isEmpty ? 0 : (_currentQuestionIndex + 1) / _questions.length;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  CountDownController get timerController => _timerController;
  Map<String, double> get categoryProgress => _categoryProgress;
  List<QuizResult> get history => List.unmodifiable(_history);

  QuizViewModel({required this.repository});

  Future<void> initializeQuiz({
    required int amount,
    String? category,
    String? difficulty,
  }) async {
    _resetQuizState();
    _stopTimerInternal();
    _isLoading = true;
    _quizStartTime = DateTime.now();
    notifyListeners();

    try {
      _questions = await repository.getQuestions(
        amount: amount,
        category: category,
        difficulty: difficulty,
      );

      if (_questions.isEmpty) {
        _errorMessage = 'No questions available. Please try again.';
      } else {
        _errorMessage = null;
        _timeRemaining = AppConstants.questionTimeLimit;
        _startTimerForCurrentQuestion();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await repository.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
      notifyListeners();
    }
  }

  void selectAnswer(String answer) {
    if (_isAnswered || _timeRemaining <= 0) return;

    _selectedAnswer = answer;
    _answers[_currentQuestionIndex] = answer;
    _isAnswered = true;

    // Determine if correct or wrong
    final isCorrect = answer == currentQuestion?.correctAnswer;
    if (isCorrect) {
      _correctAnswers++;
    } else {
      _wrongAnswers++;
    }

    // Stop countdown while feedback is shown
    _stopTimerInternal();

    // Notify immediately for selection animation
    notifyListeners();

    // Wait before showing result (300-500ms)
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!_isAnswered) return;

      _showResult = true;
      notifyListeners();

      _playFeedback(isCorrect: isCorrect);

      // Then auto-move to next after ~1 second
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (_isAnswered) {
          nextQuestion();
        }
      });
    });
  }

  void nextQuestion() {
    _stopTimerInternal();
    _selectedAnswer = null;
    _isAnswered = false;
    _showResult = false;
    _timeRemaining = AppConstants.questionTimeLimit;

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _startTimerForCurrentQuestion();
      notifyListeners();
    } else {
      // Quiz complete - don't increment further
      notifyListeners();
    }
  }

  /// Called from the circular countdown widget on each tick.
  void updateTimer(int remaining) {
    final clamped = remaining.clamp(0, AppConstants.questionTimeLimit);
    if (clamped == _timeRemaining) return;

    _timeRemaining = clamped;
    _timeSpent = AppConstants.questionTimeLimit - _timeRemaining;

    // Throttle listener notifications slightly to avoid jank
    _timeUpdateDebounce?.cancel();
    _timeUpdateDebounce = Timer(const Duration(milliseconds: 80), () {
      notifyListeners();
    });

    if (_timeRemaining == 0 && !_isAnswered) {
      _handleTimeUp();
    }
  }

  QuizResult getQuizResult({
    required String category,
    required String difficulty,
  }) {
    final totalTime = DateTime.now().difference(_quizStartTime).inSeconds;

    final result = QuizResult(
      totalQuestions: _questions.length,
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      timeSpent: totalTime,
      category: category,
      difficulty: difficulty,
      completedAt: DateTime.now(),
      xpEarned: 0, // XP system removed
    );

    _history.insert(0, result);
    if (_history.length > 20) {
      _history.removeLast();
    }

    return result;
  }

  bool get canContinue => _isAnswered || _timeRemaining == 0;
  bool get isQuizComplete => _currentQuestionIndex >= _questions.length;

  void _resetQuizState() {
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _showResult = false;
    _answers.clear();
    _timeSpent = 0;
    _timeRemaining = AppConstants.questionTimeLimit;
  }

  void resetQuiz() {
    _resetQuizState();
    _questions = [];
    _errorMessage = null;
    _stopTimerInternal();
    notifyListeners();
  }

  void _handleTimeUp() {
    if (_isAnswered) return;

    _wrongAnswers++;
    _isAnswered = true;
    _showResult = true;
    _stopTimerInternal();
    _playFeedback(isCorrect: false);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_isAnswered) {
        nextQuestion();
      }
    });
  }

  void _startTimerForCurrentQuestion() {
    _timerController.restart(duration: AppConstants.questionTimeLimit);
  }

  void stopTimer() {
    _stopTimerInternal();
  }

  void _stopTimerInternal() {
    _timerController.pause();
    _timeUpdateDebounce?.cancel();
    _timeUpdateDebounce = null;
  }

  void _playFeedback({required bool isCorrect}) {
    // Simple click sound so we do not depend on bundled assets
    SystemSound.play(SystemSoundType.click);

    // Trigger vibration only after validation, never on screen load
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator != true) return;
      if (isCorrect) {
        Vibration.vibrate(duration: 40, amplitude: 80);
      } else {
        Vibration.vibrate(duration: 120, amplitude: 180);
      }
    });
  }

  void removeHistoryItem(int index) {
    if (index < 0 || index >= _history.length) return;
    _history.removeAt(index);
    notifyListeners();
  }
}
