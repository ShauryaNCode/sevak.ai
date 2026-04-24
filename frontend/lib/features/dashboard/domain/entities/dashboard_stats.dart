// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\domain\entities\dashboard_stats.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

/// Aggregated dashboard metrics for a coordination zone.
@freezed
class DashboardStats with _$DashboardStats {
  /// Creates an immutable dashboard stats entity.
  const factory DashboardStats({
    required int totalActiveNeeds,
    required int criticalNeeds,
    required int totalVolunteers,
    required int availableVolunteers,
    required int totalResources,
    required int resourcesAllocated,
    required int totalIncidents,
    required int activeIncidents,
    required DateTime lastUpdatedAt,
    required String zoneId,
  }) = _DashboardStats;
}

/// Convenience operational calculations for [DashboardStats].
extension DashboardStatsX on DashboardStats {
  /// Percentage of volunteers currently utilized.
  double get volunteerUtilizationRate {
    if (totalVolunteers == 0) {
      return 0;
    }
    final int volunteersOnTask = totalVolunteers - availableVolunteers;
    return (volunteersOnTask / totalVolunteers) * 100;
  }

  /// Percentage of resources currently allocated.
  double get resourceAllocationRate {
    if (totalResources == 0) {
      return 0;
    }
    return (resourcesAllocated / totalResources) * 100;
  }

  /// Whether the zone is currently under critical operational pressure.
  bool get hasCriticalSituation =>
      criticalNeeds > 0 || volunteerUtilizationRate > 90;
}
