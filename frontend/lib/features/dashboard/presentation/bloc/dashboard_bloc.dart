// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\bloc\dashboard_bloc.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/need_summary.dart';
import '../../domain/failures/dashboard_failure.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_bloc.freezed.dart';

/// Coordinates the real-time admin dashboard data and optimistic actions.
///
/// Performance target:
/// `initialized -> loading` should emit inside the same event turn (< 1 frame),
/// and `loading -> loaded` should normally complete within 500ms P95.
@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// Creates the dashboard BLoC.
  DashboardBloc(this._repository) : super(const DashboardState.initial()) {
    on<DashboardInitialized>(_onInitialized);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<NeedStatusUpdated>(_onNeedStatusUpdated);
    on<VolunteerAssigned>(_onVolunteerAssigned);
    on<FilterChanged>(_onFilterChanged);
    on<DashboardDisposed>(_onDisposed);
    on<_DashboardStatsArrived>(_onStatsArrived);
    on<_DashboardNeedsArrived>(_onNeedsArrived);
    on<_DashboardStreamFailed>(_onStreamFailed);
  }

  final DashboardRepository _repository;
  StreamSubscription<DashboardStats>? _statsSubscription;
  StreamSubscription<List<NeedSummary>>? _needsSubscription;
  DashboardStats? _latestStats;
  List<NeedSummary> _rawNeeds = <NeedSummary>[];
  String? _zoneId;
  String? _statusFilter;
  int? _priorityFilter;
  String? _sourceFilter;

  Future<void> _onInitialized(
    DashboardInitialized event,
    Emitter<DashboardState> emit,
  ) async {
    _zoneId = event.zoneId;
    emit(const DashboardState.loading());
    await _statsSubscription?.cancel();
    await _needsSubscription?.cancel();

    _statsSubscription = _repository.watchStats(zoneId: event.zoneId).listen(
      (DashboardStats stats) => add(DashboardEvent.statsArrived(stats)),
      onError: (Object error, StackTrace stackTrace) {
        add(
          DashboardEvent.streamFailed(
            DashboardFailure.stream(message: error.toString()),
          ),
        );
      },
    );
    _needsSubscription = _repository.watchRecentNeeds(zoneId: event.zoneId).listen(
      (List<NeedSummary> needs) => add(DashboardEvent.needsArrived(needs)),
      onError: (Object error, StackTrace stackTrace) {
        add(
          DashboardEvent.streamFailed(
            DashboardFailure.stream(message: error.toString()),
          ),
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (_zoneId == null) {
      return;
    }
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(isRefreshing: true));
    }
    final statsResult = await _repository.getStats(zoneId: _zoneId!);
    final needsResult = await _repository.getRecentNeeds(zoneId: _zoneId!, limit: 100);
    statsResult.match(
      (DashboardFailure failure) =>
          add(DashboardEvent.streamFailed(failure)),
      (DashboardStats stats) => add(DashboardEvent.statsArrived(stats)),
    );
    needsResult.match(
      (DashboardFailure failure) =>
          add(DashboardEvent.streamFailed(failure)),
      (List<NeedSummary> needs) => add(DashboardEvent.needsArrived(needs)),
    );
  }

  Future<void> _onNeedStatusUpdated(
    NeedStatusUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    final List<NeedSummary> previous = List<NeedSummary>.from(_rawNeeds);
    _rawNeeds = _rawNeeds
        .map(
          (NeedSummary need) => need.id == event.needId
              ? need.copyWith(status: event.newStatus, updatedAt: DateTime.now().toUtc())
              : need,
        )
        .toList();
    _emitLoaded(emit, isRefreshing: true);
    final result = await _repository.updateNeedStatus(
      needId: event.needId,
      newStatus: event.newStatus,
    );
    result.match(
      (DashboardFailure failure) {
        _rawNeeds = previous;
        _emitLoaded(emit);
        emit(DashboardState.error(
          failure: failure,
          lastKnownStats: _latestStats,
        ));
      },
      (_) => _emitLoaded(emit),
    );
  }

  Future<void> _onVolunteerAssigned(
    VolunteerAssigned event,
    Emitter<DashboardState> emit,
  ) async {
    final List<NeedSummary> previous = List<NeedSummary>.from(_rawNeeds);
    _rawNeeds = _rawNeeds
        .map(
          (NeedSummary need) => need.id == event.needId
              ? need.copyWith(
                  status: 'ASSIGNED',
                  assignedVolunteerIds: <String>[event.volunteerId],
                  updatedAt: DateTime.now().toUtc(),
                )
              : need,
        )
        .toList();
    _emitLoaded(emit, isRefreshing: true);
    final result = await _repository.assignVolunteer(
      needId: event.needId,
      volunteerId: event.volunteerId,
    );
    result.match(
      (DashboardFailure failure) {
        _rawNeeds = previous;
        _emitLoaded(emit);
        emit(DashboardState.error(
          failure: failure,
          lastKnownStats: _latestStats,
        ));
      },
      (_) => _emitLoaded(emit),
    );
  }

  void _onFilterChanged(
    FilterChanged event,
    Emitter<DashboardState> emit,
  ) {
    _statusFilter = event.statusFilter;
    _priorityFilter = event.priorityFilter;
    _sourceFilter = event.sourceFilter;
    _emitLoaded(emit);
  }

  Future<void> _onDisposed(
    DashboardDisposed event,
    Emitter<DashboardState> emit,
  ) async {
    await _statsSubscription?.cancel();
    await _needsSubscription?.cancel();
    _statsSubscription = null;
    _needsSubscription = null;
  }

  void _onStatsArrived(
    _DashboardStatsArrived event,
    Emitter<DashboardState> emit,
  ) {
    _latestStats = event.stats;
    _emitLoaded(emit);
  }

  void _onNeedsArrived(
    _DashboardNeedsArrived event,
    Emitter<DashboardState> emit,
  ) {
    _rawNeeds = event.needs;
    _emitLoaded(emit);
  }

  void _onStreamFailed(
    _DashboardStreamFailed event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      DashboardState.error(
        failure: event.failure,
        lastKnownStats: _latestStats,
      ),
    );
  }

  @visibleForTesting
  List<NeedSummary> applyFilters(List<NeedSummary> needs) {
    return needs.where((NeedSummary need) {
      final bool statusMatches =
          _statusFilter == null || _statusFilter == need.status;
      final bool priorityMatches =
          _priorityFilter == null || _priorityFilter == need.priority;
      final bool sourceMatches = _sourceFilter == null ||
          _sourceFilter == need.source.toUpperCase();
      return statusMatches && priorityMatches && sourceMatches;
    }).toList();
  }

  void _emitLoaded(
    Emitter<DashboardState> emit, {
    bool isRefreshing = false,
  }) {
    if (_latestStats == null) {
      return;
    }
    final DashboardState next = DashboardState.loaded(
      stats: _latestStats!,
      needs: applyFilters(_rawNeeds),
      statusFilter: _statusFilter,
      priorityFilter: _priorityFilter,
      sourceFilter: _sourceFilter,
      isRefreshing: isRefreshing,
      lastRefreshedAt: DateTime.now().toUtc(),
    );
    emit(next);
  }

  @override
  Future<void> close() async {
    await _statsSubscription?.cancel();
    await _needsSubscription?.cancel();
    return super.close();
  }
}

