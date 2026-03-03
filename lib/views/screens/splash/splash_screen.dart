import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';
import 'package:modern_quiz_app/core/constants/app_constants.dart';
import 'package:modern_quiz_app/viewmodel/auth/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Check for existing login session and navigate
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        try {
          final authVM = context.read<AuthViewModel>();

          // Check if user was previously logged in
          await authVM.checkExistingLogin();

          if (mounted) {
            final nextRoute = authVM.isAuthenticated
                ? AppConstants.homeRoute
                : AppConstants.loginRoute;
            Navigator.of(context).pushReplacementNamed(nextRoute);
          }
        } catch (e) {
          debugPrint('Error during splash navigation: $e');
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // Subtle accent glow top-right
              Positioned(
                top: -60,
                right: -60,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) => Container(
                    width: 220.r,
                    height: 220.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryAccent.withValues(
                        alpha: 0.06 + (_pulseController.value * 0.04),
                      ),
                    ),
                  ),
                ),
              ),
              // Subtle accent glow bottom-left
              Positioned(
                bottom: -60,
                left: -60,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) => Container(
                    width: 180.r,
                    height: 180.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryAccent.withValues(
                        alpha: 0.05 + (_pulseController.value * 0.03),
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Logo icon — renders instantly, no network needed
                    Container(
                          width: 120.r,
                          height: 120.r,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryAccentGradient,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: AppColors.accentShadow(blurRadius: 26),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.quiz_rounded,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        ),

                    Gap(28.h),

                    // App name
                    Text(
                          AppConstants.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        )
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.3, end: 0, duration: 500.ms),

                    Gap(8.h),

                    // Tagline
                    Text(
                      'Learn. Play. Level Up.',
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ).animate(delay: 450.ms).fadeIn(duration: 500.ms),

                    const Spacer(),

                    // Loader
                    SpinKitThreeBounce(
                      color: AppColors.primaryAccent,
                      size: 24.r,
                    ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

                    Gap(40.h),

                    // Version
                    Text(
                      'v${AppConstants.appVersion}',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: AppColors.textMuted,
                      ),
                    ).animate(delay: 700.ms).fadeIn(duration: 400.ms),

                    Gap(24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
