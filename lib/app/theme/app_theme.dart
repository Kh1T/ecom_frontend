import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F5F9);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const primary = Color(0xFF111827);
  static const success = Color(0xFF15803D);
  static const danger = Color(0xFFB91C1C);
}

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppRadii {
  static const small = 10.0;
  static const medium = 14.0;
  static const large = 20.0;
}

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.textSecondary,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
      outline: AppColors.border,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
      headlineSmall: const TextStyle(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
        color: AppColors.textPrimary,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
      labelLarge: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.35,
          color: AppColors.textPrimary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: 12,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.large),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 15,
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        border: inputBorder(AppColors.border),
        enabledBorder: inputBorder(AppColors.border),
        focusedBorder: inputBorder(AppColors.primary, 1.5),
        errorBorder: inputBorder(AppColors.danger),
        focusedErrorBorder: inputBorder(AppColors.danger, 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textSecondary,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        elevation: 0,
        pressElevation: 0,
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary,
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
        unselectedLabelTextStyle: TextStyle(color: AppColors.textSecondary),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
      ),
    );
  }
}
