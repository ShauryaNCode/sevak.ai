// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() manualSyncRequested,
    required TResult Function() stopped,
    required TResult Function(SyncState state) stateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? manualSyncRequested,
    TResult? Function()? stopped,
    TResult? Function(SyncState state)? stateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? manualSyncRequested,
    TResult Function()? stopped,
    TResult Function(SyncState state)? stateChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStarted value) started,
    required TResult Function(SyncManualSyncRequested value)
        manualSyncRequested,
    required TResult Function(SyncStopped value) stopped,
    required TResult Function(_SyncStateChanged value) stateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStarted value)? started,
    TResult? Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult? Function(SyncStopped value)? stopped,
    TResult? Function(_SyncStateChanged value)? stateChanged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStarted value)? started,
    TResult Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult Function(SyncStopped value)? stopped,
    TResult Function(_SyncStateChanged value)? stateChanged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncEventCopyWith<$Res> {
  factory $SyncEventCopyWith(SyncEvent value, $Res Function(SyncEvent) then) =
      _$SyncEventCopyWithImpl<$Res, SyncEvent>;
}

/// @nodoc
class _$SyncEventCopyWithImpl<$Res, $Val extends SyncEvent>
    implements $SyncEventCopyWith<$Res> {
  _$SyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncStartedImplCopyWith<$Res> {
  factory _$$SyncStartedImplCopyWith(
          _$SyncStartedImpl value, $Res Function(_$SyncStartedImpl) then) =
      __$$SyncStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStartedImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncStartedImpl>
    implements _$$SyncStartedImplCopyWith<$Res> {
  __$$SyncStartedImplCopyWithImpl(
      _$SyncStartedImpl _value, $Res Function(_$SyncStartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncStartedImpl implements SyncStarted {
  const _$SyncStartedImpl();

  @override
  String toString() {
    return 'SyncEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() manualSyncRequested,
    required TResult Function() stopped,
    required TResult Function(SyncState state) stateChanged,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? manualSyncRequested,
    TResult? Function()? stopped,
    TResult? Function(SyncState state)? stateChanged,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? manualSyncRequested,
    TResult Function()? stopped,
    TResult Function(SyncState state)? stateChanged,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStarted value) started,
    required TResult Function(SyncManualSyncRequested value)
        manualSyncRequested,
    required TResult Function(SyncStopped value) stopped,
    required TResult Function(_SyncStateChanged value) stateChanged,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStarted value)? started,
    TResult? Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult? Function(SyncStopped value)? stopped,
    TResult? Function(_SyncStateChanged value)? stateChanged,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStarted value)? started,
    TResult Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult Function(SyncStopped value)? stopped,
    TResult Function(_SyncStateChanged value)? stateChanged,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class SyncStarted implements SyncEvent {
  const factory SyncStarted() = _$SyncStartedImpl;
}

/// @nodoc
abstract class _$$SyncManualSyncRequestedImplCopyWith<$Res> {
  factory _$$SyncManualSyncRequestedImplCopyWith(
          _$SyncManualSyncRequestedImpl value,
          $Res Function(_$SyncManualSyncRequestedImpl) then) =
      __$$SyncManualSyncRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncManualSyncRequestedImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncManualSyncRequestedImpl>
    implements _$$SyncManualSyncRequestedImplCopyWith<$Res> {
  __$$SyncManualSyncRequestedImplCopyWithImpl(
      _$SyncManualSyncRequestedImpl _value,
      $Res Function(_$SyncManualSyncRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncManualSyncRequestedImpl implements SyncManualSyncRequested {
  const _$SyncManualSyncRequestedImpl();

  @override
  String toString() {
    return 'SyncEvent.manualSyncRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncManualSyncRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() manualSyncRequested,
    required TResult Function() stopped,
    required TResult Function(SyncState state) stateChanged,
  }) {
    return manualSyncRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? manualSyncRequested,
    TResult? Function()? stopped,
    TResult? Function(SyncState state)? stateChanged,
  }) {
    return manualSyncRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? manualSyncRequested,
    TResult Function()? stopped,
    TResult Function(SyncState state)? stateChanged,
    required TResult orElse(),
  }) {
    if (manualSyncRequested != null) {
      return manualSyncRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStarted value) started,
    required TResult Function(SyncManualSyncRequested value)
        manualSyncRequested,
    required TResult Function(SyncStopped value) stopped,
    required TResult Function(_SyncStateChanged value) stateChanged,
  }) {
    return manualSyncRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStarted value)? started,
    TResult? Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult? Function(SyncStopped value)? stopped,
    TResult? Function(_SyncStateChanged value)? stateChanged,
  }) {
    return manualSyncRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStarted value)? started,
    TResult Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult Function(SyncStopped value)? stopped,
    TResult Function(_SyncStateChanged value)? stateChanged,
    required TResult orElse(),
  }) {
    if (manualSyncRequested != null) {
      return manualSyncRequested(this);
    }
    return orElse();
  }
}

