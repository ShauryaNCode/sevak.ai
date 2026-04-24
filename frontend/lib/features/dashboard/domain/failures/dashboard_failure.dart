// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\domain\failures\dashboard_failure.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_failure.freezed.dart';

/// Failures emitted by the dashboard feature.
@freezed
class DashboardFailure with _$DashboardFailure {
  /// Network connectivity or timeout issue.
  const factory DashboardFailure.network() = DashboardNetworkFailure;

  /// Server-side failure.
  const factory DashboardFailure.server({
    required int statusCode,
  }) = DashboardServerFailure;

  /// Live dashboard stream failed.
  const factory DashboardFailure.stream({
    required String message,
  }) = DashboardStreamFailure;

  /// Unexpected dashboard issue.
  const factory DashboardFailure.unknown({
    required String message,
  }) = DashboardUnknownFailure;
}

/// Convenience helpers for [DashboardFailure].
extension DashboardFailureX on DashboardFailure {
  /// User-facing fallback message.
  String get userMessage => when(
        network: () => 'Unable to reach the latest dashboard data.',
        server: (int statusCode) => 'Dashboard server error ($statusCode).',
        stream: (String message) => message,
        unknown: (String message) => message,
      );
}
