// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i317;
import '../../features/authentication/data/sources/auth_local_source.dart'
    as _i262;
import '../../features/authentication/data/sources/auth_remote_source.dart'
    as _i634;
import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/domain/use_cases/request_otp_use_case.dart'
    as _i283;
import '../../features/authentication/domain/use_cases/verify_otp_use_case.dart'
    as _i121;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../services/connectivity_service.dart' as _i365;
import '../../sync/local_change_applier.dart' as _i831;
import '../../sync/outbox_repository.dart' as _i56;
import '../../sync/replication_client.dart' as _i456;
import '../../sync/sync_bloc.dart' as _i1065;
import '../../sync/sync_engine.dart' as _i813;
import '../config/app_config.dart' as _i650;
import '../config/app_router.dart' as _i753;
import 'interceptors/auth_interceptor.dart' as _i748;
import 'interceptors/retry_interceptor.dart' as _i936;
import 'modules/config_module.dart' as _i810;
import 'modules/network_module.dart' as _i851;
import 'modules/platform_module.dart' as _i807;
import 'modules/router_module.dart' as _i322;
import 'modules/storage_module.dart' as _i148;

const String _dev = 'dev';
const String _staging = 'staging';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final platformModule = _$PlatformModule();
    final storageModule = _$StorageModule();
    final configModule = _$ConfigModule();
    final networkModule = _$NetworkModule();
    final routerModule = _$RouterModule();
    gh.lazySingleton<_i748.AuthInterceptor>(
        () => const _i748.AuthInterceptor());
    gh.lazySingleton<_i936.RetryInterceptor>(
        () => const _i936.RetryInterceptor());
    gh.lazySingleton<_i895.Connectivity>(() => platformModule.connectivity);
    gh.lazySingleton<_i979.HiveInterface>(() => storageModule.hive);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => storageModule.secureStorage);
    gh.lazySingleton<_i650.AppConfig>(
      () => configModule.devConfig,
      registerFor: {_dev},
    );
    gh.lazySingleton<_i650.AppConfig>(
      () => configModule.stagingConfig,
      registerFor: {_staging},
    );
    gh.lazySingleton<_i262.AuthLocalSource>(
      () => _i262.AuthLocalSourceImpl(gh<_i558.FlutterSecureStorage>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i365.ConnectivityService>(
      () => _i365.ConnectivityServiceImpl(gh<_i895.Connectivity>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i650.AppConfig>(
      () => configModule.productionConfig,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i831.LocalChangeApplier>(
        () => _i831.LocalChangeApplierImpl(gh<_i979.HiveInterface>()));
    gh.lazySingleton<_i56.OutboxRepository>(
        () => _i56.OutboxRepositoryImpl(gh<_i979.HiveInterface>()));
    gh.lazySingleton<_i361.LogInterceptor>(
      () => networkModule.logInterceptor(),
      registerFor: {
        _dev,
        _staging,
      },
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.productionDio(
        gh<_i650.AppConfig>(),
        gh<_i748.AuthInterceptor>(),
        gh<_i936.RetryInterceptor>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i634.AuthRemoteSource>(
        () => _i634.AuthRemoteSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i456.ReplicationClient>(() => _i456.ReplicationClientImpl(
          gh<_i361.Dio>(),
          gh<_i650.AppConfig>(),
        ));
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.nonProductionDio(
        gh<_i650.AppConfig>(),
        gh<_i748.AuthInterceptor>(),
        gh<_i936.RetryInterceptor>(),
        gh<_i361.LogInterceptor>(),
      ),
      registerFor: {
        _dev,
        _staging,
      },
    );
    gh.lazySingleton<_i742.AuthRepository>(() => _i317.AuthRepositoryImpl(
          gh<_i634.AuthRemoteSource>(),
          gh<_i262.AuthLocalSource>(),
        ));
    gh.lazySingleton<_i665.DashboardRepository>(
        () => _i509.DashboardRepositoryImpl(
              gh<_i361.Dio>(),
              gh<_i650.AppConfig>(),
            ));
    gh.factory<_i652.DashboardBloc>(
        () => _i652.DashboardBloc(gh<_i665.DashboardRepository>()));
    gh.factory<_i283.RequestOtpUseCase>(
        () => _i283.RequestOtpUseCase(gh<_i742.AuthRepository>()));
    gh.factory<_i121.VerifyOtpUseCase>(
        () => _i121.VerifyOtpUseCase(gh<_i742.AuthRepository>()));
    gh.lazySingleton<_i813.SyncEngine>(
      () => _i813.SyncEngineImpl(
        gh<_i56.OutboxRepository>(),
        gh<_i456.ReplicationClient>(),
        gh<_i365.ConnectivityService>(),
        gh<_i831.LocalChangeApplier>(),
        gh<_i650.AppConfig>(),
        gh<_i979.HiveInterface>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i180.AuthBloc>(() => _i180.AuthBloc(
          gh<_i283.RequestOtpUseCase>(),
          gh<_i121.VerifyOtpUseCase>(),
          gh<_i742.AuthRepository>(),
        ));
    gh.lazySingleton<_i753.AppRouter>(
        () => _i753.AppRouter(gh<_i180.AuthBloc>()));
    gh.lazySingleton<_i583.GoRouter>(
        () => routerModule.router(gh<_i753.AppRouter>()));
    gh.factory<_i1065.SyncBloc>(() => _i1065.SyncBloc(gh<_i813.SyncEngine>()));
    return this;
  }
}

class _$PlatformModule extends _i807.PlatformModule {}

class _$StorageModule extends _i148.StorageModule {}

class _$ConfigModule extends _i810.ConfigModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$RouterModule extends _i322.RouterModule {}
