// lib/sync/models/outbox_item.dart
import 'dart:math';

import 'package:hive/hive.dart';

part 'outbox_item.g.dart';

// HIVE TYPE ID REGISTRY — DO NOT CHANGE EXISTING IDs
// 0: OutboxItem
// 1: (reserved for NeedDocument)
// 2: (reserved for VolunteerDocument)
// 3: (reserved for IncidentDocument)

/// Represents one locally persisted mutation waiting to be pushed to the server.
///
/// This model depends on Hive for durable storage and preserves FIFO ordering by
/// retaining creation timestamps. Retries are tracked on the item itself so the
/// sync engine can make delay decisions without consulting external state.
@HiveType(typeId: 0)
class OutboxItem extends HiveObject {
  static const Object _noValue = Object();

  /// Creates a persisted outbox mutation.
  OutboxItem({
    required this.id,
    required this.documentId,
    required this.documentType,
    required this.operationType,
    required this.payload,
    required this.zoneId,
    required this.createdAt,
    required this.retryCount,
    required this.lastAttemptAt,
    required this.errorMessage,
    required this.isDeadLetter,
  });

  /// Creates a new outbox item with an auto-generated ULID key.
  factory OutboxItem.create({
    required String documentId,
    required String documentType,
    required String operationType,
    required String payload,
    required String zoneId,
    DateTime? createdAt,
  }) {
    return OutboxItem(
      id: _UlidGenerator.generate(),
      documentId: documentId,
      documentType: documentType,
      operationType: operationType,
      payload: payload,
      zoneId: zoneId,
      createdAt: createdAt ?? DateTime.now().toUtc(),
      retryCount: 0,
      lastAttemptAt: null,
      errorMessage: null,
      isDeadLetter: false,
    );
  }

  /// Unique ULID for this queued mutation and the Hive storage key.
  @HiveField(0)
  final String id;

  /// Couch-style document identifier for the affected record.
  @HiveField(1)
  final String documentId;

  /// Domain document type such as `need` or `volunteer`.
  @HiveField(2)
  final String documentType;

  /// Mutation type: `CREATE`, `UPDATE`, or `DELETE`.
  @HiveField(3)
  final String operationType;

  /// JSON-encoded document payload sent to the sync API.
  @HiveField(4)
  final String payload;

  /// Disaster zone identifier used to scope replication.
  @HiveField(5)
  final String zoneId;

  /// Creation time for FIFO ordering.
  @HiveField(6)
  final DateTime createdAt;

  /// Number of failed sync attempts recorded for this item.
  @HiveField(7)
  final int retryCount;

  /// Timestamp of the most recent sync attempt, if any.
  @HiveField(8)
  final DateTime? lastAttemptAt;

  /// Most recent sync error description for debugging and triage.
  @HiveField(9)
  final String? errorMessage;

  /// Marks the item as permanently failed and excluded from retries.
  @HiveField(10)
  final bool isDeadLetter;

  /// Returns a copy of this item with retry metadata incremented.
  OutboxItem copyWithRetry(String? error) {
    return copyWith(
      retryCount: retryCount + 1,
      lastAttemptAt: DateTime.now().toUtc(),
      errorMessage: error,
    );
  }

  /// Returns whether this item is still eligible for automatic retries.
  bool get isRetryable => !isDeadLetter && retryCount < 5;

  /// Returns the delay before the next retry should be attempted.
  Duration get nextRetryDelay {
    switch (retryCount) {
      case 0:
        return const Duration(seconds: 5);
      case 1:
        return const Duration(seconds: 15);
      case 2:
        return const Duration(minutes: 1);
      case 3:
        return const Duration(minutes: 5);
      default:
        return const Duration(minutes: 30);
    }
  }

  /// Creates a general-purpose copy with selected fields replaced.
  OutboxItem copyWith({
    String? id,
    String? documentId,
    String? documentType,
    String? operationType,
    String? payload,
    String? zoneId,
    DateTime? createdAt,
    int? retryCount,
    Object? lastAttemptAt = _noValue,
    Object? errorMessage = _noValue,
    bool? isDeadLetter,
  }) {
    return OutboxItem(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      documentType: documentType ?? this.documentType,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      zoneId: zoneId ?? this.zoneId,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: identical(lastAttemptAt, _noValue)
          ? this.lastAttemptAt
          : lastAttemptAt as DateTime?,
      errorMessage: identical(errorMessage, _noValue)
          ? this.errorMessage
          : errorMessage as String?,
      isDeadLetter: isDeadLetter ?? this.isDeadLetter,
    );
  }
}

/// Generates monotonic ULID-like identifiers suitable for offline queue keys.
///
/// The generator depends only on `DateTime` and secure randomness so it remains
/// usable without platform services. Ordering is preserved lexicographically by
/// encoding the timestamp prefix first.
abstract final class _UlidGenerator {
  static const String _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  static final Random _random = Random.secure();

  /// Generates a new ULID string.
  static String generate() {
    final int timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final StringBuffer buffer = StringBuffer();

    _appendEncoded(buffer, timestamp, length: 10);

    for (int index = 0; index < 16; index++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }

    return buffer.toString();
  }

  /// Encodes an integer into fixed-length Crockford Base32.
  static void _appendEncoded(
    StringBuffer buffer,
    int value, {
    required int length,
  }) {
    int remaining = value;
    final List<String> chars = List<String>.filled(length, _alphabet[0]);

    for (int index = length - 1; index >= 0; index--) {
      chars[index] = _alphabet[remaining & 31];
      remaining = remaining >> 5;
    }

    buffer.writeAll(chars);
  }
}
