import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/viewmodel/profile/profile_viewmodel.dart';
import 'package:modern_quiz_app/viewmodel/home/home_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                      'Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(20.h),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Quiz Experience', [
                        Consumer<HomeViewModel>(
                          builder: (context, homeVM, _) {
                            return Column(
                              children: [
                                _buildTile(
                                  icon: PhosphorIcons.slidersHorizontal(),
                                  title: 'Difficulty',
                                  subtitle: homeVM.difficultyText,
                                  isSlider: true,
                                  sliderValue: homeVM.selectedDifficulty.toDouble(),
                                  sliderMin: 0,
                                  sliderMax: 3,
                                  onSliderChanged: (v) =>
                                      homeVM.setDifficulty(v.round()),
                                  index: 0,
                                ),
                                Gap(12.h),
                                _buildTile(
                                  icon: PhosphorIcons.listNumbers(),
                                  title: 'Questions per Quiz',
                                  subtitle: '${homeVM.selectedQuestionCount} questions',
                                  isSlider: true,
                                  sliderValue: homeVM.selectedQuestionCount.toDouble(),
                                  sliderMin: 5,
                                  sliderMax: 20,
                                  sliderDivisions: 3,
                                  onSliderChanged: (v) =>
                                      homeVM.setQuestionCount(v.round()),
                                  index: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        Gap(12.h),
                        Consumer<ProfileViewModel>(
                          builder: (context, profileVM, _) {
                            return _buildTile(
                              icon: PhosphorIcons.speakerHigh(),
                              title: 'Sound Effects',
                              subtitle: 'Enable audio feedback',
                              isToggle: true,
                              value: profileVM.soundEnabled,
                              onChanged: profileVM.setSound,
                              index: 2,
                            );
                          },
                        ),
                      ]),
                      Gap(24.h),
                      _buildSection('About', [
                        _buildTile(
                          icon: PhosphorIcons.info(),
                          title: 'App Version',
                          subtitle: AppConstants.appVersion,
                          index: 0,
                        ),
                        Gap(10.h),
                        _buildTile(
                          icon: PhosphorIcons.book(),
                          title: 'Terms & Conditions',
                          subtitle: 'Read our terms',
                          index: 1,
                        ),
                        Gap(10.h),
                        _buildTile(
                          icon: PhosphorIcons.shieldCheck(),
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          index: 2,
                        ),
                      ]),
                      Gap(24.h),

                      // Logout button
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36.r,
                                      height: 36.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.error.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                      child: Icon(
                                        PhosphorIcons.signOut(),
                                        color: AppColors.error,
                                        size: 18,
                                      ),
                                    ),
                                    Gap(14.w),
                                    Text(
                                      'Logout',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate(delay: 50.ms).fadeIn(duration: 400.ms),

                      Gap(28.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 14.h),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryAccent,
              letterSpacing: 1.4,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isToggle = false,
    bool value = false,
    Function(bool)? onChanged,
    bool isSlider = false,
    double sliderValue = 0,
    double sliderMin = 0,
    double sliderMax = 1,
    int? sliderDivisions,
    ValueChanged<double>? onSliderChanged,
    IconData? trailingIcon,
    Color? trailingColor,
    required int index,
  }) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  // Icon bubble
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryAccent.withValues(alpha: 0.12),
                    ),
                    child: Icon(icon, color: AppColors.primaryAccent, size: 18),
                  ),
                  Gap(14.w),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trailing
                  if (isToggle)
                    Switch(
                      value: value,
                      onChanged: onChanged,
                      activeColor: AppColors.primaryAccent,
                    )
                  else if (isSlider)
                    SizedBox(
                      width: 140.w,
                      child: Slider(
                        value: sliderValue,
                        min: sliderMin,
                        max: sliderMax,
                        divisions: sliderDivisions,
                        activeColor: AppColors.primaryAccent,
                        inactiveColor: AppColors.surfaceAlt,
                        onChanged: onSliderChanged,
                      ),
                    )
                  else
                    Icon(
                      trailingIcon ?? PhosphorIcons.arrowRight(),
                      color: trailingColor ?? AppColors.textMuted,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
