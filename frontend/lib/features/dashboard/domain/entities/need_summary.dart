// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\domain\entities\need_summary.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../ui/themes/app_colors.dart';

part 'need_summary.freezed.dart';

/// Flattened dashboard-friendly view of a need document.
@freezed
class NeedSummary with _$NeedSummary {
  /// Creates a summarized need entity.
  const factory NeedSummary({
    required String id,
    required String zoneId,
    required String status,
    required int priority,
    required List<String> needTypes,
    required int affectedCount,
    required String locationRaw,
    required double? locationLat,
    required double? locationLng,
    required String source,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> assignedVolunteerIds,
    required bool aiEnriched,
  }) = _NeedSummary;
}

/// Convenience presentation helpers for [NeedSummary].
extension NeedSummaryX on NeedSummary {
  /// Semantic priority color.
  Color get priorityColor {
    switch (priority) {
      case 5:
        return AppColors.dangerRed;
      case 4:
        return AppColors.warningAmber;
      case 3:
        return AppColors.primaryBlue;
      case 2:
        return AppColors.neutral500;
      case 1:
      default:
        return AppColors.neutral400;
    }
  }

  /// Human-readable priority label.
  String get priorityLabel {
    switch (priority) {
      case 5:
        return 'CRITICAL';
      case 4:
        return 'HIGH';
      case 3:
        return 'MEDIUM';
      case 2:
        return 'LOW';
      case 1:
      default:
        return 'MINIMAL';
    }
  }

  /// Whether the need is overdue for action.
  bool get isOverdue =>
      status == 'OPEN' &&
      priority >= 4 &&
      DateTime.now().toUtc().difference(createdAt.toUtc()) >
          const Duration(hours: 2);

  /// Human-readable age label.
  String get ageLabel {
    final Duration age =
        DateTime.now().toUtc().difference(updatedAt.toUtc());
    if (age.inDays >= 1) {
      return '${age.inDays}d ago';
    }
    if (age.inHours >= 1) {
      final int minutes = age.inMinutes.remainder(60);
      return minutes == 0
          ? '${age.inHours}h ago'
          : '${age.inHours}h ${minutes}m ago';
    }
    if (age.inMinutes >= 1) {
      return '${age.inMinutes}m ago';
    }
    return 'Just now';
  }

  /// Icon representing the originating source.
  IconData get sourceIcon {
    switch (source.toUpperCase()) {
      case 'WHATSAPP':
        return Icons.chat_bubble_rounded;
      case 'SMS':
        return Icons.sms_rounded;
      case 'APP':
      default:
        return Icons.phone_android_rounded;
    }
  }
}
