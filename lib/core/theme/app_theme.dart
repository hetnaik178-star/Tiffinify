import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system: Masala Red + Turmeric + Curry-Leaf Green + warm ink
class AppColors {
  static const Color masala   = Color(0xFFC62F1F);
  static const Color masalaDk = Color(0xFF962114);
  static const Color turmeric = Color(0xFFF2A93B);
  static const Color leaf     = Color(0xFF1F8A57);
  static const Color ink      = Color(0xFF33221A);
  static const Color ink60    = Color(0x9933221A);
  static const Color cream    = Color(0xFFFFF7EA);
  static const Color card     = Color(0xFFFFFFFF);
  static const Color line     = Color(0xFFEFE3D0);
}

class AppTheme {
  static ThemeData get light {
    final display = GoogleFonts.baloo2;
    final body    = GoogleFonts.nunitoSans;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.masala,
        primary: AppColors.masala,
        secondary: AppColors.turmeric,
        surface: AppColors.card,
      ),
      textTheme: TextTheme(
        displayLarge:   display(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.ink),
        displayMedium:  display(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.ink),
        headlineMedium: display(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink),
        titleLarge:     display(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink),
        titleMedium:    display(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink),
        bodyLarge:      body(fontSize: 15, color: AppColors.ink),
        bodyMedium:     body(fontSize: 13.5, color: AppColors.ink60),
        labelLarge:     display(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.masala,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: display(fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.masala,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: AppColors.masala, width: 1.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: display(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: display(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.masala, width: 2)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: body(fontSize: 13.5, color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}