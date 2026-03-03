// class AppConstants {
//
//   static const int connectTimeout = 10000;
//   static const int receiveTimeout = 10000;

//   // App
//   static const String appName = 'QuizMaster';
//   static const String appVersion = '1.0.0';

//   // Quiz
//   static const int questionTimeLimit = 30; // seconds
//   static const int totalQuestionsDefault = 10;

//   // Routes
//   static const String splashRoute = '/';
//   static const String authRoute = '/auth';
//   static const String loginRoute = '/login';
//   static const String signupRoute = '/signup';
//   static const String homeRoute = '/home';
//   static const String quizRoute = '/quiz';
//   static const String resultRoute = '/result';
//   static const String leaderboardRoute = '/leaderboard';
//   static const String settingsRoute = '/settings';
//   static const String profileRoute = '/profile';

//   // Storage Keys
//   static const String userKey = 'user';
//   static const String authTokenKey = 'auth_token';
//   static const String themeKey = 'theme_mode';
//   static const String soundEnabledKey = 'sound_enabled';

//   // Animation Durations
//   static const Duration shortDuration = Duration(milliseconds: 300);
//   static const Duration mediumDuration = Duration(milliseconds: 500);
//   static const Duration longDuration = Duration(milliseconds: 800);

//   // Dimensions
//   static const double defaultPadding = 20.0;
//   static const double defaultRadius = 20.0;
//   static const double cardRadius = 24.0;
//   static const double buttonRadius = 12.0;
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API (Normal simple way)
  static String get baseUrl {
    final baseUrlEnv = dotenv.env['QUIZ_BASE_URL'];
    if (baseUrlEnv == null || baseUrlEnv.isEmpty) {
      throw Exception('QUIZ_BASE_URL is not set in .env file');
    }
    return baseUrlEnv;
  }

  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;

  // App
  static const String appName = 'QuizMaster';
  static const String appVersion = '1.0.0';

  // Quiz
  static const int questionTimeLimit = 30; // seconds
  static const int totalQuestionsDefault = 10;

  // Routes
  static const String splashRoute = '/';
  static const String authRoute = '/auth';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String quizRoute = '/quiz';
  static const String resultRoute = '/result';
  static const String leaderboardRoute = '/leaderboard';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';

  // Storage Keys
  static const String userKey = 'user';
  static const String authTokenKey = 'auth_token';
  static const String themeKey = 'theme_mode';
  static const String soundEnabledKey = 'sound_enabled';

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // Dimensions
  static const double defaultPadding = 20.0;
  static const double defaultRadius = 20.0;
  static const double cardRadius = 24.0;
  static const double buttonRadius = 12.0;
}