/// Events accepted by [DashboardBloc].
@freezed
class DashboardEvent with _$DashboardEvent {
  /// Starts dashboard polling for a zone.
  const factory DashboardEvent.initialized({
    required String zoneId,
  }) = DashboardInitialized;

  /// Manually refreshes dashboard data.
  const factory DashboardEvent.refreshRequested() = DashboardRefreshRequested;

  /// Updates a need status optimistically.
  const factory DashboardEvent.needStatusUpdated({
    required String needId,
    required String newStatus,
  }) = NeedStatusUpdated;

  /// Assigns a volunteer optimistically.
  const factory DashboardEvent.volunteerAssigned({
    required String needId,
    required String volunteerId,
  }) = VolunteerAssigned;

  /// Applies client-side dashboard filters.
  const factory DashboardEvent.filterChanged({
    String? statusFilter,
    int? priorityFilter,
    String? sourceFilter,
  }) = FilterChanged;

  /// Disposes dashboard subscriptions.
  const factory DashboardEvent.disposed() = DashboardDisposed;

  /// Internal stats event.
  const factory DashboardEvent.statsArrived(DashboardStats stats) =
      _DashboardStatsArrived;

  /// Internal needs event.
  const factory DashboardEvent.needsArrived(List<NeedSummary> needs) =
      _DashboardNeedsArrived;

  /// Internal stream error event.
  const factory DashboardEvent.streamFailed(DashboardFailure failure) =
      _DashboardStreamFailed;
}

/// States emitted by [DashboardBloc].
@freezed
class DashboardState with _$DashboardState {
  /// Initial dashboard state.
  const factory DashboardState.initial() = DashboardInitial;

  /// Loading dashboard state.
  const factory DashboardState.loading() = DashboardLoading;

  /// Fully loaded dashboard state.
  const factory DashboardState.loaded({
    required DashboardStats stats,
    required List<NeedSummary> needs,
    required String? statusFilter,
    required int? priorityFilter,
    required String? sourceFilter,
    required bool isRefreshing,
    required DateTime lastRefreshedAt,
  }) = DashboardLoaded;

  /// Error state with optional stale stats.
  const factory DashboardState.error({
    required DashboardFailure failure,
    DashboardStats? lastKnownStats,
  }) = DashboardError;
}
