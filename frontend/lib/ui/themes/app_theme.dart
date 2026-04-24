// lib/ui/themes/app_theme.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Builds the Material theme configuration for SevakAI.
abstract final class AppTheme {
  /// Prevents instantiation.
  const AppTheme._();

  /// Returns the light theme used by the application.
  static ThemeData get lightTheme {
    final ColorScheme baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.light,
    );

    final ColorScheme colorScheme = baseScheme.copyWith(
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryBlueLight,
      onPrimaryContainer: AppColors.primaryBlueDark,
      secondary: AppColors.primaryBlueDark,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.primaryBlueLight,
      onSecondaryContainer: AppColors.primaryBlueDark,
      tertiary: AppColors.successGreen,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.successGreenLight,
      onTertiaryContainer: AppColors.successGreen,
      error: AppColors.dangerRed,
      onError: AppColors.white,
      errorContainer: AppColors.dangerRedLight,
      onErrorContainer: AppColors.dangerRed,
      surface: AppColors.white,
      onSurface: AppColors.neutral800,
      surfaceContainerHighest: AppColors.neutral100,
      onSurfaceVariant: AppColors.neutral600,
      outline: AppColors.neutral200,
      outlineVariant: AppColors.neutral200,
      shadow: const Color(0x1A000000),
      scrim: const Color(0x52000000),
      inverseSurface: AppColors.neutral900,
      onInverseSurface: AppColors.neutral50,
      inversePrimary: AppColors.primaryBlueLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.neutral50,
      canvasColor: AppColors.neutral50,
      cardColor: AppColors.white,
      dividerColor: AppColors.neutral200,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.neutral900),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.neutral900),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.neutral900),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.neutral900),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral900),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral800),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral800),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral800),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral600),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.neutral800),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.neutral800),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.neutral600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.neutral200),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _solidButtonStyle(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.neutral200,
          disabledForegroundColor: AppColors.neutral400,
          overlayColor: AppColors.primaryBlueDark.withValues(alpha: 0.08),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlineButtonStyle(
          foregroundColor: AppColors.primaryBlue,
          borderColor: AppColors.neutral200,
          overlayColor: AppColors.primaryBlueLight.withValues(alpha: 0.4),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _textButtonStyle(
          foregroundColor: AppColors.primaryBlue,
          overlayColor: AppColors.primaryBlueLight.withValues(alpha: 0.5),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColors.neutral100,
        borderColor: AppColors.neutral200,
        focusedColor: AppColors.primaryBlue,
        errorColor: AppColors.dangerRed,
        labelColor: AppColors.neutral600,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral100,
        disabledColor: AppColors.neutral100,
        selectedColor: AppColors.primaryBlueLight,
        secondarySelectedColor: AppColors.primaryBlueLight,
        deleteIconColor: AppColors.neutral600,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          side: const BorderSide(color: AppColors.neutral200),
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.neutral800),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlueDark),
        brightness: Brightness.light,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral200,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.neutral600,
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.white,
        selectedIconTheme: const IconThemeData(color: AppColors.primaryBlue),
        unselectedIconTheme: const IconThemeData(color: AppColors.neutral600),
        selectedLabelTextStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlue),
        unselectedLabelTextStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.neutral600),
        indicatorColor: AppColors.primaryBlueLight,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral900,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        actionTextColor: AppColors.primaryBlueLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  /// Returns the dark theme used by the application.
  static ThemeData get darkTheme {
    final ColorScheme baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.dark,
    );

    final ColorScheme colorScheme = baseScheme.copyWith(
      primary: AppColorsDark.primaryBlue,
      onPrimary: AppColorsDark.white,
      primaryContainer: AppColorsDark.card,
      onPrimaryContainer: AppColorsDark.primaryBlueLight,
      secondary: AppColorsDark.primaryBlueLight,
      onSecondary: AppColorsDark.surface,
      secondaryContainer: AppColorsDark.card,
      onSecondaryContainer: AppColorsDark.textPrimary,
      tertiary: AppColorsDark.successGreen,
      onTertiary: AppColorsDark.surface,
      tertiaryContainer: AppColorsDark.card,
      onTertiaryContainer: AppColorsDark.successGreenLight,
      error: AppColorsDark.dangerRed,
      onError: AppColorsDark.white,
      errorContainer: AppColorsDark.card,
      onErrorContainer: AppColorsDark.dangerRedLight,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      surfaceContainerHighest: AppColorsDark.card,
      onSurfaceVariant: AppColorsDark.textSecondary,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.border,
      shadow: const Color(0x52000000),
      scrim: const Color(0x80000000),
      inverseSurface: AppColorsDark.white,
      onInverseSurface: AppColorsDark.surface,
      inversePrimary: AppColorsDark.primaryBlueDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColorsDark.surface,
      canvasColor: AppColorsDark.surface,
      cardColor: AppColorsDark.card,
      dividerColor: AppColorsDark.border,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColorsDark.textPrimary),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColorsDark.textPrimary),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColorsDark.textPrimary),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColorsDark.textPrimary),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColorsDark.textPrimary),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColorsDark.textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColorsDark.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColorsDark.textSecondary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColorsDark.disabled),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColorsDark.textPrimary),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColorsDark.textPrimary),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColorsDark.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsDark.surface,
        foregroundColor: AppColorsDark.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColorsDark.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColorsDark.card,
        elevation: 0,
        margin: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColorsDark.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _solidButtonStyle(
          backgroundColor: AppColorsDark.primaryBlue,
          foregroundColor: AppColorsDark.white,
          disabledBackgroundColor: AppColorsDark.border,
          disabledForegroundColor: AppColorsDark.disabled,
          overlayColor: AppColorsDark.primaryBlueLight.withValues(alpha: 0.08),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlineButtonStyle(
          foregroundColor: AppColorsDark.primaryBlueLight,
          borderColor: AppColorsDark.border,
          overlayColor: AppColorsDark.primaryBlueLight.withValues(alpha: 0.12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _textButtonStyle(
          foregroundColor: AppColorsDark.primaryBlueLight,
          overlayColor: AppColorsDark.primaryBlueLight.withValues(alpha: 0.12),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColorsDark.card,
        borderColor: AppColorsDark.border,
        focusedColor: AppColorsDark.primaryBlue,
        errorColor: AppColorsDark.dangerRed,
        labelColor: AppColorsDark.textSecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsDark.card,
        disabledColor: AppColorsDark.card,
        selectedColor: AppColorsDark.primaryBlueDark,
        secondarySelectedColor: AppColorsDark.primaryBlueDark,
        deleteIconColor: AppColorsDark.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          side: const BorderSide(color: AppColorsDark.border),
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColorsDark.textPrimary),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColorsDark.white),
        brightness: Brightness.dark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.border,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedItemColor: AppColorsDark.primaryBlueLight,
        unselectedItemColor: AppColorsDark.textSecondary,
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedIconTheme: const IconThemeData(color: AppColorsDark.primaryBlueLight),
        unselectedIconTheme: const IconThemeData(color: AppColorsDark.textSecondary),
        selectedLabelTextStyle: AppTextStyles.labelMedium.copyWith(color: AppColorsDark.primaryBlueLight),
        unselectedLabelTextStyle: AppTextStyles.labelMedium.copyWith(color: AppColorsDark.textSecondary),
        indicatorColor: AppColorsDark.primaryBlueDark,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorsDark.card,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColorsDark.textPrimary),
        actionTextColor: AppColorsDark.primaryBlueLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  /// Creates a shared solid button style with a 48px minimum touch target.
  static ButtonStyle _solidButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color disabledBackgroundColor,
    required Color disabledForegroundColor,
    required Color overlayColor,
  }) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 48)),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.labelLarge),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }

        if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
          return AppColors.primaryBlueDark;
        }

        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }

        return foregroundColor;
      }),
      overlayColor: WidgetStatePropertyAll<Color>(overlayColor),
    );
  }

  /// Creates a shared outlined button style with a 48px minimum touch target.
  static ButtonStyle _outlineButtonStyle({
    required Color foregroundColor,
    required Color borderColor,
    required Color overlayColor,
  }) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 48)),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.labelLarge),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: borderColor)),
      foregroundColor: WidgetStatePropertyAll<Color>(foregroundColor),
      overlayColor: WidgetStatePropertyAll<Color>(overlayColor),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// Creates a shared text button style with a 48px minimum touch target.
  static ButtonStyle _textButtonStyle({
    required Color foregroundColor,
    required Color overlayColor,
  }) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 48)),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.labelLarge),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      foregroundColor: WidgetStatePropertyAll<Color>(foregroundColor),
      overlayColor: WidgetStatePropertyAll<Color>(overlayColor),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// Creates a filled input decoration theme with an emphasized focused border.
  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedColor,
    required Color errorColor,
    required Color labelColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: labelColor),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: labelColor),
      floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(color: focusedColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: focusedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }
}
