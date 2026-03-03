import 'package:dio/dio.dart';
import '../models/question_model.dart';
import '../../core/constants/app_constants.dart';

class QuizRemoteDataSource {
  final Dio dio;

  QuizRemoteDataSource({required this.dio});

  Future<List<Question>> getQuestions({
    required int amount,
    String? category,
    String? difficulty,
    String? type,
  }) async {
    try {
      // Build query params — always use url3986 + multiple type
      final params = <String, dynamic>{
        'amount': amount.toString(),
        'type': type ?? 'multiple',
        'encode': 'url3986',
      };

      if (category != null && category.isNotEmpty) {
        params['category'] = category;
      }
      if (difficulty != null && difficulty.isNotEmpty) {
        params['difficulty'] = difficulty;
      }

      final baseUrl = AppConstants.baseUrl;
      final response = await dio.get(baseUrl, queryParameters: params);

      if (response.statusCode == 200 && response.data != null) {
        // Handle OpenTDB response_code
        final responseCode = response.data['response_code'] as int? ?? -1;
        switch (responseCode) {
          case 0:
            // Success
            break;
          case 1:
            throw Exception(
              'Not enough questions available. Try fewer questions or different settings.',
            );
          case 2:
            throw Exception('Invalid API parameter. Please try again.');
          case 3:
            throw Exception('Session token not found. Please restart the app.');
          case 4:
            throw Exception('All questions exhausted. Please restart the app.');
          case 5:
            throw Exception(
              'Too many requests. Please wait a moment and try again.',
            );
          default:
            throw Exception(
              'Unexpected response from server (code: $responseCode)',
            );
        }

        final List<dynamic> results = response.data['results'] ?? [];

        if (results.isEmpty) {
          throw Exception(
            'No questions found. Try selecting a different category or difficulty.',
          );
        }

        return results
            .map((json) => Question.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Server error: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timed out. Check your internet connection.');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<List<QuizCategory>> getCategories() async {
    // Static category list matching OpenTDB category IDs
    return const [
      QuizCategory(
        id: 9,
        name: 'General Knowledge',
        icon: '🌍',
        description: 'Test your general knowledge',
      ),
      QuizCategory(
        id: 17,
        name: 'Science',
        icon: '🔬',
        description: 'Science & nature questions',
      ),
      QuizCategory(
        id: 18,
        name: 'Computers',
        icon: '💻',
        description: 'Technology & programming',
      ),
      QuizCategory(
        id: 19,
        name: 'Mathematics',
        icon: '📐',
        description: 'Numbers & equations',
      ),
      QuizCategory(
        id: 21,
        name: 'Sports',
        icon: '⚽',
        description: 'Sports trivia questions',
      ),
      QuizCategory(
        id: 22,
        name: 'Geography',
        icon: '🗺️',
        description: 'Explore the world',
      ),
      QuizCategory(
        id: 23,
        name: 'History',
        icon: '📚',
        description: 'Learn from history',
      ),
      QuizCategory(
        id: 11,
        name: 'Movies',
        icon: '🎬',
        description: 'Film & cinema trivia',
      ),
      QuizCategory(
        id: 15,
        name: 'Video Games',
        icon: '🎮',
        description: 'Gaming knowledge',
      ),
      QuizCategory(
        id: 27,
        name: 'Animals',
        icon: '🦁',
        description: 'Animal kingdom trivia',
      ),
    ];
  }
}
