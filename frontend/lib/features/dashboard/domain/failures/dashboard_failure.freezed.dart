// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function(int statusCode) server,
    required TResult Function(String message) stream,
    required TResult Function(String message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function(int statusCode)? server,
    TResult? Function(String message)? stream,
    TResult? Function(String message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function(int statusCode)? server,
    TResult Function(String message)? stream,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardNetworkFailure value) network,
    required TResult Function(DashboardServerFailure value) server,
    required TResult Function(DashboardStreamFailure value) stream,
    required TResult Function(DashboardUnknownFailure value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardNetworkFailure value)? network,
    TResult? Function(DashboardServerFailure value)? server,
    TResult? Function(DashboardStreamFailure value)? stream,
    TResult? Function(DashboardUnknownFailure value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardNetworkFailure value)? network,
    TResult Function(DashboardServerFailure value)? server,
    TResult Function(DashboardStreamFailure value)? stream,
    TResult Function(DashboardUnknownFailure value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardFailureCopyWith<$Res> {
  factory $DashboardFailureCopyWith(
          DashboardFailure value, $Res Function(DashboardFailure) then) =
      _$DashboardFailureCopyWithImpl<$Res, DashboardFailure>;
}

/// @nodoc
class _$DashboardFailureCopyWithImpl<$Res, $Val extends DashboardFailure>
    implements $DashboardFailureCopyWith<$Res> {
  _$DashboardFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DashboardNetworkFailureImplCopyWith<$Res> {
  factory _$$DashboardNetworkFailureImplCopyWith(
          _$DashboardNetworkFailureImpl value,
          $Res Function(_$DashboardNetworkFailureImpl) then) =
      __$$DashboardNetworkFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardNetworkFailureImplCopyWithImpl<$Res>
    extends _$DashboardFailureCopyWithImpl<$Res, _$DashboardNetworkFailureImpl>
    implements _$$DashboardNetworkFailureImplCopyWith<$Res> {
  __$$DashboardNetworkFailureImplCopyWithImpl(
      _$DashboardNetworkFailureImpl _value,
      $Res Function(_$DashboardNetworkFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardNetworkFailureImpl implements DashboardNetworkFailure {
  const _$DashboardNetworkFailureImpl();

  @override
  String toString() {
    return 'DashboardFailure.network()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardNetworkFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function(int statusCode) server,
    required TResult Function(String message) stream,
    required TResult Function(String message) unknown,
  }) {
    return network();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function(int statusCode)? server,
    TResult? Function(String message)? stream,
    TResult? Function(String message)? unknown,
  }) {
    return network?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function(int statusCode)? server,
    TResult Function(String message)? stream,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardNetworkFailure value) network,
    required TResult Function(DashboardServerFailure value) server,
    required TResult Function(DashboardStreamFailure value) stream,
    required TResult Function(DashboardUnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardNetworkFailure value)? network,
    TResult? Function(DashboardServerFailure value)? server,
    TResult? Function(DashboardStreamFailure value)? stream,
    TResult? Function(DashboardUnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardNetworkFailure value)? network,
    TResult Function(DashboardServerFailure value)? server,
    TResult Function(DashboardStreamFailure value)? stream,
    TResult Function(DashboardUnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class DashboardNetworkFailure implements DashboardFailure {
  const factory DashboardNetworkFailure() = _$DashboardNetworkFailureImpl;
}

/// @nodoc
abstract class _$$DashboardServerFailureImplCopyWith<$Res> {
  factory _$$DashboardServerFailureImplCopyWith(
          _$DashboardServerFailureImpl value,
          $Res Function(_$DashboardServerFailureImpl) then) =
      __$$DashboardServerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int statusCode});
}

/// @nodoc
class __$$DashboardServerFailureImplCopyWithImpl<$Res>
    extends _$DashboardFailureCopyWithImpl<$Res, _$DashboardServerFailureImpl>
    implements _$$DashboardServerFailureImplCopyWith<$Res> {
  __$$DashboardServerFailureImplCopyWithImpl(
      _$DashboardServerFailureImpl _value,
      $Res Function(_$DashboardServerFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
  }) {
    return _then(_$DashboardServerFailureImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DashboardServerFailureImpl implements DashboardServerFailure {
  const _$DashboardServerFailureImpl({required this.statusCode});

  @override
  final int statusCode;

  @override
  String toString() {
    return 'DashboardFailure.server(statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardServerFailureImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardServerFailureImplCopyWith<_$DashboardServerFailureImpl>
      get copyWith => __$$DashboardServerFailureImplCopyWithImpl<
          _$DashboardServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function(int statusCode) server,
    required TResult Function(String message) stream,
    required TResult Function(String message) unknown,
  }) {
    return server(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function(int statusCode)? server,
    TResult? Function(String message)? stream,
    TResult? Function(String message)? unknown,
  }) {
    return server?.call(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function(int statusCode)? server,
    TResult Function(String message)? stream,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardNetworkFailure value) network,
    required TResult Function(DashboardServerFailure value) server,
    required TResult Function(DashboardStreamFailure value) stream,
    required TResult Function(DashboardUnknownFailure value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardNetworkFailure value)? network,
    TResult? Function(DashboardServerFailure value)? server,
    TResult? Function(DashboardStreamFailure value)? stream,
    TResult? Function(DashboardUnknownFailure value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardNetworkFailure value)? network,
    TResult Function(DashboardServerFailure value)? server,
    TResult Function(DashboardStreamFailure value)? stream,
    TResult Function(DashboardUnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class DashboardServerFailure implements DashboardFailure {
  const factory DashboardServerFailure({required final int statusCode}) =
      _$DashboardServerFailureImpl;

  int get statusCode;

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardServerFailureImplCopyWith<_$DashboardServerFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardStreamFailureImplCopyWith<$Res> {
  factory _$$DashboardStreamFailureImplCopyWith(
          _$DashboardStreamFailureImpl value,
          $Res Function(_$DashboardStreamFailureImpl) then) =
      __$$DashboardStreamFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DashboardStreamFailureImplCopyWithImpl<$Res>
    extends _$DashboardFailureCopyWithImpl<$Res, _$DashboardStreamFailureImpl>
    implements _$$DashboardStreamFailureImplCopyWith<$Res> {
  __$$DashboardStreamFailureImplCopyWithImpl(
      _$DashboardStreamFailureImpl _value,
      $Res Function(_$DashboardStreamFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DashboardStreamFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DashboardStreamFailureImpl implements DashboardStreamFailure {
  const _$DashboardStreamFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DashboardFailure.stream(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStreamFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStreamFailureImplCopyWith<_$DashboardStreamFailureImpl>
      get copyWith => __$$DashboardStreamFailureImplCopyWithImpl<
          _$DashboardStreamFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function(int statusCode) server,
    required TResult Function(String message) stream,
    required TResult Function(String message) unknown,
  }) {
    return stream(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function(int statusCode)? server,
    TResult? Function(String message)? stream,
    TResult? Function(String message)? unknown,
  }) {
    return stream?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function(int statusCode)? server,
    TResult Function(String message)? stream,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (stream != null) {
      return stream(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardNetworkFailure value) network,
    required TResult Function(DashboardServerFailure value) server,
    required TResult Function(DashboardStreamFailure value) stream,
    required TResult Function(DashboardUnknownFailure value) unknown,
  }) {
    return stream(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardNetworkFailure value)? network,
    TResult? Function(DashboardServerFailure value)? server,
    TResult? Function(DashboardStreamFailure value)? stream,
    TResult? Function(DashboardUnknownFailure value)? unknown,
  }) {
    return stream?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardNetworkFailure value)? network,
    TResult Function(DashboardServerFailure value)? server,
    TResult Function(DashboardStreamFailure value)? stream,
    TResult Function(DashboardUnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (stream != null) {
      return stream(this);
    }
    return orElse();
  }
}

abstract class DashboardStreamFailure implements DashboardFailure {
  const factory DashboardStreamFailure({required final String message}) =
      _$DashboardStreamFailureImpl;

  String get message;

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStreamFailureImplCopyWith<_$DashboardStreamFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardUnknownFailureImplCopyWith<$Res> {
  factory _$$DashboardUnknownFailureImplCopyWith(
          _$DashboardUnknownFailureImpl value,
          $Res Function(_$DashboardUnknownFailureImpl) then) =
      __$$DashboardUnknownFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DashboardUnknownFailureImplCopyWithImpl<$Res>
    extends _$DashboardFailureCopyWithImpl<$Res, _$DashboardUnknownFailureImpl>
    implements _$$DashboardUnknownFailureImplCopyWith<$Res> {
  __$$DashboardUnknownFailureImplCopyWithImpl(
      _$DashboardUnknownFailureImpl _value,
      $Res Function(_$DashboardUnknownFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DashboardUnknownFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DashboardUnknownFailureImpl implements DashboardUnknownFailure {
  const _$DashboardUnknownFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DashboardFailure.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardUnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardUnknownFailureImplCopyWith<_$DashboardUnknownFailureImpl>
      get copyWith => __$$DashboardUnknownFailureImplCopyWithImpl<
          _$DashboardUnknownFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function(int statusCode) server,
    required TResult Function(String message) stream,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function(int statusCode)? server,
    TResult? Function(String message)? stream,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function(int statusCode)? server,
    TResult Function(String message)? stream,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardNetworkFailure value) network,
    required TResult Function(DashboardServerFailure value) server,
    required TResult Function(DashboardStreamFailure value) stream,
    required TResult Function(DashboardUnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardNetworkFailure value)? network,
    TResult? Function(DashboardServerFailure value)? server,
    TResult? Function(DashboardStreamFailure value)? stream,
    TResult? Function(DashboardUnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardNetworkFailure value)? network,
    TResult Function(DashboardServerFailure value)? server,
    TResult Function(DashboardStreamFailure value)? stream,
    TResult Function(DashboardUnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class DashboardUnknownFailure implements DashboardFailure {
  const factory DashboardUnknownFailure({required final String message}) =
      _$DashboardUnknownFailureImpl;

  String get message;

  /// Create a copy of DashboardFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardUnknownFailureImplCopyWith<_$DashboardUnknownFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}
