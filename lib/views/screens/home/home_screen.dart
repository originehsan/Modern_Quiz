import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/viewmodel/home/home_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/quiz/quiz_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/auth/auth_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/profile/profile_viewmodel.dart';
import 'package:modern_quiz_app/data/models/question_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadCategories();
    });
  }

  void _startQuiz(BuildContext context, QuizCategory category) async {
    final homeVM = context.read<HomeViewModel>();
    final quizVM = context.read<QuizViewModel>();

    final difficulty = homeVM.getDifficultyName(homeVM.selectedDifficulty);

    await quizVM.initializeQuiz(
      amount: homeVM.selectedQuestionCount,
      category: category.id.toString(),
      difficulty: difficulty,
    );

    if (!context.mounted) return;

    if (quizVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(quizVM.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppConstants.quizRoute,
      arguments: {
        'category': category.name,
        'difficulty': difficulty.isEmpty ? 'any' : difficulty,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(24.h),
                  _buildStatsRow(),
                  Gap(28.h),
                  _buildDifficultySelector(),
                  Gap(20.h),
                  _buildQuestionCountSelector(),
                  Gap(28.h),
                  _buildHistorySection(),
                  Gap(20.h),
                  _buildCategoriesSection(),
                  Gap(24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130.h,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () => _openProfileSheet(context),
          icon: Icon(PhosphorIcons.gear(), color: AppColors.textPrimary),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF7ED), Color(0xFFFFFFFF)],
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<AuthViewModel>(
                builder: (context, authVM, _) => Text(
                  authVM.currentUser?.username != null
                      ? 'Welcome, ${authVM.currentUser!.username}! 👋'
                      : 'Hi there! 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                'What will you\nlearn today?',
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProfileSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, animation, secondAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: SizedBox(
              width: MediaQuery.of(ctx).size.width * 0.85,
              height: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: _buildDrawerContent(),
              ),
            ),
          ),
        );
      },
      barrierColor: Colors.black.withValues(alpha: 0.3),
    );
  }

  Widget _buildDrawerContent() {
    return SafeArea(
      top: true,
      bottom: false,
      child:
          GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: AppColors.cardShadow(),
                  ),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 12.h,
                    bottom: 20.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentLight,
                              ),
                              child: Icon(
                                PhosphorIcons.user(),
                                color: AppColors.primaryAccent,
                                size: 18,
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quick Settings',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Consumer<AuthViewModel>(
                                    builder: (context, authVM, _) => Text(
                                      authVM.currentUser?.username ?? 'User',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(16.h),
                        Consumer<HomeViewModel>(
                          builder: (context, homeVM, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Difficulty',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Gap(6.h),
                                Slider(
                                  value: homeVM.selectedDifficulty.toDouble(),
                                  min: 0,
                                  max: 3,
                                  divisions: 3,
                                  label: homeVM.difficultyText,
                                  activeColor: AppColors.primaryAccent,
                                  inactiveColor: AppColors.surfaceAlt,
                                  onChanged: (v) =>
                                      homeVM.setDifficulty(v.round()),
                                ),
                                Gap(12.h),
                                Text(
                                  'Questions per quiz',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Gap(6.h),
                                Slider(
                                  value: homeVM.selectedQuestionCount
                                      .toDouble(),
                                  min: 5,
                                  max: 20,
                                  divisions: 3,
                                  label: '${homeVM.selectedQuestionCount}',
                                  activeColor: AppColors.primaryAccent,
                                  inactiveColor: AppColors.surfaceAlt,
                                  onChanged: (v) =>
                                      homeVM.setQuestionCount(v.round()),
                                ),
                              ],
                            );
                          },
                        ),
                        Gap(16.h),
                        Consumer<ProfileViewModel>(
                          builder: (context, profileVM, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sound effects',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Switch(
                                  value: profileVM.soundEnabled,
                                  activeColor: AppColors.primaryAccent,
                                  onChanged: profileVM.setSound,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fade(duration: 250.ms)
              .slideX(begin: 0.1, end: 0, duration: 250.ms),
    );
  }

  Widget _buildStatsRow() {
    return Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryAccentGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.accentShadow(blurRadius: 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('🎯', 'Focus', 'Practice'),
              _buildStatDivider(),
              _buildStat('📚', 'Smart', 'Learning'),
              _buildStatDivider(),
              _buildStat('⏱️', 'Short', 'Sessions'),
            ],
          ),
        )
        .animate(delay: 100.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 20.sp)),
        Gap(4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildDifficultySelector() {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        final options = ['Any', 'Easy', 'Medium', 'Hard'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Difficulty'),
            Gap(12.h),
            Row(
              children: List.generate(options.length, (i) {
                final isSelected = vm.selectedDifficulty == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => vm.setDifficulty(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: i < 3 ? 8.w : 0),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryAccent
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? AppColors.accentShadow(blurRadius: 10)
                            : AppColors.subtleShadow(),
                      ),
                      child: Text(
                        options[i],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionCountSelector() {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        final counts = [5, 10, 15, 20];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Questions per Quiz'),
            Gap(12.h),
            Row(
              children: counts.map((c) {
                final isSelected = vm.selectedQuestionCount == c;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => vm.setQuestionCount(c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: c != 20 ? 8.w : 0),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accentLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: AppColors.subtleShadow(),
                      ),
                      child: Text(
                        '$c',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? AppColors.primaryAccent
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesSection() {
    return Consumer2<HomeViewModel, QuizViewModel>(
      builder: (context, homeVM, quizVM, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Choose a Category'),
            Gap(14.h),
            // Center progress indicator if category was completed
            if (!homeVM.isLoading &&
                homeVM.categories.isNotEmpty &&
                quizVM.lastCompletedCategory != null)
              _buildCenterProgressIndicator(context, homeVM, quizVM),
            Gap(14.h),
            if (homeVM.isLoading)
              _buildShimmer()
            else if (homeVM.errorMessage != null)
              _buildCategoryError(homeVM)
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.55,
                ),
                itemCount: homeVM.categories.length,
                itemBuilder: (context, i) {
                  return _buildCategoryCard(context, homeVM.categories[i], i);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildCenterProgressIndicator(
    BuildContext context,
    HomeViewModel homeVM,
    QuizViewModel quizVM,
  ) {
    final categoryName = quizVM.lastCompletedCategory ?? '';
    final progress = homeVM.categoryProgress[categoryName] ?? 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7ED), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Last Quiz: $categoryName',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Gap(8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: AppColors.surfaceAlt,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryAccent,
              ),
            ),
          ),
          Gap(6.h),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColors.primaryAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.08, end: 0);
  }

  Widget _buildCategoryCard(BuildContext context, QuizCategory cat, int index) {
    // Pick color from a set based on index
    final colors = [
      const Color(0xFFFF9F43),
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
      const Color(0xFF6366F1),
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
          onTap: () {
            final quizVM = context.read<QuizViewModel>();
            quizVM.lastCompletedCategory =
                cat.name; // Track for progress center display
            _startQuiz(context, cat);
          },
          child: Consumer<QuizViewModel>(
            builder: (context, quizVM, _) {
              final isLoading = quizVM.isLoading;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  ..scale(quizVM.isLoading ? 0.95 : 1.0),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Glass accent corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 50.r,
                        height: 50.r,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: color.withValues(alpha: 0.1),
                            ),
                            left: BorderSide(
                              color: color.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Content - centered
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat.icon, style: TextStyle(fontSize: 32.sp)),
                          Gap(8.h),
                          Text(
                            cat.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Loading overlay
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: SpinKitThreeBounce(color: color, size: 18.r),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        )
        .animate(delay: (index * 40).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.55,
      ),
      itemCount: 8,
      itemBuilder: (context, i) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceAlt,
          highlightColor: AppColors.surface,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryError(HomeViewModel vm) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(PhosphorIcons.wifiSlash(), color: AppColors.error, size: 32),
          Gap(8.h),
          Text(
            vm.errorMessage ?? 'Failed to load categories',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColors.error),
          ),
          Gap(12.h),
          TextButton(
            onPressed: () => vm.loadCategories(),
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildHistorySection() {
    return Consumer2<HomeViewModel, QuizViewModel>(
      builder: (context, homeVM, quizVM, _) {
        if (quizVM.history.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Recent quizzes'),
            Gap(10.h),
            ...quizVM.history.asMap().entries.take(3).map((entry) {
              final index = entry.key;
              final result = entry.value;

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Slidable(
                  key: ValueKey(result.completedAt.toIso8601String()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.45,
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          final cat = homeVM.categories
                              .where((c) => c.name == result.category)
                              .cast<QuizCategory?>()
                              .firstOrNull;
                          if (cat != null) {
                            _startQuiz(context, cat);
                          }
                        },
                        backgroundColor: AppColors.primaryAccent.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: AppColors.primaryAccent,
                        icon: PhosphorIcons.arrowCounterClockwise(),
                        label: 'Retry',
                      ),
                      SlidableAction(
                        onPressed: (_) => context
                            .read<QuizViewModel>()
                            .removeHistoryItem(index),
                        backgroundColor: AppColors.error.withValues(
                          alpha: 0.08,
                        ),
                        foregroundColor: AppColors.error,
                        icon: PhosphorIcons.trash(),
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.subtleShadow(),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentLight,
                          ),
                          child: Icon(
                            PhosphorIcons.clockCounterClockwise(),
                            size: 18,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${result.correctAnswers}/${result.totalQuestions} • ${result.difficulty.toUpperCase()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(8.w),
                        Icon(
                          PhosphorIcons.caretRight(),
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
