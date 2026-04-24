// lib/sync/sync_engine.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../core/config/app_config.dart';
import '../services/connectivity_service.dart';
import 'local_change_applier.dart';
import 'models/outbox_item.dart';
import 'models/sync_state.dart';
import 'outbox_repository.dart';
import 'replication_client.dart' as replication;

/// Coordinates background push and pull sync cycles for offline-first data.
///
/// This engine depends on outbox persistence, the replication client,
/// connectivity observation, local change application, and sync metadata
/// storage. It guarantees that pending outbox items are processed in FIFO
/// order, never overlaps sync sessions, and stops promptly when connectivity is
/// lost or logout/shutdown requests cancellation.
abstract class SyncEngine {
  /// Broadcast stream of sync state updates for UI and diagnostics.
  Stream<SyncState> get stateStream;

  /// Synchronous view of the current sync state.
  SyncState get currentState;

  /// Starts background sync listeners and periodic timers.
  Future<void> start();

  /// Stops background sync work and releases internal resources.
  Future<void> stop();

  /// Triggers a manual sync attempt.
  Future<void> triggerSync();

  /// Persists a new mutation and opportunistically schedules sync.
  Future<void> enqueue(OutboxItem item);

  /// Releases timers, subscriptions, and state streams owned by the engine.
  Future<void> dispose();
}

/// Default implementation of the SevakAI background sync engine.
@LazySingleton(as: SyncEngine)
class SyncEngineImpl implements SyncEngine {
  /// Creates the sync engine.
  SyncEngineImpl(
    this._outboxRepository,
    this._replicationClient,
    this._connectivityService,
    this._localChangeApplier,
    this._config,
    this._hive,
  ) {
    if (kDebugMode) {
      debugTools = SyncEngineTest._(this);
    }
  }

  final OutboxRepository _outboxRepository;
  final replication.ReplicationClient _replicationClient;
  final ConnectivityService _connectivityService;
  final LocalChangeApplier _localChangeApplier;
  final AppConfig _config;
  final HiveInterface _hive;

  final StreamController<SyncState> _stateController =
      StreamController<SyncState>.broadcast();

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  SyncState _currentState = const SyncState.idle();
  bool _isStarted = false;
  bool _isCancelled = false;
  Completer<void>? _syncLock;

  static const String _logName = 'SevakAI.SyncEngine';
  static const String _syncMetaBoxName = 'sync_meta';

  /// Debug-only manual controls exposed for DevTools experimentation.
  SyncEngineTest? debugTools;

  @override
  Stream<SyncState> get stateStream => _stateController.stream;

  @override
  SyncState get currentState => _currentState;

  @override
  Future<void> start() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    _isCancelled = false;

