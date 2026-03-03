import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════
/// MODERN CLEAN QUIZ APP COLOR PALETTE
/// Professional, warm orange gradient aesthetic
/// ═══════════════════════════════════════════════════════
class AppColors {
  AppColors._();

  // ── GRADIENT BACKGROUNDS ──────────────────────────────
  static const Color bgStart = Color(0xFFFFF7ED);
  static const Color bgEnd = Color(0xFFFFFFFF);

  // Legacy aliases for compatibility
  static const Color background = bgStart;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFFF7ED);

  // ── PRIMARY ORANGE PALETTE ────────────────────────────
  static const Color primary = Color(0xFFF97316);
  static const Color primaryDark = Color(0xFFC2410C);
  static const Color primaryLight = Color(0xFFFDBA74);

  // Aliases for compatibility
  static const Color primaryAccent = primary;
  static const Color secondaryAccent = primaryLight;

  // ── STATUS & SEMANTIC COLORS ──────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static const Color successLight = Color(0xFFDCFCE7);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color infoLight = Color(0xFFEFF6FF);

  // ── TEXT COLORS ───────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Legacy alias
  static const Color card = Color(0xFFFFFFFF);

  // ── ACCENT & HIGHLIGHTS ───────────────────────────────
  static const Color highlight = Color(0xFFFEDBA7);
  static const Color accentLight = Color(0xFFFEDBA7);
  static const Color accentGlow = Color(0x33F97316);
  static const Color softHighlight = highlight;

  // ── GRADIENTS ─────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgStart, bgEnd],
  );

  static const LinearGradient primaryAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), bgStart],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── BORDERS & DIVIDERS ───────────────────────────────
  static const Color border = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFFAFAFA);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBase = Color(0x0AFFFFFF);

  // ── SHADOWS & EFFECTS ─────────────────────────────────
  static List<BoxShadow> cardShadow({
    double blurRadius = 10,
    double spreadRadius = 0,
  }) => [
    BoxShadow(
      color: const Color(0x0F000000),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> softShadow() => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> accentShadow({
    double blurRadius = 16,
    double spreadRadius = 0,
  }) => [
    BoxShadow(
      color: const Color(0x40F97316),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: const Offset(0, 6),
    ),
  ];

  // Compat aliases
  static List<BoxShadow> premiumShadow({
    double blurRadius = 16,
    double spreadRadius = 0,
  }) => accentShadow(blurRadius: blurRadius, spreadRadius: spreadRadius);

  static List<BoxShadow> subtleShadow() => softShadow();

  static List<BoxShadow> glassShadow() => cardShadow();
}
