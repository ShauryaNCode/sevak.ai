// lib/sync/outbox_repository.dart
import 'dart:async';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'models/outbox_item.dart';

/// Persists pending local mutations for later synchronization.
///
/// This repository depends on Hive and guarantees FIFO retrieval by sorting on
/// `createdAt`. Read operations never throw to callers; failures are logged and
/// surfaced as empty values so field workflows are not interrupted by storage
/// exceptions.
abstract class OutboxRepository {
  /// Adds a new outbox item to durable storage.
  Future<void> enqueue(OutboxItem item);

  /// Returns all non-dead-letter items ordered by creation time ascending.
  Future<List<OutboxItem>> getPending();

  /// Returns all dead-letter items.
  Future<List<OutboxItem>> getDeadLetters();

  /// Removes an outbox item after a successful sync.
  Future<void> remove(String id);

  /// Updates an existing outbox item.
  Future<void> update(OutboxItem item);

  /// Marks an outbox item as permanently failed with a reason.
  Future<void> markAsDeadLetter(String id, String reason);

  /// Watches the current non-dead-letter pending count for badges and UI.
  Stream<int> watchPendingCount();

  /// Returns the current non-dead-letter pending count.
  Future<int> getPendingCount();

  /// Clears the entire outbox. Intended for development and tests only.
  Future<void> clearAll();
}

/// Hive-backed implementation of [OutboxRepository].
@LazySingleton(as: OutboxRepository)
class OutboxRepositoryImpl implements OutboxRepository {
  /// Creates an outbox repository.
  OutboxRepositoryImpl(this._hive);

  final HiveInterface _hive;
  static const String _boxName = 'outbox';
  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Future<void> enqueue(OutboxItem item) async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      await box?.put(item.id, item);
    } catch (error, stackTrace) {
      log(
        'Failed to enqueue outbox item ${item.id}.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<OutboxItem>> getPending() async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      if (box == null) {
        return <OutboxItem>[];
      }

      final List<OutboxItem> items = box.values
          .where((OutboxItem item) => !item.isDeadLetter)
          .toList()
        ..sort(
          (OutboxItem left, OutboxItem right) =>
              left.createdAt.compareTo(right.createdAt),
        );
      return items;
    } catch (error, stackTrace) {
      log(
        'Failed to read pending outbox items.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return <OutboxItem>[];
    }
  }

  @override
  Future<List<OutboxItem>> getDeadLetters() async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      if (box == null) {
        return <OutboxItem>[];
      }

      return box.values
          .where((OutboxItem item) => item.isDeadLetter)
          .toList()
        ..sort(
          (OutboxItem left, OutboxItem right) =>
              left.createdAt.compareTo(right.createdAt),
        );
    } catch (error, stackTrace) {
      log(
        'Failed to read dead-letter outbox items.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return <OutboxItem>[];
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      await box?.delete(id);
    } catch (error, stackTrace) {
      log(
        'Failed to remove outbox item $id.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> update(OutboxItem item) async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      await box?.put(item.id, item);
    } catch (error, stackTrace) {
      log(
        'Failed to update outbox item ${item.id}.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> markAsDeadLetter(String id, String reason) async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      final OutboxItem? existing = box?.get(id);
      if (box == null || existing == null) {
        return;
      }

      await box.put(
        id,
        existing.copyWith(
          isDeadLetter: true,
          errorMessage: reason,
          lastAttemptAt: DateTime.now().toUtc(),
        ),
      );
    } catch (error, stackTrace) {
      log(
        'Failed to dead-letter outbox item $id.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<int> watchPendingCount() {
    late final StreamController<int> controller;
    StreamSubscription<BoxEvent>? subscription;

    controller = StreamController<int>.broadcast(
      onListen: () async {
        try {
          final Box<OutboxItem>? box = await _openBox();
          if (box == null) {
            controller.add(0);
            return;
          }

          controller.add(_countPending(box));
          subscription = box.watch().listen(
            (_) => controller.add(_countPending(box)),
            onError: (Object error, StackTrace stackTrace) {
              log(
                'Failed while watching outbox count.',
                name: _logName,
                error: error,
                stackTrace: stackTrace,
              );
              controller.add(0);
            },
          );
        } catch (error, stackTrace) {
          log(
            'Failed to initialize outbox watch stream.',
            name: _logName,
            error: error,
            stackTrace: stackTrace,
          );
          controller.add(0);
        }
      },
      onCancel: () async {
        await subscription?.cancel();
      },
    );

    return controller.stream;
  }

  @override
  Future<int> getPendingCount() async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      if (box == null) {
        return 0;
      }

      return _countPending(box);
    } catch (error, stackTrace) {
      log(
        'Failed to read outbox pending count.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final Box<OutboxItem>? box = await _openBox();
      await box?.clear();
    } catch (error, stackTrace) {
      log(
        'Failed to clear outbox.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the outbox box, creating it if necessary.
  Future<Box<OutboxItem>?> _openBox() async {
    try {
      if (_hive.isBoxOpen(_boxName)) {
        return _hive.box<OutboxItem>(_boxName);
      }

      return _hive.openBox<OutboxItem>(_boxName);
    } catch (error, stackTrace) {
      log(
        'Failed to open the outbox Hive box.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Counts non-dead-letter items currently in the box.
  int _countPending(Box<OutboxItem> box) {
    return box.values.where((OutboxItem item) => !item.isDeadLetter).length;
  }
}