abstract class SyncManualSyncRequested implements SyncEvent {
  const factory SyncManualSyncRequested() = _$SyncManualSyncRequestedImpl;
}

/// @nodoc
abstract class _$$SyncStoppedImplCopyWith<$Res> {
  factory _$$SyncStoppedImplCopyWith(
          _$SyncStoppedImpl value, $Res Function(_$SyncStoppedImpl) then) =
      __$$SyncStoppedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStoppedImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncStoppedImpl>
    implements _$$SyncStoppedImplCopyWith<$Res> {
  __$$SyncStoppedImplCopyWithImpl(
      _$SyncStoppedImpl _value, $Res Function(_$SyncStoppedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncStoppedImpl implements SyncStopped {
  const _$SyncStoppedImpl();

  @override
  String toString() {
    return 'SyncEvent.stopped()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStoppedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() manualSyncRequested,
    required TResult Function() stopped,
    required TResult Function(SyncState state) stateChanged,
  }) {
    return stopped();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? manualSyncRequested,
    TResult? Function()? stopped,
    TResult? Function(SyncState state)? stateChanged,
  }) {
    return stopped?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? manualSyncRequested,
    TResult Function()? stopped,
    TResult Function(SyncState state)? stateChanged,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStarted value) started,
    required TResult Function(SyncManualSyncRequested value)
        manualSyncRequested,
    required TResult Function(SyncStopped value) stopped,
    required TResult Function(_SyncStateChanged value) stateChanged,
  }) {
    return stopped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStarted value)? started,
    TResult? Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult? Function(SyncStopped value)? stopped,
    TResult? Function(_SyncStateChanged value)? stateChanged,
  }) {
    return stopped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStarted value)? started,
    TResult Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult Function(SyncStopped value)? stopped,
    TResult Function(_SyncStateChanged value)? stateChanged,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(this);
    }
    return orElse();
  }
}

abstract class SyncStopped implements SyncEvent {
  const factory SyncStopped() = _$SyncStoppedImpl;
}

/// @nodoc
abstract class _$$SyncStateChangedImplCopyWith<$Res> {
  factory _$$SyncStateChangedImplCopyWith(_$SyncStateChangedImpl value,
          $Res Function(_$SyncStateChangedImpl) then) =
      __$$SyncStateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SyncState state});

  $SyncStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$SyncStateChangedImplCopyWithImpl<$Res>
    extends _$SyncEventCopyWithImpl<$Res, _$SyncStateChangedImpl>
    implements _$$SyncStateChangedImplCopyWith<$Res> {
  __$$SyncStateChangedImplCopyWithImpl(_$SyncStateChangedImpl _value,
      $Res Function(_$SyncStateChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$SyncStateChangedImpl(
      null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as SyncState,
    ));
  }

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SyncStateCopyWith<$Res> get state {
    return $SyncStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc

class _$SyncStateChangedImpl implements _SyncStateChanged {
  const _$SyncStateChangedImpl(this.state);

  @override
  final SyncState state;

  @override
  String toString() {
    return 'SyncEvent.stateChanged(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateChangedImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateChangedImplCopyWith<_$SyncStateChangedImpl> get copyWith =>
      __$$SyncStateChangedImplCopyWithImpl<_$SyncStateChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() manualSyncRequested,
    required TResult Function() stopped,
    required TResult Function(SyncState state) stateChanged,
  }) {
    return stateChanged(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? manualSyncRequested,
    TResult? Function()? stopped,
    TResult? Function(SyncState state)? stateChanged,
  }) {
    return stateChanged?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? manualSyncRequested,
    TResult Function()? stopped,
    TResult Function(SyncState state)? stateChanged,
    required TResult orElse(),
  }) {
    if (stateChanged != null) {
      return stateChanged(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncStarted value) started,
    required TResult Function(SyncManualSyncRequested value)
        manualSyncRequested,
    required TResult Function(SyncStopped value) stopped,
    required TResult Function(_SyncStateChanged value) stateChanged,
  }) {
    return stateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncStarted value)? started,
    TResult? Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult? Function(SyncStopped value)? stopped,
    TResult? Function(_SyncStateChanged value)? stateChanged,
  }) {
    return stateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncStarted value)? started,
    TResult Function(SyncManualSyncRequested value)? manualSyncRequested,
    TResult Function(SyncStopped value)? stopped,
    TResult Function(_SyncStateChanged value)? stateChanged,
    required TResult orElse(),
  }) {
    if (stateChanged != null) {
      return stateChanged(this);
    }
    return orElse();
  }
}

abstract class _SyncStateChanged implements SyncEvent {
  const factory _SyncStateChanged(final SyncState state) =
      _$SyncStateChangedImpl;

  SyncState get state;

  /// Create a copy of SyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateChangedImplCopyWith<_$SyncStateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
