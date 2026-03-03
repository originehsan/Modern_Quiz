import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:modern_quiz_app/core/theme/app_colors.dart';

// ════════════════════════════════════════════════════════
// PRIMARY BUTTON
// ════════════════════════════════════════════════════════
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: widget.onPressed == null && !widget.isLoading ? 0.55 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 54.h,
            decoration: BoxDecoration(
              gradient: widget.onPressed != null || widget.isLoading
                  ? AppColors.primaryAccentGradient
                  : const LinearGradient(
                      colors: [Color(0xFFCBD5E1), Color(0xFFCBD5E1)],
                    ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: widget.onPressed != null
                  ? AppColors.accentShadow(blurRadius: 14)
                  : [],
            ),
            child: Center(
              child: widget.isLoading
                  ? SpinKitThreeBounce(color: Colors.white, size: 20.r)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20),
                          Gap(8.w),
                        ],
                        Text(
                          widget.label,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// GLASS CARD  (compat — now renders as light card)
// ════════════════════════════════════════════════════════
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow(),
      ),
      child: child,
    );
  }
}

// ════════════════════════════════════════════════════════
// CATEGORY CARD
// ════════════════════════════════════════════════════════
class CategoryCard extends StatefulWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;
  final Color? accentColor;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.accentColor,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final color = widget.accentColor ?? AppColors.primaryAccent;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow(),
          ),
          padding: EdgeInsets.all(14.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.icon, style: TextStyle(fontSize: 28.sp)),
              SizedBox(height: 8),
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// ANSWER CARD
// ════════════════════════════════════════════════════════
class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback? onTap;
  final int index;

  const AnswerCard({
    super.key,
    required this.answer,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
    this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;

    if (showResult) {
      if (isCorrect) {
        bgColor = AppColors.successLight;
        borderColor = AppColors.success;
        textColor = AppColors.success;
      } else if (isSelected) {
        bgColor = AppColors.errorLight;
        borderColor = AppColors.error;
        textColor = AppColors.error;
      }
    } else if (isSelected) {
      bgColor = AppColors.accentLight;
      borderColor = AppColors.primaryAccent;
      textColor = AppColors.secondaryAccent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected || (showResult && isCorrect) ? 1.5 : 1,
          ),
          boxShadow: AppColors.subtleShadow(),
        ),
        child: Row(
          children: [
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: showResult && isCorrect
                    ? AppColors.success.withValues(alpha: 0.15)
                    : showResult && isSelected
                    ? AppColors.error.withValues(alpha: 0.15)
                    : AppColors.surfaceAlt,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Text(
                answer,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (showResult && isCorrect)
              Icon(
                PhosphorIcons.checkCircle(),
                color: AppColors.success,
                size: 20,
              ),
            if (showResult && isSelected && !isCorrect)
              Icon(PhosphorIcons.xCircle(), color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// QUIZ PROGRESS BAR
// ════════════════════════════════════════════════════════
class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : current / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question $current of $total',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
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
          percent: percent.clamp(0.0, 1.0),
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
}

// ════════════════════════════════════════════════════════
// COUNTDOWN TIMER
// ════════════════════════════════════════════════════════
class CountdownTimer extends StatelessWidget {
  final int seconds;

  const CountdownTimer({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.success;
    if (seconds <= 5) {
      color = AppColors.error;
    } else if (seconds <= 15) {
      color = const Color(0xFFF59E0B);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.timer(), size: 14, color: color),
          Gap(4.w),
          Text(
            '${seconds}s',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// PERFORMANCE BADGE
// ════════════════════════════════════════════════════════
class PerformanceBadge extends StatelessWidget {
  final String badge;
  final int score;
  final int total;

  const PerformanceBadge({
    super.key,
    required this.badge,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = badge == 'Gold'
        ? '🥇'
        : badge == 'Silver'
        ? '🥈'
        : '🥉';
    final color = badge == 'Gold'
        ? const Color(0xFFF59E0B)
        : badge == 'Silver'
        ? AppColors.textSecondary
        : const Color(0xFFCD7F32);

    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 48.sp))
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(duration: 500.ms),
        Gap(8.h),
        Text(
          '$badge Performance!',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
        Text(
          '$score / $total correct',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
// EMPTY STATE
// ════════════════════════════════════════════════════════
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;
  final String? lottieUrl;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
    this.lottieUrl,
  });

  @override
  Widget build(BuildContext context) {
    final animation = lottieUrl != null
        ? Lottie.network(lottieUrl!, height: 120.h, repeat: true)
        : Text(emoji, style: TextStyle(fontSize: 56.sp));

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            animation
                .animate()
                .fade(duration: 300.ms)
                .slideY(begin: 0.05, end: 0, duration: 300.ms),
            Gap(16.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              Gap(24.h),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// SECTION HEADER
// ════════════════════════════════════════════════════════
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryAccent,
              ),
            ),
          ),
      ],
    );
  }
}
