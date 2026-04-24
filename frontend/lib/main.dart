// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/localization/app_localizations.dart';
import 'sync/models/outbox_item.dart';
import 'ui/themes/app_theme.dart';

/// Bootstraps the development application flavor.
Future<void> mainDev() async {
  await _runApp(_resolveRuntimeConfig(AppConfig.dev));
}

/// Bootstraps the staging application flavor.
Future<void> mainStaging() async {
  await _runApp(AppConfig.staging);
}

/// Bootstraps the production application flavor.
Future<void> mainProduction() async {
  await _runApp(AppConfig.production);
}

/// Default entry point that starts the development flavor.
Future<void> main() async {
  await mainDev();
}

Future<void> _runApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init Hive
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(OutboxItemAdapter());
  }

  // 2. Configure DI with environment
  await getIt.reset();
  await configureDependencies(config.environment);
  if (getIt.isRegistered<AppConfig>()) {
    await getIt.unregister<AppConfig>();
  }
  getIt.registerSingleton<AppConfig>(config);

  // 3. Set up FlutterError.onError for production crash reporting (TODO: Sentry)
  if (config.environment == kEnvProd) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      // TODO: Forward production framework errors to Sentry or an equivalent
      // crash-reporting backend once the observability stack is available.
    };
  }

  // 4. runApp(SevakAIApp(config: config))
  runApp(SevakAIApp(config: config));
}

/// Applies runtime overrides for local development endpoints.
AppConfig _resolveRuntimeConfig(AppConfig config) {
  if (config.environment != kEnvDev) {
    return config;
  }

  const String devApiBaseUrl = String.fromEnvironment('DEV_API_BASE_URL');
  const String devCouchDbUrl = String.fromEnvironment('DEV_COUCHDB_URL');

  return config.copyWith(
    apiBaseUrl: devApiBaseUrl.isEmpty ? null : devApiBaseUrl,
    couchDbUrl: devCouchDbUrl.isEmpty ? null : devCouchDbUrl,
  );
}

/// Root SevakAI application widget.
class SevakAIApp extends StatelessWidget {
  /// Creates the root application widget.
  const SevakAIApp({
    required this.config,
    super.key,
  });

  /// Runtime environment configuration used by the app.
  final AppConfig config;

  /// Supported locales for the initial app shell.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
    Locale('te'),
    Locale('bn'),
    Locale('mr'),
  ];

  @override
  Widget build(BuildContext context) {
    final GoRouter router = getIt<GoRouter>();

    return MaterialApp.router(
      title: 'SevakAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      supportedLocales: supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationsDelegate(),
      ],
    );
  }
}
