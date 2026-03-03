import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════
/// PREMIUM LIGHT QUIZ APP COLOR PALETTE
/// Clean, friendly, modern learning experience
/// ═══════════════════════════════════════════════════════
class AppColors {
  AppColors._();

  // ── Backgrounds ───────────────────────────────────────
  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0F4F9);

  // ── Text ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C2533);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textMuted = Color(0xFF98A2B3);

  // ── Primary Accent (Warm Orange) ───────────────────────
  static const Color primaryAccent = Color(0xFFFF9F43);
  static const Color secondaryAccent = Color(0xFFFFB86C);
  static const Color highlight = Color(0xFFFFE8CC);
  static const Color accentLight = Color(0xFFFFE8CC);
  static const Color accentGlow = Color(0x33FF9F43);

  // Legacy alias
  static const Color softHighlight = highlight;

  // ── Status Colors ─────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF4F8EF7);
  static const Color infoLight = Color(0xFFEFF6FF);

  // ── New accent colors ──────────────────────────────────
  static const Color softPurple = Color(0xFFEDE9FE);
  static const Color softGreen = Color(0xFFDCFCE7);

  // ── Borders & Dividers ────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Compat alias for glass style
  static const Color glassBase = Color(0x0AFFFFFF);

  // ── Gradients ─────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5F7FB), Color(0xFFF0F4F9)],
  );

  static const LinearGradient primaryAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F43), Color(0xFFFFB86C)],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF15803D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F43), Color(0xFFFFB86C)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F7FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadows ───────────────────────────────────────────
  static List<BoxShadow> cardShadow({
    double blurRadius = 16,
    double spreadRadius = 0,
  }) => [
    BoxShadow(
      color: const Color(0x0F000000),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> accentShadow({
    double blurRadius = 16,
    double spreadRadius = 0,
  }) => [
    BoxShadow(
      color: const Color(0x40FF9F43),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> subtleShadow() => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Compat aliases
  static List<BoxShadow> premiumShadow({
    double blurRadius = 16,
    double spreadRadius = 0,
  }) => accentShadow(blurRadius: blurRadius, spreadRadius: spreadRadius);

  static List<BoxShadow> glassShadow() => cardShadow();
}
