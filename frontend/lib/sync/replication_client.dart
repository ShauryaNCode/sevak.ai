// lib/sync/replication_client.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../core/config/app_config.dart';
import 'models/outbox_item.dart';

part 'replication_client.freezed.dart';

/// Communicates with the backend sync API for pushing and pulling changes.
///
/// This client depends on Dio and [AppConfig]. It preserves batch ordering by
/// sending queued mutations in the same order received from the sync engine and
/// translates transport errors into structured retryable or terminal failures.
abstract class ReplicationClient {
  /// Pushes a batch of local outbox items to the backend.
  Future<SyncPushResult> push(List<OutboxItem> items);

  /// Pulls remote changes since the provided sequence for a specific zone.
  Future<SyncPullResult> pull({
    required String since,
    required String zoneId,
  });
}

/// Structured result of a push request to the sync API.
@freezed
class SyncPushResult with _$SyncPushResult {
  /// Push completed with per-item success/error details.
  const factory SyncPushResult.success({
    required List<String> syncedIds,
    required List<SyncPushItemError> errors,
    required String serverSeq,
  }) = SyncPushSuccess;

  /// Push failed as a whole.
  const factory SyncPushResult.failure({
    required String message,
    required bool isRetryable,
  }) = SyncPushFailure;
}

/// Per-document push failure returned by the sync API.
@freezed
class SyncPushItemError with _$SyncPushItemError {
  /// Describes a terminal per-item push error.
  const factory SyncPushItemError({
    required String documentId,
    required int statusCode,
    required String reason,
  }) = _SyncPushItemError;
}

/// Structured result of a pull request to the sync API.
@freezed
class SyncPullResult with _$SyncPullResult {
  /// Pull completed successfully.
  const factory SyncPullResult.success({
    required List<Map<String, dynamic>> changes,
    required String lastSeq,
    required bool hasMore,
  }) = SyncPullSuccess;

  /// Pull failed as a whole.
  const factory SyncPullResult.failure({
    required String message,
    required bool isRetryable,
  }) = SyncPullFailure;
}

/// Dio-backed implementation of [ReplicationClient].
@LazySingleton(as: ReplicationClient)
class ReplicationClientImpl implements ReplicationClient {
  /// Creates a replication client.
  ReplicationClientImpl(this._dio, this._config)
      : _clientId = 'sevakai-${_config.environment}-client';

  final Dio _dio;
  final AppConfig _config;
  final String _clientId;
  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Future<SyncPushResult> push(List<OutboxItem> items) async {
    if (items.isEmpty) {
      return const SyncPushResult.success(
        syncedIds: <String>[],
        errors: <SyncPushItemError>[],
        serverSeq: '0',
      );
    }

    try {
      final List<Map<String, dynamic>> documents = items
          .map((OutboxItem item) => _decodePayload(item.payload))
          .toList();

      if (kDebugMode) {
        log(
          'POST ${_config.apiBaseUrl}/sync/push with ${documents.length} documents.',
          name: _logName,
        );
      }

      final Response<Map<String, dynamic>> response =
          await _dio.post<Map<String, dynamic>>(
        '/sync/push',
        data: <String, Object>{
          'documents': documents,
          'client_id': _clientId,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final Map<String, dynamic> body = response.data ?? <String, dynamic>{};
      final List<String> syncedIds =
          _parseStringList(body['synced_ids'] ?? body['syncedIds']);
      final List<SyncPushItemError> errors = _parsePushErrors(body['errors']);
      final String serverSeq =
          (body['server_seq'] ?? body['serverSeq'] ?? '0').toString();

      return SyncPushResult.success(
        syncedIds: syncedIds,
        errors: errors,
        serverSeq: serverSeq,
      );
    } on DioException catch (error, stackTrace) {
      log(
        'Push request failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return _mapPushFailure(error);
    } catch (error, stackTrace) {
      log(
        'Push request failed during payload preparation.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return const SyncPushResult.failure(
        message: 'Failed to prepare push payload.',
        isRetryable: false,
      );
    }
  }

  @override
  Future<SyncPullResult> pull({
    required String since,
    required String zoneId,
  }) async {
    try {
      if (kDebugMode) {
        log(
          'GET ${_config.apiBaseUrl}/sync/changes?since=$since&zone_id=$zoneId&limit=200',
          name: _logName,
        );
      }

      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '/sync/changes',
        queryParameters: <String, Object>{
          'since': since,
          'zone_id': zoneId,
          'limit': 200,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final Map<String, dynamic> body = response.data ?? <String, dynamic>{};
      final List<Map<String, dynamic>> changes =
          _parseChanges(body['changes'] ?? body['results']);
      final String lastSeq =
          (body['last_seq'] ?? body['lastSeq'] ?? since).toString();
      final bool hasMore =
          (body['has_more'] as bool?) ?? (body['hasMore'] as bool?) ?? false;

      return SyncPullResult.success(
        changes: changes,
        lastSeq: lastSeq,
        hasMore: hasMore,
      );
    } on DioException catch (error, stackTrace) {
      log(
        'Pull request failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return _mapPullFailure(error);
    }
  }

  /// Decodes a JSON outbox payload into a syncable document map.
  Map<String, dynamic> _decodePayload(String payload) {
    final Object? decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw const FormatException('Outbox payload must decode to a JSON object.');
  }

  /// Parses per-item push errors returned by the server.
  List<SyncPushItemError> _parsePushErrors(Object? rawErrors) {
    if (rawErrors is! List) {
      return <SyncPushItemError>[];
    }

    return rawErrors
        .whereType<Map>()
        .map(
          (Map rawError) => SyncPushItemError(
            documentId:
                (rawError['document_id'] ?? rawError['documentId'] ?? '')
                    .toString(),
            statusCode: int.tryParse(
                  (rawError['status_code'] ?? rawError['statusCode'] ?? 0)
                      .toString(),
                ) ??
                0,
            reason: (rawError['reason'] ?? 'Unknown push error').toString(),
          ),
        )
        .toList();
  }

  /// Parses a string list from a raw API response field.
  List<String> _parseStringList(Object? value) {
    if (value is! List) {
      return <String>[];
    }

    return value.map((Object? item) => item.toString()).toList();
  }

  /// Parses pulled change documents into typed map entries.
  List<Map<String, dynamic>> _parseChanges(Object? rawChanges) {
    if (rawChanges is! List) {
      return <Map<String, dynamic>>[];
    }

    return rawChanges
        .whereType<Map>()
        .map((Map rawChange) => Map<String, dynamic>.from(rawChange))
        .toList();
  }

  /// Maps a Dio exception into a structured push failure.
  SyncPushFailure _mapPushFailure(DioException error) {
    final int? statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return SyncPushFailure(
        message: 'Push rejected by server with status $statusCode.',
        isRetryable: false,
      );
    }

    return const SyncPushFailure(
      message: 'Push failed due to server or network conditions.',
      isRetryable: true,
    );
  }

  /// Maps a Dio exception into a structured pull failure.
  SyncPullFailure _mapPullFailure(DioException error) {
    final int? statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return SyncPullFailure(
        message: 'Pull rejected by server with status $statusCode.',
        isRetryable: false,
      );
    }

    return const SyncPullFailure(
      message: 'Pull failed due to server or network conditions.',
      isRetryable: true,
    );
  }
}
