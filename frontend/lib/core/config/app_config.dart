// lib/core/config/app_config.dart

/// Immutable environment-specific runtime configuration for SevakAI.
class AppConfig {
  /// Creates an application configuration instance.
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.couchDbUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.syncInterval,
    required this.maxSyncBatchSize,
  });

  /// Active environment identifier.
  final String environment;

  /// Base URL for REST API requests.
  final String apiBaseUrl;

  /// Base URL for CouchDB replication and sync operations.
  final String couchDbUrl;

  /// Enables verbose diagnostics and request logging.
  final bool enableLogging;

  /// Enables analytics collection for supported builds.
  final bool enableAnalytics;

  /// Interval between background synchronization attempts.
  final Duration syncInterval;

  /// Maximum number of records processed during a sync batch.
  final int maxSyncBatchSize;

  /// Returns a copy of this configuration with selected fields replaced.
  AppConfig copyWith({
    String? environment,
    String? apiBaseUrl,
    String? couchDbUrl,
    bool? enableLogging,
    bool? enableAnalytics,
    Duration? syncInterval,
    int? maxSyncBatchSize,
  }) {
    return AppConfig(
      environment: environment ?? this.environment,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      couchDbUrl: couchDbUrl ?? this.couchDbUrl,
      enableLogging: enableLogging ?? this.enableLogging,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      syncInterval: syncInterval ?? this.syncInterval,
      maxSyncBatchSize: maxSyncBatchSize ?? this.maxSyncBatchSize,
    );
  }

  /// Development configuration optimized for local iteration.
  static const AppConfig dev = AppConfig(
    environment: 'dev',
    apiBaseUrl: 'http://localhost:8000/api/v1',
    couchDbUrl: 'http://localhost:5984',
    enableLogging: true,
    enableAnalytics: false,
    syncInterval: Duration(seconds: 30),
    maxSyncBatchSize: 100,
  );

  /// Staging configuration for pre-production validation.
  static const AppConfig staging = AppConfig(
    environment: 'staging',
    apiBaseUrl: 'https://api.staging.sevakai.in/api/v1',
    couchDbUrl: 'https://couch.staging.sevakai.in',
    enableLogging: true,
    enableAnalytics: false,
    syncInterval: Duration(seconds: 15),
    maxSyncBatchSize: 250,
  );

  /// Production configuration for live disaster-response operations.
  static const AppConfig production = AppConfig(
    environment: 'prod',
    apiBaseUrl: 'https://api.sevakai.in/api/v1',
    couchDbUrl: 'https://couch.sevakai.in',
    enableLogging: false,
    enableAnalytics: true,
    syncInterval: Duration(seconds: 10),
    maxSyncBatchSize: 500,
  );
}
