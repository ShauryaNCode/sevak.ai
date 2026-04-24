// lib/services/connectivity_service.dart
import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Connectivity state used by the sync engine and UI surfaces.
enum ConnectivityStatus {
  /// Internet reachability has been verified recently.
  online,

  /// No usable internet connectivity is available.
  offline,

  /// Connectivity has not been determined yet.
  unknown,
}

/// Observes network reachability for sync-safe online/offline decisions.
///
/// This service depends on `connectivity_plus` for interface changes and on a
/// lightweight Dio probe to confirm actual internet reachability. New stream
/// subscribers always receive the most recent known status before future
/// updates, which is critical for predictable sync engine startup behavior.
abstract class ConnectivityService {
  /// Stream of connectivity status updates.
  Stream<ConnectivityStatus> get statusStream;

  /// Most recent known connectivity status.
  ConnectivityStatus get currentStatus;

  /// Checks connectivity immediately, including an internet probe when needed.
  Future<ConnectivityStatus> checkNow();

  /// Releases internal connectivity subscriptions and controllers.
  Future<void> dispose();
}

/// Connectivity service implementation backed by `connectivity_plus`.
@LazySingleton(as: ConnectivityService)
class ConnectivityServiceImpl implements ConnectivityService {
  /// Creates the connectivity service and starts observing the device network.
  ConnectivityServiceImpl(this._connectivity)
      : _probeClient = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 3),
            sendTimeout: const Duration(seconds: 3),
          ),
        ) {
    unawaited(_initialize());
  }

  final Connectivity _connectivity;
  final Dio _probeClient;
  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  ConnectivityStatus _lastStatus = ConnectivityStatus.unknown;
  DateTime? _lastProbeAt;
  ConnectivityStatus? _lastProbeResult;

  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Stream<ConnectivityStatus> get statusStream =>
      Stream<ConnectivityStatus>.multi(
        (MultiStreamController<ConnectivityStatus> controller) {
          controller.add(_lastStatus);
          final StreamSubscription<ConnectivityStatus> subscription =
              _controller.stream.listen(
            controller.add,
            onError: controller.addError,
          );
          controller.onCancel = subscription.cancel;
        },
        isBroadcast: true,
      );

  @override
  ConnectivityStatus get currentStatus => _lastStatus;

  @override
  Future<ConnectivityStatus> checkNow() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      final ConnectivityStatus status = await _resolveStatus(result);
      _emitStatus(status);
      return status;
    } catch (error, stackTrace) {
      log(
        'Failed to perform connectivity check.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      _emitStatus(ConnectivityStatus.offline);
      return ConnectivityStatus.offline;
    }
  }

  /// Disposes internal stream subscriptions and controllers.
  @override
  @disposeMethod
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _controller.close();
    _probeClient.close(force: true);
  }

  /// Initializes immediate status lookup and connectivity subscriptions.
  Future<void> _initialize() async {
    await checkNow();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        unawaited(_handleConnectivityChanged(result));
      },
      onError: (Object error, StackTrace stackTrace) {
        log(
          'Connectivity status stream failed.',
          name: _logName,
          error: error,
          stackTrace: stackTrace,
        );
        _emitStatus(ConnectivityStatus.offline);
      },
    );
  }

  /// Resolves and emits a connectivity update from the plugin stream.
  Future<void> _handleConnectivityChanged(ConnectivityResult result) async {
    final ConnectivityStatus status = await _resolveStatus(result);
    _emitStatus(status);
  }

  /// Resolves plugin connectivity results into a verified connectivity status.
  Future<ConnectivityStatus> _resolveStatus(
    ConnectivityResult result,
  ) async {
    if (result == ConnectivityResult.none) {
      return ConnectivityStatus.offline;
    }

    final DateTime now = DateTime.now().toUtc();
    if (_lastProbeAt != null &&
        _lastProbeResult != null &&
        now.difference(_lastProbeAt!) < const Duration(seconds: 30)) {
      return _lastProbeResult!;
    }

    try {
      final Response<void> response = await _probeClient.get<void>(
        'https://dns.google/resolve?name=google.com',
      );
      final ConnectivityStatus status =
          response.statusCode == 200 ? ConnectivityStatus.online : ConnectivityStatus.offline;
      _lastProbeAt = now;
      _lastProbeResult = status;
      return status;
    } on DioException catch (error, stackTrace) {
      log(
        'Connectivity probe failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      _lastProbeAt = now;
      _lastProbeResult = ConnectivityStatus.offline;
      return ConnectivityStatus.offline;
    }
  }

  /// Emits a new status to listeners only when the value changes.
  void _emitStatus(ConnectivityStatus status) {
    if (_lastStatus == status) {
      return;
    }

    _lastStatus = status;
    if (!_controller.isClosed) {
      _controller.add(status);
    }
  }
}
