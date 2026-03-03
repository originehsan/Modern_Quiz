import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/core/theme/app_theme.dart';
import 'package:modern_quiz_app/data/remote/quiz_service.dart'
    show QuizRemoteDataSource;
import 'package:modern_quiz_app/data/repositories/quiz_repository.dart';
import 'package:modern_quiz_app/data/repositories/auth_repository.dart';
import 'package:modern_quiz_app/viewmodel/quiz/quiz_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/auth/auth_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/home/home_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/profile/profile_viewmodel.dart';
import 'package:modern_quiz_app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    // Debug print to verify .env loaded
    debugPrint('✓ .env loaded successfully');
    final baseUrl = dotenv.env['QUIZ_BASE_URL'];
    debugPrint('✓ QUIZ_BASE_URL: $baseUrl');
  } catch (e) {
    debugPrint('✗ Error loading .env file: $e');
    debugPrint('✗ App may not function correctly without .env configuration');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Dio with default settings
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
      ),
    );

    // Initialize repositories & services
    final quizRemoteDataSource = QuizRemoteDataSource(dio: dio);
    final quizRepository = QuizRepository(
      remoteDataSource: quizRemoteDataSource,
    );
    final authRepository = AuthRepository();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AuthViewModel(repository: authRepository),
            ),
            ChangeNotifierProvider(
              create: (_) => QuizViewModel(repository: quizRepository),
            ),
            ChangeNotifierProvider(
              create: (_) => HomeViewModel(repository: quizRepository),
            ),
            ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ],
          child: MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: AppConstants.splashRoute,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: widget ?? const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }
}
