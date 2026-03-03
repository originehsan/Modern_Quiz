import '../models/question_model.dart';
import '../remote/quiz_service.dart';

class QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepository({required this.remoteDataSource});

  Future<List<Question>> getQuestions({
    required int amount,
    String? category,
    String? difficulty,
    String? type,
  }) async {
    try {
      return await remoteDataSource.getQuestions(
        amount: amount,
        category: category,
        difficulty: difficulty,
        type: type,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuizCategory>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuizResult(QuizResult result) async {
    // TODO: Implement saving quiz results to local storage or backend
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }
}
