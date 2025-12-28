import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color scheme
class AppColors {
  // Primary colors
  static const Color primaryDark = Color(0xFF1E3A5F);
  static const Color primary = Color(0xFF2E5A8E);
  static const Color primaryLight = Color(0xFF4A7CB5);

  // Secondary colors
  static const Color secondary = Color(0xFF00B4D8);
  static const Color secondaryLight = Color(0xFF48CAE4);

  // Accent colors
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  // Neutral colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color surfaceDark = Color(0xFF1B2838);
  static const Color textPrimaryDark = Color(0xFFF5F7FA);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Category colors
  static const Color verbalColor = Color(0xFF6366F1);
  static const Color numericalColor = Color(0xFF10B981);
  static const Color logicalColor = Color(0xFFF59E0B);
  static const Color spatialColor = Color(0xFFEC4899);
  static const Color patternColor = Color(0xFF8B5CF6);
}

/// App text styles
class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );
}

/// Light theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.textPrimary,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color: AppColors.surface,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(color: AppColors.primary),
      foregroundColor: AppColors.primary,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: Colors.grey.shade200,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade200,
    thickness: 1,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
  ),
);

/// Dark theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    surface: AppColors.surfaceDark,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.textPrimaryDark,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.textPrimaryDark,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color: AppColors.surfaceDark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(color: AppColors.primaryLight),
      foregroundColor: AppColors.primaryLight,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: AppTextStyles.labelLarge,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.primaryLight,
    linearTrackColor: Colors.grey.shade800,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade800,
    thickness: 1,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryDark),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryDark),
    headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryDark),
  ),
);
