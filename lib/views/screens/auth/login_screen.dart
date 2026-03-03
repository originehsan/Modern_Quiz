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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword        = false;
  final _formKey            = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final authVM = context.read<AuthViewModel>();
    await authVM.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(40.h),

              // Hero header
              _buildHeader(),

              Gap(36.h),

              // Form
              _buildForm(),

              Gap(20.h),

              // Sign up link
              _buildSignupLink(),

              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo badge
        Container(
          width: 56.r,
          height: 56.r,
          decoration: BoxDecoration(
            gradient: AppColors.primaryAccentGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.accentShadow(blurRadius: 16),
          ),
          child: Center(
            child: Text('🧠', style: TextStyle(fontSize: 28.sp)),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 500.ms, curve: Curves.easeOutBack),

        Gap(20.h),

        Text(
          'Welcome Back!',
          style: GoogleFonts.poppins(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0),

        Gap(6.h),

        Text(
          'Sign in to continue your learning journey',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'you@example.com',
              prefixIcon: Icon(PhosphorIcons.envelope(), color: AppColors.primaryAccent),
            ),
          )
              .animate(delay: 250.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),

          Gap(14.h),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Password too short';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '••••••••',
              prefixIcon: Icon(PhosphorIcons.lock(), color: AppColors.primaryAccent),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? PhosphorIcons.eye() : PhosphorIcons.eyeSlash(),
                  color: AppColors.textMuted,
                  size: 20,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
          )
              .animate(delay: 320.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),

          Gap(8.h),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
          ),

          Gap(8.h),

          // Login button
          Consumer<AuthViewModel>(
            builder: (context, authVM, _) {
              return Column(
                children: [
                  PrimaryButton(
                    label: 'Sign In',
                    isLoading: authVM.isLoading,
                    onPressed: () => _handleLogin(),
                    icon: PhosphorIcons.signIn(),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 400.ms),

                  // Error message
                  if (authVM.errorMessage != null) ...[
                    Gap(12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(PhosphorIcons.warningCircle(),
                              color: AppColors.error, size: 16),
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
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .shakeX(amount: 4),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignupLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(AppConstants.signupRoute),
            child: Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: 500.ms)
        .fadeIn(duration: 400.ms);
  }
}
