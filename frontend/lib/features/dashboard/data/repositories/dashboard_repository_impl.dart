// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\data\repositories\dashboard_repository_impl.dart
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/need_summary.dart';
import '../../domain/failures/dashboard_failure.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Dio-backed dashboard repository using polling for live coordinator data.
@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  /// Creates the dashboard repository.
  DashboardRepositoryImpl(
    this._dio,
    this._config,
  );

  final Dio _dio;
  final AppConfig _config;
  static const String _logName = 'SevakAI.Dashboard';

  @override
  Future<Either<DashboardFailure, DashboardStats>> getStats({
    required String zoneId,
  }) async {
    try {
      final Response<Map<String, dynamic>> needsResponse =
          await _dio.get<Map<String, dynamic>>('/needs');
      final Response<Map<String, dynamic>> volunteersResponse =
          await _dio.get<Map<String, dynamic>>(
        '/volunteers',
        queryParameters: <String, dynamic>{'zone_id': zoneId},
      );
      final Response<Map<String, dynamic>> campsResponse =
          await _dio.get<Map<String, dynamic>>(
        '/camps',
        queryParameters: <String, dynamic>{'zone_id': zoneId},
      );

      final List<NeedSummary> needs =
          (needsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[])
              .whereType<Map<dynamic, dynamic>>()
              .map(
                (Map<dynamic, dynamic> item) => _mapNeed(
                  Map<String, dynamic>.from(item),
                  zoneId,
                ),
              )
              .toList();
      final List<Map<String, dynamic>> volunteers =
          (volunteersResponse.data?['data'] as List<dynamic>? ?? <dynamic>[])
              .whereType<Map<dynamic, dynamic>>()
              .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
              .toList();
      final List<Map<String, dynamic>> camps =
          (campsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[])
              .whereType<Map<dynamic, dynamic>>()
              .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
              .toList();

      final int activeNeeds =
          needs.where((NeedSummary need) => need.status != 'FULFILLED').length;
      final int criticalNeeds =
          needs.where((NeedSummary need) => need.priority >= 4).length;
      final int totalVolunteers = volunteers.length;
      final int availableVolunteers = volunteers.where((Map<String, dynamic> volunteer) {
        final String status = '${volunteer['status'] ?? ''}'.toLowerCase();
        return status.isEmpty || status == 'available';
      }).length;
      final int totalResources = camps.isEmpty ? 12 : camps.length * 4;
      final int resourcesAllocated = camps
          .where((Map<String, dynamic> camp) => '${camp['status']}' == 'active')
          .length
          .clamp(0, totalResources);
      final int activeIncidents = criticalNeeds == 0 ? 0 : criticalNeeds.clamp(1, 9);

      return right(
        DashboardStats(
          totalActiveNeeds: activeNeeds,
          criticalNeeds: criticalNeeds,
          totalVolunteers: totalVolunteers,
          availableVolunteers: availableVolunteers,
          totalResources: totalResources,
          resourcesAllocated: resourcesAllocated,
          totalIncidents: activeIncidents,
          activeIncidents: activeIncidents,
          lastUpdatedAt: DateTime.now().toUtc(),
          zoneId: zoneId,
        ),
      );
    } on DioException catch (error, stackTrace) {
      log(
        'Failed to load dashboard stats.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(_mapFailure(error));
    } catch (error, stackTrace) {
      log(
        'Unexpected dashboard stats failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(DashboardFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<Either<DashboardFailure, List<NeedSummary>>> getRecentNeeds({
    required String zoneId,
    int limit = 50,
    String? statusFilter,
    int? priorityFilter,
  }) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '/needs',
        queryParameters: <String, dynamic>{
          if (statusFilter != null && statusFilter.isNotEmpty)
            'status': _toBackendStatus(statusFilter),
        },
      );

      final List<dynamic> rawItems =
          (response.data?['data'] as List<dynamic>? ?? <dynamic>[]);
      List<NeedSummary> mapped = rawItems
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) => _mapNeed(
              Map<String, dynamic>.from(item),
              zoneId,
            ),
          )
          .toList()
        ..sort(
          (NeedSummary a, NeedSummary b) =>
              b.updatedAt.compareTo(a.updatedAt),
        );

      if (priorityFilter != null) {
        mapped = mapped
            .where((NeedSummary need) => need.priority == priorityFilter)
            .toList();
      }

      return right(mapped.take(limit).toList());
    } on DioException catch (error, stackTrace) {
      log(
        'Failed to load dashboard needs.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(_mapFailure(error));
    } catch (error, stackTrace) {
      log(
        'Unexpected dashboard needs failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(DashboardFailure.unknown(message: error.toString()));
    }
  }

  @override
  Stream<DashboardStats> watchStats({required String zoneId}) async* {
    while (true) {
      final Either<DashboardFailure, DashboardStats> result =
          await getStats(zoneId: zoneId);
      yield* result.match(
        (DashboardFailure failure) =>
            Stream<DashboardStats>.error(failure.userMessage),
        (DashboardStats stats) => Stream<DashboardStats>.value(stats),
      );
      await Future<void>.delayed(_config.syncInterval);
    }
  }

  @override
  Stream<List<NeedSummary>> watchRecentNeeds({required String zoneId}) async* {
    while (true) {
      final Either<DashboardFailure, List<NeedSummary>> result =
          await getRecentNeeds(zoneId: zoneId, limit: 100);
      yield* result.match(
        (DashboardFailure failure) =>
            Stream<List<NeedSummary>>.error(failure.userMessage),
        (List<NeedSummary> needs) => Stream<List<NeedSummary>>.value(needs),
      );
      await Future<void>.delayed(_config.syncInterval);
    }
  }

  @override
  Future<Either<DashboardFailure, void>> assignVolunteer({
    required String needId,
    required String volunteerId,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/assign',
        data: <String, dynamic>{
          'need_id': needId,
          'volunteer_id': volunteerId,
        },
      );
      return right(null);
    } on DioException catch (error, stackTrace) {
      log(
        'Failed to assign volunteer from dashboard.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(_mapFailure(error));
    } catch (error, stackTrace) {
      log(
        'Unexpected volunteer assignment failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(DashboardFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<Either<DashboardFailure, void>> updateNeedStatus({
    required String needId,
    required String newStatus,
  }) async {
    try {
      await _dio.patch<Map<String, dynamic>>(
        '/needs/$needId/status',
        data: <String, dynamic>{'status': _toBackendStatus(newStatus)},
      );
      return right(null);
    } on DioException catch (error, stackTrace) {
      log(
        'Failed to update need status from dashboard.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(_mapFailure(error));
    } catch (error, stackTrace) {
      log(
        'Unexpected need status update failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(DashboardFailure.unknown(message: error.toString()));
    }
  }

  NeedSummary _mapNeed(Map<String, dynamic> json, String zoneId) {
    final Map<String, dynamic> location =
        Map<String, dynamic>.from(json['location'] as Map? ?? <String, dynamic>{});
    final String urgency = '${json['urgency'] ?? ''}'.toLowerCase();
    final String status = '${json['status'] ?? 'pending'}'.toLowerCase();
    final String updatedAtRaw = '${json['updated_at'] ?? json['created_at'] ?? DateTime.now().toUtc().toIso8601String()}';
    final String createdAtRaw = '${json['created_at'] ?? json['timestamp'] ?? DateTime.now().toUtc().toIso8601String()}';
    final String? assignedVolunteerId = json['assigned_volunteer_id'] as String?;
    final int affectedCount = (json['affected_count'] as num?)?.toInt() ?? 1;
    final String source = '${json['source'] ?? 'APP'}'.toUpperCase();

    return NeedSummary(
      id: '${json['id'] ?? ''}',
      zoneId: zoneId,
      status: _mapStatus(status),
      priority: _mapPriority(urgency),
      needTypes: <String>['${json['need_type'] ?? 'general'}'.toUpperCase()],
      affectedCount: affectedCount,
      locationRaw: '${location['label'] ?? location['pincode'] ?? 'Unknown location'}',
      locationLat: (location['lat'] as num?)?.toDouble(),
      locationLng: (location['lng'] as num?)?.toDouble(),
      source: source,
      createdAt: DateTime.tryParse(createdAtRaw)?.toUtc() ?? DateTime.now().toUtc(),
      updatedAt: DateTime.tryParse(updatedAtRaw)?.toUtc() ?? DateTime.now().toUtc(),
      assignedVolunteerIds:
          assignedVolunteerId == null ? <String>[] : <String>[assignedVolunteerId],
      aiEnriched: location['lat'] != null && location['lng'] != null,
    );
  }

  int _mapPriority(String urgency) {
    switch (urgency) {
      case 'high':
        return 5;
      case 'medium':
        return 3;
      case 'low':
      default:
        return 2;
    }
  }

  String _mapStatus(String backendStatus) {
    switch (backendStatus) {
      case 'assigned':
        return 'ASSIGNED';
      case 'completed':
        return 'FULFILLED';
      case 'pending':
      default:
        return 'OPEN';
    }
  }

  String _toBackendStatus(String status) {
    switch (status) {
      case 'ASSIGNED':
        return 'assigned';
      case 'IN_PROGRESS':
      case 'FULFILLED':
        return 'completed';
      case 'OPEN':
      default:
        return 'pending';
    }
  }

  DashboardFailure _mapFailure(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const DashboardFailure.network();
    }
    final int? statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return DashboardFailure.server(statusCode: statusCode);
    }
    return DashboardFailure.unknown(message: error.message ?? 'Unknown dashboard error');
  }
}
