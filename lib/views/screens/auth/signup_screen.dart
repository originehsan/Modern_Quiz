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
import 'package:modern_quiz_app/viewmodel/auth/auth_viewmodel.dart';
import 'package:modern_quiz_app/views/widgets/custom_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late AnimationController _glowController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                PhosphorIcons.warningCircle(),
                color: Colors.white,
                size: 18,
              ),
              Gap(8.w),
              const Text('Passwords do not match!'),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    final authVM = context.read<AuthViewModel>();
    await authVM.signup(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
    if (!mounted) return;
    if (authVM.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(AppConstants.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // Glow orb
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) => Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260.r,
                  height: 260.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryAccent.withValues(
                          alpha: 0.1 + (_glowController.value * 0.08),
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20.h),

                    // Back button
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

                    Gap(28.h),

                    // Title
                    Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                    Gap(6.h),
                    Text(
                      'Join millions learning smarter',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                    Gap(28.h),

                    // Form card
                    _buildFormCard()
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, duration: 600.ms),

                    Gap(24.h),

                    // Sign in link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

                    Gap(20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Consumer<AuthViewModel>(
            builder: (context, authVM, _) {
              return Column(
                children: [
                  // Username
                  TextField(
                    controller: _usernameController,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'your_username',
                      prefixIcon: Icon(
                        PhosphorIcons.user(),
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
                  Gap(14.h),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(
                        PhosphorIcons.envelope(),
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
                  Gap(14.h),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    onChanged: (value) => authVM.checkPasswordStrength(value),
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '••••••••',
                      prefixIcon: Icon(
                        PhosphorIcons.lock(),
                        color: AppColors.primaryAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? PhosphorIcons.eye()
                              : PhosphorIcons.eyeSlash(),
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),

                  // Strength indicator
                  if (_passwordController.text.isNotEmpty) ...[
                    Gap(10.h),
                    _buildPasswordStrengthIndicator(authVM),
                  ],
                  Gap(14.h),

                  // Confirm password
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: '••••••••',
                      prefixIcon: Icon(
                        PhosphorIcons.lockKey(),
                        color: AppColors.primaryAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? PhosphorIcons.eye()
                              : PhosphorIcons.eyeSlash(),
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword,
                        ),
                      ),
                    ),
                  ),

                  Gap(20.h),

                  // Terms checkbox
                  GestureDetector(
                    onTap: () =>
                        setState(() => _agreedToTerms = !_agreedToTerms),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22.r,
                          height: 22.r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _agreedToTerms
                                  ? AppColors.primaryAccent
                                  : AppColors.border,
                              width: 1.5,
                            ),
                            gradient: _agreedToTerms
                                ? AppColors.primaryAccentGradient
                                : null,
                            color: _agreedToTerms ? null : Colors.transparent,
                          ),
                          child: _agreedToTerms
                              ? Icon(
                                  PhosphorIcons.check(),
                                  size: 12,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        Gap(12.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(24.h),

                  // Create account button
                  PrimaryButton(
                    label: 'Create Account',
                    isLoading: authVM.isLoading,
                    onPressed: _agreedToTerms ? () => _handleSignup() : null,
                    icon: PhosphorIcons.userPlus(),
                  ),

                  // Error
                  if (authVM.errorMessage != null) ...[
                    Gap(12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcons.warningCircle(),
                            color: AppColors.error,
                            size: 16,
                          ),
                          Gap(8.w),
                          Expanded(
                            child: Text(
                              authVM.errorMessage!,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(AuthViewModel authVM) {
    final strength = authVM.passwordStrength;
    final strengthColor = _getStrengthColor(strength);
    return Row(
      children: [
        Row(
          children: List.generate(
            4,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28.w,
              height: 4.h,
              margin: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: index < strength ? strengthColor : AppColors.border,
              ),
            ),
          ),
        ),
        Gap(10.w),
        Text(
          authVM.getPasswordStrengthText(),
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: strengthColor,
          ),
        ),
      ],
    );
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppColors.error;
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
      case 4:
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}
