// C:\Users\th366\Desktop\sevakai\frontend\lib\ui\themes\app_colors.dart
import 'package:flutter/material.dart';

/// Centralized color tokens for the SevakAI light theme.
abstract final class AppColors {
  /// Prevents instantiation.
  const AppColors._();

  // Primary palette
  /// Primary blue used for core actions, navigation, and CTAs.
  static const Color primaryBlue = Color(0xFF2563EB);

  /// Darker primary blue used for pressed and hover states.
  static const Color primaryBlueDark = Color(0xFF1D4ED8);

  /// Tinted light primary blue used for soft backgrounds.
  static const Color primaryBlueLight = Color(0xFFDBEAFE);

  // Semantic colors
  /// Danger red used for critical alerts and destructive feedback.
  static const Color dangerRed = Color(0xFFEF4444);

  /// Light danger red used for critical background surfaces.
  static const Color dangerRedLight = Color(0xFFFEE2E2);

  /// Success green used for positive states and fulfilled actions.
  static const Color successGreen = Color(0xFF22C55E);

  /// Light success green used for positive background surfaces.
  static const Color successGreenLight = Color(0xFFDCFCE7);

  /// Warning amber used for warnings and pending states.
  static const Color warningAmber = Color(0xFFF59E0B);

  /// Light warning amber used for warning background surfaces.
  static const Color warningAmberLight = Color(0xFFFEF3C7);

  // Neutral palette
  /// Neutral background token for pages.
  static const Color neutral50 = Color(0xFFF9FAFB);

  /// Neutral token for cards and subtle fills.
  static const Color neutral100 = Color(0xFFF3F4F6);

  /// Neutral token for borders and dividers.
  static const Color neutral200 = Color(0xFFE5E7EB);

  /// Neutral token used by low-emphasis sidebar text.
  static const Color neutral300 = Color(0xFFCBD5E1);

  /// Neutral token for disabled and placeholder content.
  static const Color neutral400 = Color(0xFF9CA3AF);

  /// Neutral token for secondary interface text.
  static const Color neutral500 = Color(0xFF6B7280);

  /// Neutral token for secondary text.
  static const Color neutral600 = Color(0xFF4B5563);

  /// Neutral token for primary body text.
  static const Color neutral800 = Color(0xFF1F2937);

  /// Neutral token for headings and high-emphasis text.
  static const Color neutral900 = Color(0xFF111827);

  // Base colors
  /// Pure white used for high-contrast surfaces.
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent color token for invisible surfaces and borders.
  static const Color transparent = Color(0x00000000);

  /// Deep navy used for coordinator dashboard side navigation.
  static const Color sidebarBackground = Color(0xFF1E3A5F);

  /// Blue active accent used inside dashboard navigation.
  static const Color sidebarActive = primaryBlue;

  /// Default dashboard sidebar text color.
  static const Color sidebarText = neutral300;

  /// Active dashboard sidebar text color.
  static const Color sidebarActiveText = white;

  /// Shared header background token for dashboard chrome.
  static const Color headerBackground = white;

  /// Shared header border token for dashboard chrome.
  static const Color headerBorder = neutral200;

  /// Maps a disaster response priority level to its semantic color.
  static Color priorityColor(int priority) {
    switch (priority) {
      case 5:
        return dangerRed;
      case 4:
        return warningAmber;
      case 3:
        return primaryBlue;
      case 2:
        return neutral600;
      case 1:
      default:
        return neutral400;
    }
  }
}

/// Centralized color tokens for the SevakAI dark theme.
abstract final class AppColorsDark {
  /// Prevents instantiation.
  const AppColorsDark._();

  // Dark surfaces
  /// Primary dark background surface.
  static const Color surface = Color(0xFF111827);

  /// Secondary dark card and container surface.
  static const Color card = Color(0xFF1F2937);

  /// Elevated input and subtle dark fill surface.
  static const Color surfaceVariant = Color(0xFF374151);

  // Shared semantic accents
  /// Primary blue accent retained across themes.
  static const Color primaryBlue = AppColors.primaryBlue;

  /// Darker primary blue accent retained across themes.
  static const Color primaryBlueDark = AppColors.primaryBlueDark;

  /// Light primary blue accent retained across themes.
  static const Color primaryBlueLight = AppColors.primaryBlueLight;

  /// Danger red accent retained across themes.
  static const Color dangerRed = AppColors.dangerRed;

  /// Light danger red accent retained across themes.
  static const Color dangerRedLight = AppColors.dangerRedLight;

  /// Success green accent retained across themes.
  static const Color successGreen = AppColors.successGreen;

  /// Light success green accent retained across themes.
  static const Color successGreenLight = AppColors.successGreenLight;

  /// Warning amber accent retained across themes.
  static const Color warningAmber = AppColors.warningAmber;

  /// Light warning amber accent retained across themes.
  static const Color warningAmberLight = AppColors.warningAmberLight;

  // Dark neutrals
  /// High-emphasis text color on dark surfaces.
  static const Color textPrimary = Color(0xFFF9FAFB);

  /// Medium-emphasis text color on dark surfaces.
  static const Color textSecondary = Color(0xFFE5E7EB);

  /// Border color for dark surfaces.
  static const Color border = Color(0xFF4B5563);

  /// Disabled and placeholder color for dark surfaces.
  static const Color disabled = Color(0xFF9CA3AF);

  /// Pure white retained for contrast accents.
  static const Color white = AppColors.white;
}