    _connectivitySubscription = _connectivityService.statusStream.listen(
      (ConnectivityStatus status) async {
        if (status == ConnectivityStatus.online) {
          _isCancelled = false;
          await Future<void>.delayed(const Duration(seconds: 2));
          if (!_isCancelled) {
            await _performSync();
          }
          return;
        }

        if (status == ConnectivityStatus.offline) {
          _isCancelled = true;
          _emitState(const SyncState.offline());
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log(
          'Connectivity subscription failed.',
          name: _logName,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    _periodicSyncTimer = Timer.periodic(
      _config.syncInterval,
      (Timer _) async {
        if (_connectivityService.currentStatus == ConnectivityStatus.online &&
            !_isCancelled) {
          await _performSync();
        }
      },
    );

    final ConnectivityStatus initialStatus = await _connectivityService.checkNow();
    if (initialStatus == ConnectivityStatus.online) {
      await _performSync();
    } else {
      _emitState(const SyncState.offline());
    }
  }

  @override
  Future<void> stop() async {
    _isCancelled = true;
    _isStarted = false;
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _emitState(const SyncState.idle());
  }

  @override
  Future<void> triggerSync() async {
    if (_connectivityService.currentStatus != ConnectivityStatus.online) {
      _emitState(const SyncState.offline());
      return;
    }

    _isCancelled = false;
    await _performSync();
  }

  @override
  Future<void> enqueue(OutboxItem item) async {
    await _outboxRepository.enqueue(item);
    if (_connectivityService.currentStatus == ConnectivityStatus.online) {
      await _performSync();
    }
  }

  /// Disposes internal resources when the singleton is released.
  @override
  @disposeMethod
  Future<void> dispose() async {
    await stop();
    await _stateController.close();
  }

  /// Acquires the sync lock to prevent overlapping sync sessions.
  Future<bool> _acquireLock() async {
    if (_syncLock != null) {
      return false;
    }
    _syncLock = Completer<void>();
    return true;
  }

  /// Releases the sync lock.
  void _releaseLock() {
    _syncLock?.complete();
    _syncLock = null;
  }

  /// Runs one full push-then-pull sync session if no other session is active.
  Future<void> _performSync() async {
    if (_isCancelled || !await _acquireLock()) {
      return;
    }

    int pendingCount = 0;

    try {
      pendingCount = await _outboxRepository.getPendingCount();
      _emitState(
        SyncState.syncing(
          pendingCount: pendingCount,
          processedCount: 0,
        ),
      );

      final _PushSessionResult pushResult = await _pushPendingItems();
      if (_isCancelled) {
        return;
      }

      if (pushResult.errorMessage != null) {
        _emitState(
          SyncState.error(
            message: pushResult.errorMessage!,
            isRetrying: pushResult.isRetrying,
            retryCount: pushResult.retryCount,
          ),
        );
        return;
      }

      _emitState(
        SyncState.pushSuccess(
          syncedCount: pushResult.syncedCount,
          syncedAt: DateTime.now().toUtc(),
        ),
      );

      final _PullSessionResult pullResult = await _pullChanges();
      if (_isCancelled) {
        return;
      }

      if (pullResult.errorMessage != null) {
        _emitState(
          SyncState.error(
            message: pullResult.errorMessage!,
            isRetrying: pullResult.isRetrying,
            retryCount: pushResult.retryCount,
          ),
        );
        return;
      }

      _emitState(
        SyncState.pullSuccess(
          changesApplied: pullResult.changesApplied,
          lastSeq: pullResult.lastSeq,
          syncedAt: DateTime.now().toUtc(),
        ),
      );
    } catch (error, stackTrace) {
      log(
        'Unexpected sync failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      _emitState(
        const SyncState.error(
          message: 'Unexpected sync failure.',
          isRetrying: true,
          retryCount: 0,
        ),
      );
    } finally {
      _releaseLock();
    }
  }

  /// Pushes pending outbox items in FIFO batches while respecting retry delays.
  Future<_PushSessionResult> _pushPendingItems() async {
    final List<OutboxItem> pendingItems = await _outboxRepository.getPending();
    final DateTime now = DateTime.now().toUtc();
    final List<OutboxItem> eligibleItems = pendingItems.where((OutboxItem item) {
      if (!item.isRetryable) {
        return false;
      }

      if (item.lastAttemptAt == null) {
        return true;
      }

      return now.difference(item.lastAttemptAt!) >= item.nextRetryDelay;
    }).toList();

    int syncedCount = 0;
    int processedCount = 0;
    int retryCount = 0;

    for (int startIndex = 0;
        startIndex < eligibleItems.length && !_isCancelled;
        startIndex += _config.maxSyncBatchSize) {
      final int endIndex = (startIndex + _config.maxSyncBatchSize) > eligibleItems.length
          ? eligibleItems.length
          : startIndex + _config.maxSyncBatchSize;
      final List<OutboxItem> batch = eligibleItems.sublist(startIndex, endIndex);

      final replication.SyncPushResult result = await _replicationClient.push(batch);

      await result.map(
        success: (replication.SyncPushSuccess success) async {
          final Set<String> syncedIds = success.syncedIds.toSet();
          final Map<String, List<OutboxItem>> itemsByDocumentId =
              <String, List<OutboxItem>>{};

          for (final OutboxItem item in batch) {
            itemsByDocumentId.putIfAbsent(item.documentId, () => <OutboxItem>[]).add(item);
          }

          for (final OutboxItem item in batch) {
            final bool markedWithOutboxId = syncedIds.contains(item.id);
            final bool markedWithDocumentId = syncedIds.contains(item.documentId);
            if (markedWithOutboxId || markedWithDocumentId) {
              await _outboxRepository.remove(item.id);
              syncedCount += 1;
            }
          }

          for (final replication.SyncPushItemError error in success.errors) {
            final List<OutboxItem> erroredItems =
                itemsByDocumentId[error.documentId] ?? <OutboxItem>[];
            for (final OutboxItem item in erroredItems) {
              await _outboxRepository.markAsDeadLetter(item.id, error.reason);
            }
          }

          processedCount += batch.length;
          _emitState(
            SyncState.syncing(
              pendingCount: await _outboxRepository.getPendingCount(),
              processedCount: processedCount,
            ),
          );
        },
        failure: (replication.SyncPushFailure failure) async {
          if (failure.isRetryable) {
            for (final OutboxItem item in batch) {
              final OutboxItem updated = item.copyWithRetry(failure.message);
              retryCount = updated.retryCount;
              await _outboxRepository.update(updated);
            }
          } else {
            log(
              'Non-retryable push failure encountered. Moving batch to dead letter.',
              name: _logName,
            );
            for (final OutboxItem item in batch) {
              await _outboxRepository.markAsDeadLetter(item.id, failure.message);
            }
          }
        },
      );

      if (result is replication.SyncPushFailure) {
        return _PushSessionResult(
          syncedCount: syncedCount,
          retryCount: retryCount,
          errorMessage: result.message,
          isRetrying: result.isRetryable,
        );
      }
    }

    return _PushSessionResult(
      syncedCount: syncedCount,
      retryCount: retryCount,
      errorMessage: null,
      isRetrying: false,
    );
  }

  /// Pulls remote changes recursively until the local cursor is caught up.
  Future<_PullSessionResult> _pullChanges() async {
    if (_isCancelled) {
      return const _PullSessionResult(
        changesApplied: 0,
        lastSeq: '0',
        errorMessage: null,
        isRetrying: false,
      );
    }

    try {
      final Box<dynamic> syncMetaBox = await _openSyncMetaBox();
      final String lastSeq = (syncMetaBox.get('last_seq') as String?) ?? '0';
      final String zoneId = (syncMetaBox.get('zone_id') as String?) ?? 'default_zone';

      final replication.SyncPullResult result = await _replicationClient.pull(
        since: lastSeq,
        zoneId: zoneId,
      );

      return result.map(
        success: (replication.SyncPullSuccess success) async {
          await _localChangeApplier.apply(success.changes);
          await syncMetaBox.put('last_seq', success.lastSeq);

          if (success.hasMore && !_isCancelled) {
            final _PullSessionResult nested = await _pullChanges();
            return _PullSessionResult(
              changesApplied: success.changes.length + nested.changesApplied,
              lastSeq: nested.lastSeq,
              errorMessage: nested.errorMessage,
              isRetrying: nested.isRetrying,
            );
          }

          return _PullSessionResult(
            changesApplied: success.changes.length,
            lastSeq: success.lastSeq,
            errorMessage: null,
            isRetrying: false,
          );
        },
        failure: (replication.SyncPullFailure failure) async {
          return _PullSessionResult(
            changesApplied: 0,
            lastSeq: lastSeq,
            errorMessage: failure.message,
            isRetrying: failure.isRetryable,
          );
        },
      );
    } catch (error, stackTrace) {
      log(
        'Failed while pulling remote changes.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return const _PullSessionResult(
        changesApplied: 0,
        lastSeq: '0',
        errorMessage: 'Failed while pulling remote changes.',
        isRetrying: true,
      );
    }
  }

  /// Opens the sync metadata box used for last sequence and profile metadata.
  Future<Box<dynamic>> _openSyncMetaBox() async {
    if (_hive.isBoxOpen(_syncMetaBoxName)) {
      return _hive.box<dynamic>(_syncMetaBoxName);
    }

    return _hive.openBox<dynamic>(_syncMetaBoxName);
  }

  /// Publishes a new sync state to listeners.
  void _emitState(SyncState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }
}

/// Summarizes the outcome of one push session.
class _PushSessionResult {
  /// Creates a push session result.
  const _PushSessionResult({
    required this.syncedCount,
    required this.retryCount,
    required this.errorMessage,
    required this.isRetrying,
  });

  /// Number of outbox items confirmed synced.
  final int syncedCount;

  /// Most recent retry count applied to failed items.
  final int retryCount;

  /// Terminal error message for the push session, if any.
  final String? errorMessage;

  /// Whether the push failure should be retried automatically.
  final bool isRetrying;
}

/// Summarizes the outcome of one pull session.
class _PullSessionResult {
  /// Creates a pull session result.
  const _PullSessionResult({
    required this.changesApplied,
    required this.lastSeq,
    required this.errorMessage,
    required this.isRetrying,
  });

  /// Number of remote changes applied locally.
  final int changesApplied;

  /// Latest replicated server sequence.
  final String lastSeq;

  /// Terminal error message for the pull session, if any.
  final String? errorMessage;

  /// Whether the pull failure should be retried automatically.
  final bool isRetrying;
}

/// Debug helper that exposes manual sync controls during development.
///
/// This helper depends on [SyncEngineImpl] and is only instantiated when
/// `kDebugMode` is true. It does not affect production ordering guarantees.
class SyncEngineTest {
  /// Creates debug-only sync controls.
  SyncEngineTest._(this._syncEngine) : assert(kDebugMode);

  final SyncEngineImpl _syncEngine;

  /// Triggers a manual sync from debugging tools.
  Future<void> triggerManualSync() => _syncEngine.triggerSync();

  /// Forces the engine into an offline state for UI testing.
  Future<void> simulateOffline() async {
    await _syncEngine.stop();
  }
}
