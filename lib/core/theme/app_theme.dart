import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryAccent,
      brightness: Brightness.light,
      surface: AppColors.surface,
      primary: AppColors.primaryAccent,
      secondary: AppColors.secondaryAccent,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // ── AppBar ───────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      surfaceTintColor: Colors.transparent,
    ),

    // ── Typography ───────────────────────────────────────
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32, fontWeight: FontWeight.w800,
        color: AppColors.textPrimary, letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary, letterSpacing: -0.3,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10, fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
      ),
    ),

    // ── Buttons ──────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
        foregroundColor: AppColors.primaryAccent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryAccent,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    ),

    // ── Input Fields ─────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textMuted),
      labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      floatingLabelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryAccent),
    ),

    // ── Card ─────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // ── Others ───────────────────────────────────────────
    dividerColor: AppColors.divider,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryAccent;
        return AppColors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.accentLight;
        return AppColors.surfaceAlt;
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceAlt,
      selectedColor: AppColors.accentLight,
      brightness: Brightness.light,
      labelStyle: GoogleFonts.poppins(color: AppColors.textPrimary),
      side: const BorderSide(color: AppColors.border),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Keep for reference — use lightTheme
  static ThemeData get darkTheme => lightTheme;
}
