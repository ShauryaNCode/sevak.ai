// lib/sync/models/sync_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_state.freezed.dart';

/// Enumerates high-level sync engine statuses for quick UI checks.
enum SyncStatus {
  /// No sync activity is currently running.
  idle,

  /// A sync session is currently in progress.
  syncing,

  /// The most recent sync operation succeeded.
  success,

  /// The most recent sync operation failed.
  error,

  /// Sync is paused because connectivity is unavailable.
  offline,
}

/// Represents the externally visible state of the background sync engine.
///
/// This union depends on `freezed` for exhaustive pattern matching. It encodes
/// ordered progress transitions so UI surfaces can react to syncing, success,
/// offline pauses, and retryable failures without reading engine internals.
@freezed
class SyncState with _$SyncState {
  /// No sync work is in progress.
  const factory SyncState.idle() = SyncIdle;

  /// A sync session is currently processing outbox items or pulling changes.
  const factory SyncState.syncing({
    required int pendingCount,
    required int processedCount,
  }) = SyncInProgress;

  /// Local mutations were successfully pushed to the server.
  const factory SyncState.pushSuccess({
    required int syncedCount,
    required DateTime syncedAt,
  }) = SyncPushSuccess;

  /// Remote changes were successfully pulled and applied locally.
  const factory SyncState.pullSuccess({
    required int changesApplied,
    required String lastSeq,
    required DateTime syncedAt,
  }) = SyncPullSuccess;

  /// Sync failed with an error that may or may not be retried automatically.
  const factory SyncState.error({
    required String message,
    required bool isRetrying,
    required int retryCount,
  }) = SyncError;

  /// Sync is paused because internet connectivity is unavailable.
  const factory SyncState.offline() = SyncOffline;
}

/// Adds convenience accessors for common sync UI conditions.
extension SyncStateX on SyncState {
  /// Returns whether the engine is currently syncing.
  bool get isSyncing => maybeWhen(
        syncing: (_, __) => true,
        orElse: () => false,
      );

  /// Returns whether the engine is currently offline.
  bool get isOffline => maybeWhen(
        offline: () => true,
        orElse: () => false,
      );

  /// Returns whether the engine is currently in an error state.
  bool get hasError => maybeWhen(
        error: (_, __, ___) => true,
        orElse: () => false,
      );

  /// Maps a sync state to its coarse status enum.
  SyncStatus get status => when(
        idle: () => SyncStatus.idle,
        syncing: (_, __) => SyncStatus.syncing,
        pushSuccess: (_, __) => SyncStatus.success,
        pullSuccess: (_, __, ___) => SyncStatus.success,
        error: (_, __, ___) => SyncStatus.error,
        offline: () => SyncStatus.offline,
      );
}
