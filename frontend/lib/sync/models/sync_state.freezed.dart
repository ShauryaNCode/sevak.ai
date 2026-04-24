// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncIdleImplCopyWith<$Res> {
  factory _$$SyncIdleImplCopyWith(
          _$SyncIdleImpl value, $Res Function(_$SyncIdleImpl) then) =
      __$$SyncIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncIdleImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncIdleImpl>
    implements _$$SyncIdleImplCopyWith<$Res> {
  __$$SyncIdleImplCopyWithImpl(
      _$SyncIdleImpl _value, $Res Function(_$SyncIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncIdleImpl implements SyncIdle {
  const _$SyncIdleImpl();

  @override
  String toString() {
    return 'SyncState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SyncIdle implements SyncState {
  const factory SyncIdle() = _$SyncIdleImpl;
}

/// @nodoc
abstract class _$$SyncInProgressImplCopyWith<$Res> {
  factory _$$SyncInProgressImplCopyWith(_$SyncInProgressImpl value,
          $Res Function(_$SyncInProgressImpl) then) =
      __$$SyncInProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int pendingCount, int processedCount});
}

/// @nodoc
class __$$SyncInProgressImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncInProgressImpl>
    implements _$$SyncInProgressImplCopyWith<$Res> {
  __$$SyncInProgressImplCopyWithImpl(
      _$SyncInProgressImpl _value, $Res Function(_$SyncInProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingCount = null,
    Object? processedCount = null,
  }) {
    return _then(_$SyncInProgressImpl(
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      processedCount: null == processedCount
          ? _value.processedCount
          : processedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SyncInProgressImpl implements SyncInProgress {
  const _$SyncInProgressImpl(
      {required this.pendingCount, required this.processedCount});

  @override
  final int pendingCount;
  @override
  final int processedCount;

  @override
  String toString() {
    return 'SyncState.syncing(pendingCount: $pendingCount, processedCount: $processedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncInProgressImpl &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.processedCount, processedCount) ||
                other.processedCount == processedCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pendingCount, processedCount);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncInProgressImplCopyWith<_$SyncInProgressImpl> get copyWith =>
      __$$SyncInProgressImplCopyWithImpl<_$SyncInProgressImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return syncing(pendingCount, processedCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return syncing?.call(pendingCount, processedCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(pendingCount, processedCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class SyncInProgress implements SyncState {
  const factory SyncInProgress(
      {required final int pendingCount,
      required final int processedCount}) = _$SyncInProgressImpl;

  int get pendingCount;
  int get processedCount;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncInProgressImplCopyWith<_$SyncInProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncPushSuccessImplCopyWith<$Res> {
  factory _$$SyncPushSuccessImplCopyWith(_$SyncPushSuccessImpl value,
          $Res Function(_$SyncPushSuccessImpl) then) =
      __$$SyncPushSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int syncedCount, DateTime syncedAt});
}

/// @nodoc
class __$$SyncPushSuccessImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncPushSuccessImpl>
    implements _$$SyncPushSuccessImplCopyWith<$Res> {
  __$$SyncPushSuccessImplCopyWithImpl(
      _$SyncPushSuccessImpl _value, $Res Function(_$SyncPushSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncedCount = null,
    Object? syncedAt = null,
  }) {
    return _then(_$SyncPushSuccessImpl(
      syncedCount: null == syncedCount
          ? _value.syncedCount
          : syncedCount // ignore: cast_nullable_to_non_nullable
              as int,
      syncedAt: null == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SyncPushSuccessImpl implements SyncPushSuccess {
  const _$SyncPushSuccessImpl(
      {required this.syncedCount, required this.syncedAt});

  @override
  final int syncedCount;
  @override
  final DateTime syncedAt;

  @override
  String toString() {
    return 'SyncState.pushSuccess(syncedCount: $syncedCount, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPushSuccessImpl &&
            (identical(other.syncedCount, syncedCount) ||
                other.syncedCount == syncedCount) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, syncedCount, syncedAt);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPushSuccessImplCopyWith<_$SyncPushSuccessImpl> get copyWith =>
      __$$SyncPushSuccessImplCopyWithImpl<_$SyncPushSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return pushSuccess(syncedCount, syncedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return pushSuccess?.call(syncedCount, syncedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (pushSuccess != null) {
      return pushSuccess(syncedCount, syncedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return pushSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return pushSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (pushSuccess != null) {
      return pushSuccess(this);
    }
    return orElse();
  }
}

abstract class SyncPushSuccess implements SyncState {
  const factory SyncPushSuccess(
      {required final int syncedCount,
      required final DateTime syncedAt}) = _$SyncPushSuccessImpl;

  int get syncedCount;
  DateTime get syncedAt;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPushSuccessImplCopyWith<_$SyncPushSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncPullSuccessImplCopyWith<$Res> {
  factory _$$SyncPullSuccessImplCopyWith(_$SyncPullSuccessImpl value,
          $Res Function(_$SyncPullSuccessImpl) then) =
      __$$SyncPullSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int changesApplied, String lastSeq, DateTime syncedAt});
}

/// @nodoc
class __$$SyncPullSuccessImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncPullSuccessImpl>
    implements _$$SyncPullSuccessImplCopyWith<$Res> {
  __$$SyncPullSuccessImplCopyWithImpl(
      _$SyncPullSuccessImpl _value, $Res Function(_$SyncPullSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changesApplied = null,
    Object? lastSeq = null,
    Object? syncedAt = null,
  }) {
    return _then(_$SyncPullSuccessImpl(
      changesApplied: null == changesApplied
          ? _value.changesApplied
          : changesApplied // ignore: cast_nullable_to_non_nullable
              as int,
      lastSeq: null == lastSeq
          ? _value.lastSeq
          : lastSeq // ignore: cast_nullable_to_non_nullable
              as String,
      syncedAt: null == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SyncPullSuccessImpl implements SyncPullSuccess {
  const _$SyncPullSuccessImpl(
      {required this.changesApplied,
      required this.lastSeq,
      required this.syncedAt});

  @override
  final int changesApplied;
  @override
  final String lastSeq;
  @override
  final DateTime syncedAt;

  @override
  String toString() {
    return 'SyncState.pullSuccess(changesApplied: $changesApplied, lastSeq: $lastSeq, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPullSuccessImpl &&
            (identical(other.changesApplied, changesApplied) ||
                other.changesApplied == changesApplied) &&
            (identical(other.lastSeq, lastSeq) || other.lastSeq == lastSeq) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, changesApplied, lastSeq, syncedAt);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPullSuccessImplCopyWith<_$SyncPullSuccessImpl> get copyWith =>
      __$$SyncPullSuccessImplCopyWithImpl<_$SyncPullSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return pullSuccess(changesApplied, lastSeq, syncedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return pullSuccess?.call(changesApplied, lastSeq, syncedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (pullSuccess != null) {
      return pullSuccess(changesApplied, lastSeq, syncedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return pullSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return pullSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (pullSuccess != null) {
      return pullSuccess(this);
    }
    return orElse();
  }
}

abstract class SyncPullSuccess implements SyncState {
  const factory SyncPullSuccess(
      {required final int changesApplied,
      required final String lastSeq,
      required final DateTime syncedAt}) = _$SyncPullSuccessImpl;

  int get changesApplied;
  String get lastSeq;
  DateTime get syncedAt;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPullSuccessImplCopyWith<_$SyncPullSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncErrorImplCopyWith<$Res> {
  factory _$$SyncErrorImplCopyWith(
          _$SyncErrorImpl value, $Res Function(_$SyncErrorImpl) then) =
      __$$SyncErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isRetrying, int retryCount});
}

/// @nodoc
class __$$SyncErrorImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncErrorImpl>
    implements _$$SyncErrorImplCopyWith<$Res> {
  __$$SyncErrorImplCopyWithImpl(
      _$SyncErrorImpl _value, $Res Function(_$SyncErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isRetrying = null,
    Object? retryCount = null,
  }) {
    return _then(_$SyncErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRetrying: null == isRetrying
          ? _value.isRetrying
          : isRetrying // ignore: cast_nullable_to_non_nullable
              as bool,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SyncErrorImpl implements SyncError {
  const _$SyncErrorImpl(
      {required this.message,
      required this.isRetrying,
      required this.retryCount});

  @override
  final String message;
  @override
  final bool isRetrying;
  @override
  final int retryCount;

  @override
  String toString() {
    return 'SyncState.error(message: $message, isRetrying: $isRetrying, retryCount: $retryCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRetrying, isRetrying) ||
                other.isRetrying == isRetrying) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRetrying, retryCount);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncErrorImplCopyWith<_$SyncErrorImpl> get copyWith =>
      __$$SyncErrorImplCopyWithImpl<_$SyncErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return error(message, isRetrying, retryCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return error?.call(message, isRetrying, retryCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, isRetrying, retryCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SyncError implements SyncState {
  const factory SyncError(
      {required final String message,
      required final bool isRetrying,
      required final int retryCount}) = _$SyncErrorImpl;

  String get message;
  bool get isRetrying;
  int get retryCount;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncErrorImplCopyWith<_$SyncErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncOfflineImplCopyWith<$Res> {
  factory _$$SyncOfflineImplCopyWith(
          _$SyncOfflineImpl value, $Res Function(_$SyncOfflineImpl) then) =
      __$$SyncOfflineImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncOfflineImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncOfflineImpl>
    implements _$$SyncOfflineImplCopyWith<$Res> {
  __$$SyncOfflineImplCopyWithImpl(
      _$SyncOfflineImpl _value, $Res Function(_$SyncOfflineImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncOfflineImpl implements SyncOffline {
  const _$SyncOfflineImpl();

  @override
  String toString() {
    return 'SyncState.offline()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncOfflineImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(int pendingCount, int processedCount) syncing,
    required TResult Function(int syncedCount, DateTime syncedAt) pushSuccess,
    required TResult Function(
            int changesApplied, String lastSeq, DateTime syncedAt)
        pullSuccess,
    required TResult Function(String message, bool isRetrying, int retryCount)
        error,
    required TResult Function() offline,
  }) {
    return offline();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(int pendingCount, int processedCount)? syncing,
    TResult? Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult? Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult? Function(String message, bool isRetrying, int retryCount)? error,
    TResult? Function()? offline,
  }) {
    return offline?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(int pendingCount, int processedCount)? syncing,
    TResult Function(int syncedCount, DateTime syncedAt)? pushSuccess,
    TResult Function(int changesApplied, String lastSeq, DateTime syncedAt)?
        pullSuccess,
    TResult Function(String message, bool isRetrying, int retryCount)? error,
    TResult Function()? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncInProgress value) syncing,
    required TResult Function(SyncPushSuccess value) pushSuccess,
    required TResult Function(SyncPullSuccess value) pullSuccess,
    required TResult Function(SyncError value) error,
    required TResult Function(SyncOffline value) offline,
  }) {
    return offline(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncInProgress value)? syncing,
    TResult? Function(SyncPushSuccess value)? pushSuccess,
    TResult? Function(SyncPullSuccess value)? pullSuccess,
    TResult? Function(SyncError value)? error,
    TResult? Function(SyncOffline value)? offline,
  }) {
    return offline?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncInProgress value)? syncing,
    TResult Function(SyncPushSuccess value)? pushSuccess,
    TResult Function(SyncPullSuccess value)? pullSuccess,
    TResult Function(SyncError value)? error,
    TResult Function(SyncOffline value)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(this);
    }
    return orElse();
  }
}

abstract class SyncOffline implements SyncState {
  const factory SyncOffline() = _$SyncOfflineImpl;
}
