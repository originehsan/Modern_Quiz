import 'package:flutter/material.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/data/models/question_model.dart';
import 'package:modern_quiz_app/views/screens/splash/splash_screen.dart';
import 'package:modern_quiz_app/views/screens/auth/login_screen.dart';
import 'package:modern_quiz_app/views/screens/auth/signup_screen.dart';
import 'package:modern_quiz_app/views/screens/home/home_screen.dart';
import 'package:modern_quiz_app/views/screens/quiz/quiz_screen.dart';
import 'package:modern_quiz_app/views/screens/result/result_screen.dart';
import 'package:modern_quiz_app/views/screens/leaderboard/leaderboard_screen.dart';
import 'package:modern_quiz_app/views/screens/settings/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 600),
          child: const SplashScreen(),
          settings: settings,
        );

      case AppConstants.loginRoute:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
          child: const LoginScreen(),
          settings: settings,
        );

      case AppConstants.signupRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftJoined,
          duration: const Duration(milliseconds: 450),
          child: const SignupScreen(),
          settings: settings,
          childCurrent: const LoginScreen(),
        );

      case AppConstants.homeRoute:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 450),
          child: const HomeScreen(),
          settings: settings,
        );

      case AppConstants.quizRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 450),
          child: const QuizScreen(),
          settings: settings,
        );

      case AppConstants.resultRoute:
        final result = settings.arguments as QuizResult;
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
          child: ResultScreen(quizResult: result),
          settings: settings,
        );

      case AppConstants.leaderboardRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 450),
          child: const LeaderboardScreen(),
          settings: settings,
        );

      case AppConstants.settingsRoute:
        return PageTransition(
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 400),
          child: const SettingsScreen(),
          settings: settings,
        );

      default:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 250),
          child: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
