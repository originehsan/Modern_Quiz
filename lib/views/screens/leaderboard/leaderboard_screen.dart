import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/views/widgets/custom_widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: AppColors.glassBase,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.glassBorder,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              PhosphorIcons.arrowLeft(),
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(16.w),
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      PhosphorIcons.trophy(),
                      color: AppColors.primaryAccent,
                      size: 24,
                    ),
                  ],
                ),
              ),

              Gap(20.h),

              // Content – placeholder, no fake XP system
              Expanded(
                child: Center(
                  child: EmptyState(
                    emoji: '📊',
                    title: 'Leaderboard coming soon',
                    subtitle:
                        'We’re focusing on helping you learn first.\nA simple, honest leaderboard will arrive in a later update.',
                    lottieUrl:
                        'https://assets9.lottiefiles.com/packages/lf20_5ngs2ksb.json',
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
