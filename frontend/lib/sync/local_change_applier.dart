// lib/sync/local_change_applier.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

/// Applies server-provided changes into local Hive document boxes.
///
/// This component depends on Hive for local persistence. It preserves server
/// ordering by applying the incoming list sequentially and intentionally skips
/// documents authored by the current user to avoid UI flicker over pending
/// local edits that have not finished syncing yet.
abstract class LocalChangeApplier {
  /// Applies a list of remote changes to local storage.
  Future<void> apply(List<Map<String, dynamic>> changes);
}

/// Hive-backed implementation of [LocalChangeApplier].
@LazySingleton(as: LocalChangeApplier)
class LocalChangeApplierImpl implements LocalChangeApplier {
  /// Creates a local change applier.
  LocalChangeApplierImpl(this._hive);

  final HiveInterface _hive;
  static const String _logName = 'SevakAI.SyncEngine';
  static const String _syncMetaBoxName = 'sync_meta';

  @override
  Future<void> apply(List<Map<String, dynamic>> changes) async {
    try {
      final Box<dynamic> syncMetaBox = await _openMetaBox();
      final String currentUserId =
          (syncMetaBox.get('current_user_id') as String?) ?? '';

      for (final Map<String, dynamic> change in changes) {
        final Map<String, dynamic>? document = _extractDocument(change);

        if (document == null) {
          log(
            'Skipping change without a valid document payload.',
            name: _logName,
          );
          continue;
        }

        final String updatedBy = (document['updated_by'] as String?) ?? '';
        if (currentUserId.isNotEmpty && updatedBy == currentUserId) {
          continue;
        }

        final String? type = document['type'] as String?;
        final String? documentId = document['_id'] as String?;

        if (type == null || documentId == null) {
          log(
            'Skipping change missing document type or _id.',
            name: _logName,
          );
          continue;
        }

        final String? boxName = _boxNameForType(type);
        if (boxName == null) {
          log(
            'Unknown document type received during pull: $type',
            name: _logName,
          );
          continue;
        }

        final Box<Map> targetBox = await _openDocumentBox(boxName);
        final bool isDeleted =
            (change['deleted'] as bool?) == true ||
            (document['deleted'] as bool?) == true ||
            (document['_deleted'] as bool?) == true;

        if (isDeleted) {
          await targetBox.delete(documentId);
          continue;
        }

        await targetBox.put(documentId, Map<String, dynamic>.from(document));
      }
    } catch (error, stackTrace) {
      log(
        'Failed to apply pulled changes.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the shared sync metadata box.
  Future<Box<dynamic>> _openMetaBox() async {
    if (_hive.isBoxOpen(_syncMetaBoxName)) {
      return _hive.box<dynamic>(_syncMetaBoxName);
    }

    return _hive.openBox<dynamic>(_syncMetaBoxName);
  }

  /// Opens a Hive box used for raw document maps.
  Future<Box<Map>> _openDocumentBox(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      return _hive.box<Map>(boxName);
    }

    return _hive.openBox<Map>(boxName);
  }

  /// Extracts the document payload from a raw change record.
  Map<String, dynamic>? _extractDocument(Map<String, dynamic> change) {
    final Object? doc = change['doc'];
    if (doc is Map<String, dynamic>) {
      return doc;
    }

    if (doc is Map) {
      return Map<String, dynamic>.from(doc);
    }

    return change;
  }

  /// Maps server document types to local Hive box names.
  String? _boxNameForType(String type) {
    switch (type) {
      case 'need':
        return 'needs_box';
      case 'volunteer':
        return 'volunteers_box';
      case 'incident':
        return 'incidents_box';
      case 'alert':
        return 'alerts_box';
      default:
        return null;
    }
  }
}
