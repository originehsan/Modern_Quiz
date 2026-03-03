import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/data/models/question_model.dart';
import 'package:modern_quiz_app/viewmodel/home/home_viewmodel.dart';
import 'package:modern_quiz_app/views/widgets/custom_widgets.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult quizResult;
  const ResultScreen({required this.quizResult, super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;

  bool get _isGoodScore => widget.quizResult.percentage >= 60;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );

    // Start short confetti burst for good scores
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isGoodScore) _confettiController.play();
    });

    // Store category progress on home view model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = widget.quizResult;
      final homeVM = Provider.of<HomeViewModel>(context, listen: false);
      homeVM.updateCategoryProgress(result.category, result.percentage / 100);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.quizResult;

    // Confetti colors based on score
    final confettiColors = _isGoodScore
        ? // Happy colors for good scores (>= 60%)
          const [
            AppColors.primary,
            AppColors.success,
            AppColors.infoBlue,
            AppColors.primaryLight,
          ]
        : // Sad colors for lower scores (< 60%)
          [
            Colors.blueGrey,
            Colors.grey,
            AppColors.infoBlue.withOpacity(0.5),
            Color(0xFF9CA3AF),
          ];

    return Scaffold(
      backgroundColor: AppColors.bgStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgStart, AppColors.bgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Confetti with conditional colors
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: confettiColors,
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Gap(20.h),

                    // App bar area
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(
                            context,
                          ).pushReplacementNamed(AppConstants.homeRoute),
                          child: Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.softShadow(),
                            ),
                            child: Icon(
                              PhosphorIcons.house(),
                              color: AppColors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Quiz Complete!',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: 40.r),
                      ],
                    ),

                    Gap(32.h),

                    // Success animation
                    Builder(
                          builder: (context) => Lottie.network(
                            'https://assets9.lottiefiles.com/packages/lf20_touohxv0.json',
                            height: 140.h,
                            repeat: false,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        ),

                    Gap(12.h),

                    // Score circle
                    _buildScoreCircle(result),

                    Gap(28.h),

                    // Performance badge
                    PerformanceBadge(
                      badge: result.badge,
                      score: result.correctAnswers,
                      total: result.totalQuestions,
                    ),

                    Gap(28.h),

                    // Stats card
                    _buildStatsCard(result)
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.1, end: 0),

                    Gap(28.h),

                    // Buttons
                    _buildButtons(context, result),

                    Gap(32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle(QuizResult result) {
    final pct = result.percentage / 100;
    Color progressColor = AppColors.error;
    if (result.percentage >= 80) {
      progressColor = AppColors.success;
    } else if (result.percentage >= 60) {
      progressColor = Color(0xFFF59E0B);
    }

    return CircularPercentIndicator(
          radius: 80.r,
          lineWidth: 10,
          percent: pct.clamp(0.0, 1.0),
          animation: true,
          animationDuration: 1200,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: AppColors.bgStart.withOpacity(0.5),
          progressColor: progressColor,
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${result.percentage.toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Score',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildStatsCard(QuizResult result) {
    final accuracy = result.totalQuestions == 0
        ? 0.0
        : (result.correctAnswers / result.totalQuestions) * 100;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgStart.withOpacity(0.8),
            AppColors.bgEnd.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: AppColors.softShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Statistics',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          _statRow(
            PhosphorIcons.checkCircle(),
            'Correct',
            '${result.correctAnswers} / ${result.totalQuestions}',
            AppColors.success,
          ),
          _divider(),
          _statRow(
            PhosphorIcons.xCircle(),
            'Wrong',
            '${result.wrongAnswers}',
            AppColors.error,
          ),
          _divider(),
          _statRow(
            PhosphorIcons.smileyWink(),
            'Accuracy',
            '${accuracy.toStringAsFixed(1)}%',
            AppColors.infoBlue,
          ),
          _divider(),
          _statRow(
            PhosphorIcons.timer(),
            'Time Spent',
            '${result.timeSpent}s',
            Color(0xFFF59E0B),
          ),
          _divider(),
          _statRow(
            PhosphorIcons.tag(),
            'Category',
            result.category,
            AppColors.primary,
          ),
          _divider(),
          _statRow(
            PhosphorIcons.chartBar(),
            'Difficulty',
            result.difficulty.toUpperCase(),
            AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          Gap(12.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(color: AppColors.divider, height: 1, thickness: 1);

  Widget _buildButtons(BuildContext context, QuizResult result) {
    return Column(
      children: [
        // Finish Quiz - Gradient Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppConstants.homeRoute),
            icon: Icon(PhosphorIcons.checkCircle(), size: 20),
            label: Text(
              'Finish Quiz',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}
