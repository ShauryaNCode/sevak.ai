// lib/sync/sync_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'models/sync_state.dart';
import 'sync_engine.dart';

part 'sync_bloc.freezed.dart';

/// UI-facing BLoC wrapper around the background sync engine.
///
/// This BLoC depends on [SyncEngine] and preserves the engine's event ordering
/// by forwarding engine state updates into the BLoC state stream as they are
/// received. It ensures the engine listener is cancelled when the BLoC closes.
@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  /// Creates a sync BLoC bound to the shared sync engine.
  SyncBloc(this._syncEngine) : super(_syncEngine.currentState) {
    on<SyncStarted>(_onStarted);
    on<SyncManualSyncRequested>(_onManualSyncRequested);
    on<SyncStopped>(_onStopped);
    on<_SyncStateChanged>(_onStateChanged);
  }

  final SyncEngine _syncEngine;
  StreamSubscription<SyncState>? _syncSubscription;

  Future<void> _onStarted(
    SyncStarted event,
    Emitter<SyncState> emit,
  ) async {
    await _syncSubscription?.cancel();
    _syncSubscription = _syncEngine.stateStream.listen(
      (SyncState state) {
        if (!isClosed) {
          add(SyncEvent.stateChanged(state));
        }
      },
    );

    await _syncEngine.start();
    emit(_syncEngine.currentState);
  }

  Future<void> _onManualSyncRequested(
    SyncManualSyncRequested event,
    Emitter<SyncState> emit,
  ) async {
    await _syncEngine.triggerSync();
  }

  Future<void> _onStopped(
    SyncStopped event,
    Emitter<SyncState> emit,
  ) async {
    await _syncEngine.stop();
    emit(_syncEngine.currentState);
  }

  void _onStateChanged(
    _SyncStateChanged event,
    Emitter<SyncState> emit,
  ) {
    emit(event.state);
  }

  @override
  Future<void> close() async {
    await _syncSubscription?.cancel();
    return super.close();
  }
}

/// Events accepted by [SyncBloc].
@freezed
class SyncEvent with _$SyncEvent {
  /// Starts the sync engine and begins streaming sync state.
  const factory SyncEvent.started() = SyncStarted;

  /// Triggers a manual sync attempt.
  const factory SyncEvent.manualSyncRequested() = SyncManualSyncRequested;

  /// Stops background sync work and detaches listeners.
  const factory SyncEvent.stopped() = SyncStopped;

  /// Internal event used to forward engine state updates into the BLoC.
  const factory SyncEvent.stateChanged(SyncState state) = _SyncStateChanged;
}
