import 'package:e_commerce_admin/core/styling/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // ============================================================
  // TEXT THEME
  // ============================================================

  static TextTheme _buildTextTheme(
    Color primaryColor,
    Color secondaryColor,
  ) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineLarge: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      bodyLarge: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),

      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),

      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme(
      AppColors.lightTextPrimary,
      AppColors.lightTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColors.lightBackground,

      fontFamily: GoogleFonts.poppins().fontFamily,

      textTheme: textTheme,

      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: Colors.white,

        secondary: AppColors.accent,
        onSecondary: Colors.black,

        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,

        error: AppColors.error,
        onError: Colors.white,
      ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,

        foregroundColor: AppColors.lightTextPrimary,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: false,

        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
      ),

      // ========================================================
      // INPUT
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.lightInputFill,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.lightPrimary,
            width: 1.2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.2,
          ),
        ),

        hintStyle: GoogleFonts.poppins(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),

        labelStyle: GoogleFonts.poppins(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),
      ),

      // ========================================================
      // ELEVATED BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,

          foregroundColor: Colors.white,

          minimumSize: const Size(
            double.infinity,
            50,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          elevation: 0,

          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,

          minimumSize: const Size(
            double.infinity,
            50,
          ),

          side: const BorderSide(
            color: AppColors.lightBorder,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // DIVIDER
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // CARD
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,

        elevation: 0,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),

          side: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
      ),

      // ========================================================
      // ICON
      // ========================================================

      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme(
      AppColors.darkTextPrimary,
      AppColors.darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.darkBackground,

      fontFamily: GoogleFonts.poppins().fontFamily,

      textTheme: textTheme,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: Colors.black,

        secondary: AppColors.accent,
        onSecondary: Colors.black,

        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,

        error: AppColors.error,
        onError: Colors.white,
      ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,

        foregroundColor: AppColors.darkTextPrimary,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: false,

        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),

      // ========================================================
      // INPUT
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.darkInputFill,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 1.2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.2,
          ),
        ),

        hintStyle: GoogleFonts.poppins(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ),

        labelStyle: GoogleFonts.poppins(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ),
      ),

      // ========================================================
      // ELEVATED BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,

          foregroundColor: Colors.black,

          minimumSize: const Size(
            double.infinity,
            50,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          elevation: 0,

          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,

          minimumSize: const Size(
            double.infinity,
            50,
          ),

          side: const BorderSide(
            color: AppColors.darkBorder,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // DIVIDER
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // CARD
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,

        elevation: 0,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),

          side: const BorderSide(
            color: AppColors.darkBorder,
          ),
        ),
      ),

      // ========================================================
      // ICON
      // ========================================================

      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
      ),
    );
  }
}