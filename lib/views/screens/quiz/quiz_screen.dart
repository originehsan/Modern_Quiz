import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/data/models/question_model.dart';
import 'package:modern_quiz_app/viewmodel/quiz/quiz_viewmodel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Track which question index we last animated
  int _lastAnimatedIndex = -1;
  bool _hasNavigated = false; // Guard against multiple navigations

  Color _difficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  void _onAnswerTap(QuizViewModel vm, String answer) {
    if (vm.isAnswered) return;
    vm.selectAnswer(answer);
  }

  @override
  void dispose() {
    // Ensure timer is stopped when leaving the screen
    final vm = context.read<QuizViewModel>();
    vm.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final category = args['category'] as String? ?? 'General Knowledge';
    final difficulty = args['difficulty'] as String? ?? 'medium';

    return Consumer<QuizViewModel>(
      builder: (context, vm, _) {
        // Check if quiz is complete and navigate to result screen (only once)
        if (vm.isQuizComplete && !vm.isLoading && !_hasNavigated) {
          _hasNavigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            vm.stopTimer();
            final navigator = Navigator.of(context);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (!mounted) return;
              final result = vm.getQuizResult(
                category: category,
                difficulty: difficulty,
              );
              navigator.pushReplacementNamed(
                AppConstants.resultRoute,
                arguments: result,
              );
            });
          });
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: SpinKitThreeBounce(
                color: AppColors.primaryAccent,
                size: 24,
              ),
            ),
          );
        }

        // ── Loading state ──────────────────────────────
        if (vm.isLoading) {
          return _buildLoadingScaffold();
        }

        // ── Error state ────────────────────────────────
        if (vm.errorMessage != null || vm.questions.isEmpty) {
          return _buildErrorScaffold(context, vm);
        }

        final question = vm.currentQuestion!;

        // Detect question change for re-animation
        final shouldAnimate = vm.currentQuestionIndex != _lastAnimatedIndex;
        if (shouldAnimate) {
          _lastAnimatedIndex = vm.currentQuestionIndex;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context, vm, category, difficulty),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(12.h),

                  // Timer directly below AppBar
                  _buildTimer(vm),

                  Gap(16.h),

                  // Progress bar
                  _buildProgressBar(vm),

                  Gap(20.h),

                  // Question card
                  _buildQuestionCard(question, vm, shouldAnimate),

                  Gap(20.h),

                  // Answer options
                  ...List.generate(question.allAnswers.length, (i) {
                    return _buildAnswerTile(
                      answer: question.allAnswers[i],
                      index: i,
                      vm: vm,
                      question: question,
                      shouldAnimate: shouldAnimate,
                    );
                  }),

                  Gap(24.h),

                  Gap(20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    QuizViewModel vm,
    String category,
    String difficulty,
  ) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(PhosphorIcons.arrowLeft(), color: AppColors.textPrimary),
        onPressed: () => _showQuitDialog(context),
      ),
      title: Column(
        children: [
          Text(
            category,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _difficultyColor(difficulty).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              difficulty.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: _difficultyColor(difficulty),
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
      actions: const [],
    );
  }

  Widget _buildTimer(QuizViewModel vm) {
    Color ringColor;
    if (vm.timeRemaining <= 5) {
      ringColor = AppColors.error;
    } else if (vm.timeRemaining <= 15) {
      ringColor = AppColors.warning;
    } else {
      ringColor = AppColors.primaryAccent;
    }

    return Center(
      child:
          CircularCountDownTimer(
                duration: AppConstants.questionTimeLimit,
                initialDuration: 0,
                controller: vm.timerController,
                width: 56.r,
                height: 56.r,
                ringColor: AppColors.surfaceAlt,
                fillColor: ringColor,
                backgroundColor: AppColors.surface,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                textStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: ringColor,
                ),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: true,
                autoStart: false, // started from the ViewModel
                onChange: (value) {
                  final remaining = int.tryParse(value) ?? vm.timeRemaining;
                  vm.updateTimer(remaining);
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 400.ms,
              ),
    );
  }

  Widget _buildProgressBar(QuizViewModel vm) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${vm.currentQuestionIndex + 1} of ${vm.totalQuestions}',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(vm.progressPercent * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryAccent,
              ),
            ),
          ],
        ),
        Gap(8.h),
        LinearPercentIndicator(
          percent: vm.progressPercent.clamp(0.0, 1.0),
          lineHeight: 6.h,
          backgroundColor: AppColors.surfaceAlt,
          progressColor: AppColors.primaryAccent,
          barRadius: const Radius.circular(10),
          padding: EdgeInsets.zero,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 400,
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question question, QuizViewModel vm, bool animate) {
    final card = Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question.category,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryAccent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(14.h),
          // Question Text
          Text(
            question.question,
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    if (!animate) return card;
    return card
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms);
  }

  Widget _buildAnswerTile({
    required String answer,
    required int index,
    required QuizViewModel vm,
    required Question question,
    required bool shouldAnimate,
  }) {
    final isSelected = vm.selectedAnswer == answer;
    final isCorrect = answer == question.correctAnswer;
    final showResult = vm.showResult; // Show result only after delay

    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Widget? trailing;

    if (showResult) {
      if (isCorrect) {
        bgColor = AppColors.successLight;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailing = Icon(
          PhosphorIcons.checkCircle(),
          color: AppColors.success,
          size: 20,
        );
      } else if (isSelected) {
        bgColor = AppColors.errorLight;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailing = Icon(
          PhosphorIcons.xCircle(),
          color: AppColors.error,
          size: 20,
        );
      }
    } else if (isSelected) {
      bgColor = AppColors.accentLight;
      borderColor = AppColors.primaryAccent;
      textColor = AppColors.secondaryAccent;
    }

    final tile = GestureDetector(
      onTap: vm.isAnswered
          ? null
          : () => _onAnswerTap(vm, answer), // Disable after selection
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected || (showResult && isCorrect) ? 1.5 : 1,
          ),
          boxShadow: AppColors.subtleShadow(),
        ),
        child: Row(
          children: [
            // Answer letter badge
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: showResult && isCorrect
                    ? AppColors.success.withValues(alpha: 0.15)
                    : showResult && isSelected
                    ? AppColors.error.withValues(alpha: 0.15)
                    : isSelected
                    ? AppColors.primaryAccent.withValues(alpha: 0.15)
                    : AppColors.surfaceAlt,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            Gap(14.w),
            Expanded(
              child: Text(
                answer,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: isSelected || (showResult && isCorrect)
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null) ...[Gap(8.w), trailing],
          ],
        ),
      ),
    );

    if (!shouldAnimate) return tile;
    return tile
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, duration: 350.ms);
  }

  // Unused - auto-advances now
  // Widget _buildNextButton(
  //   QuizViewModel vm,
  //   String category,
  //   String difficulty,
  // ) {
  //   final isLast = vm.isLastQuestion;
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton.icon(
  //       onPressed: () => _onNext(vm, category, difficulty),
  //       icon: Icon(
  //         isLast ? PhosphorIcons.flagCheckered() : PhosphorIcons.arrowRight(),
  //         size: 20,
  //       ),
  //       label: Text(
  //         isLast ? 'Finish Quiz' : 'Next Question',
  //         style: GoogleFonts.poppins(
  //           fontWeight: FontWeight.w700,
  //           fontSize: 15.sp,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primaryAccent,
  //         foregroundColor: Colors.white,
  //         padding: EdgeInsets.symmetric(vertical: 16.h),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         elevation: 0,
  //       ),
  //     ),
  //   ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  // }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Loading Quiz...',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitThreeBounce(
              color: AppColors.primaryAccent,
              size: 28.r,
            ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 400.ms),
            Gap(24.h),
            Text(
              'Fetching questions...',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Gap(8.h),
            Text(
              'Connecting to Open Trivia DB',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, QuizViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft(), color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.wifiSlash(),
                  color: AppColors.error,
                  size: 36,
                ),
              ),
              Gap(20.h),
              Text(
                'Oops!',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Gap(8.h),
              Text(
                vm.errorMessage ?? 'No questions loaded. Please try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              Gap(28.h),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(PhosphorIcons.arrowLeft(), size: 18),
                label: Text(
                  'Go Back',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Quit Quiz?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Your progress will be lost. Are you sure?',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Quit',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
