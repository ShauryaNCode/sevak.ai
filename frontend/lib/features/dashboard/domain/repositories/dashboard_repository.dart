// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\domain\repositories\dashboard_repository.dart
import 'package:fpdart/fpdart.dart';

import '../entities/dashboard_stats.dart';
import '../entities/need_summary.dart';
import '../failures/dashboard_failure.dart';

/// Contract for retrieving and mutating coordinator dashboard data.
abstract class DashboardRepository {
  /// Loads current top-level stats for the given zone.
  Future<Either<DashboardFailure, DashboardStats>> getStats({
    required String zoneId,
  });

  /// Loads recent needs for the given zone and optional filters.
  Future<Either<DashboardFailure, List<NeedSummary>>> getRecentNeeds({
    required String zoneId,
    int limit = 50,
    String? statusFilter,
    int? priorityFilter,
  });

  /// Watches top-level stats using a live polling stream.
  Stream<DashboardStats> watchStats({
    required String zoneId,
  });

  /// Watches recent needs using a live polling stream.
  Stream<List<NeedSummary>> watchRecentNeeds({
    required String zoneId,
  });

  /// Assigns a volunteer to a need.
  Future<Either<DashboardFailure, void>> assignVolunteer({
    required String needId,
    required String volunteerId,
  });

  /// Updates the status of a need.
  Future<Either<DashboardFailure, void>> updateNeedStatus({
    required String needId,
    required String newStatus,
  });
}
