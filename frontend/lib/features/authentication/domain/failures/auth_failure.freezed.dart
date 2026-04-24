// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthFailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(
          AuthFailure value, $Res Function(AuthFailure) then) =
      _$AuthFailureCopyWithImpl<$Res, AuthFailure>;
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res, $Val extends AuthFailure>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InvalidPhoneImplCopyWith<$Res> {
  factory _$$InvalidPhoneImplCopyWith(
          _$InvalidPhoneImpl value, $Res Function(_$InvalidPhoneImpl) then) =
      __$$InvalidPhoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidPhoneImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$InvalidPhoneImpl>
    implements _$$InvalidPhoneImplCopyWith<$Res> {
  __$$InvalidPhoneImplCopyWithImpl(
      _$InvalidPhoneImpl _value, $Res Function(_$InvalidPhoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InvalidPhoneImpl implements InvalidPhone {
  const _$InvalidPhoneImpl();

  @override
  String toString() {
    return 'AuthFailure.invalidPhone()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidPhoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return invalidPhone();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return invalidPhone?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (invalidPhone != null) {
      return invalidPhone();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return invalidPhone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return invalidPhone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (invalidPhone != null) {
      return invalidPhone(this);
    }
    return orElse();
  }
}

abstract class InvalidPhone implements AuthFailure {
  const factory InvalidPhone() = _$InvalidPhoneImpl;
}

/// @nodoc
abstract class _$$RateLimitedImplCopyWith<$Res> {
  factory _$$RateLimitedImplCopyWith(
          _$RateLimitedImpl value, $Res Function(_$RateLimitedImpl) then) =
      __$$RateLimitedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int retryAfterSeconds});
}

/// @nodoc
class __$$RateLimitedImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$RateLimitedImpl>
    implements _$$RateLimitedImplCopyWith<$Res> {
  __$$RateLimitedImplCopyWithImpl(
      _$RateLimitedImpl _value, $Res Function(_$RateLimitedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retryAfterSeconds = null,
  }) {
    return _then(_$RateLimitedImpl(
      retryAfterSeconds: null == retryAfterSeconds
          ? _value.retryAfterSeconds
          : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$RateLimitedImpl implements RateLimited {
  const _$RateLimitedImpl({required this.retryAfterSeconds});

  @override
  final int retryAfterSeconds;

  @override
  String toString() {
    return 'AuthFailure.rateLimited(retryAfterSeconds: $retryAfterSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RateLimitedImpl &&
            (identical(other.retryAfterSeconds, retryAfterSeconds) ||
                other.retryAfterSeconds == retryAfterSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, retryAfterSeconds);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RateLimitedImplCopyWith<_$RateLimitedImpl> get copyWith =>
      __$$RateLimitedImplCopyWithImpl<_$RateLimitedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return rateLimited(retryAfterSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return rateLimited?.call(retryAfterSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (rateLimited != null) {
      return rateLimited(retryAfterSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return rateLimited(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return rateLimited?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (rateLimited != null) {
      return rateLimited(this);
    }
    return orElse();
  }
}

abstract class RateLimited implements AuthFailure {
  const factory RateLimited({required final int retryAfterSeconds}) =
      _$RateLimitedImpl;

  int get retryAfterSeconds;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RateLimitedImplCopyWith<_$RateLimitedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SmsSendFailedImplCopyWith<$Res> {
  factory _$$SmsSendFailedImplCopyWith(
          _$SmsSendFailedImpl value, $Res Function(_$SmsSendFailedImpl) then) =
      __$$SmsSendFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SmsSendFailedImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$SmsSendFailedImpl>
    implements _$$SmsSendFailedImplCopyWith<$Res> {
  __$$SmsSendFailedImplCopyWithImpl(
      _$SmsSendFailedImpl _value, $Res Function(_$SmsSendFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SmsSendFailedImpl implements SmsSendFailed {
  const _$SmsSendFailedImpl();

  @override
  String toString() {
    return 'AuthFailure.smsSendFailed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SmsSendFailedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return smsSendFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return smsSendFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (smsSendFailed != null) {
      return smsSendFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return smsSendFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return smsSendFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (smsSendFailed != null) {
      return smsSendFailed(this);
    }
    return orElse();
  }
}

abstract class SmsSendFailed implements AuthFailure {
  const factory SmsSendFailed() = _$SmsSendFailedImpl;
}

/// @nodoc
abstract class _$$InvalidOtpImplCopyWith<$Res> {
  factory _$$InvalidOtpImplCopyWith(
          _$InvalidOtpImpl value, $Res Function(_$InvalidOtpImpl) then) =
      __$$InvalidOtpImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidOtpImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$InvalidOtpImpl>
    implements _$$InvalidOtpImplCopyWith<$Res> {
  __$$InvalidOtpImplCopyWithImpl(
      _$InvalidOtpImpl _value, $Res Function(_$InvalidOtpImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InvalidOtpImpl implements InvalidOtp {
  const _$InvalidOtpImpl();

  @override
  String toString() {
    return 'AuthFailure.invalidOtp()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidOtpImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return invalidOtp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return invalidOtp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (invalidOtp != null) {
      return invalidOtp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return invalidOtp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return invalidOtp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (invalidOtp != null) {
      return invalidOtp(this);
    }
    return orElse();
  }
}

abstract class InvalidOtp implements AuthFailure {
  const factory InvalidOtp() = _$InvalidOtpImpl;
}

/// @nodoc
abstract class _$$OtpExpiredImplCopyWith<$Res> {
  factory _$$OtpExpiredImplCopyWith(
          _$OtpExpiredImpl value, $Res Function(_$OtpExpiredImpl) then) =
      __$$OtpExpiredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OtpExpiredImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$OtpExpiredImpl>
    implements _$$OtpExpiredImplCopyWith<$Res> {
  __$$OtpExpiredImplCopyWithImpl(
      _$OtpExpiredImpl _value, $Res Function(_$OtpExpiredImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OtpExpiredImpl implements OtpExpired {
  const _$OtpExpiredImpl();

  @override
  String toString() {
    return 'AuthFailure.otpExpired()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OtpExpiredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return otpExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return otpExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (otpExpired != null) {
      return otpExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return otpExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return otpExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (otpExpired != null) {
      return otpExpired(this);
    }
    return orElse();
  }
}

abstract class OtpExpired implements AuthFailure {
  const factory OtpExpired() = _$OtpExpiredImpl;
}

/// @nodoc
abstract class _$$TooManyAttemptsImplCopyWith<$Res> {
  factory _$$TooManyAttemptsImplCopyWith(_$TooManyAttemptsImpl value,
          $Res Function(_$TooManyAttemptsImpl) then) =
      __$$TooManyAttemptsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TooManyAttemptsImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$TooManyAttemptsImpl>
    implements _$$TooManyAttemptsImplCopyWith<$Res> {
  __$$TooManyAttemptsImplCopyWithImpl(
      _$TooManyAttemptsImpl _value, $Res Function(_$TooManyAttemptsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TooManyAttemptsImpl implements TooManyAttempts {
  const _$TooManyAttemptsImpl();

  @override
  String toString() {
    return 'AuthFailure.tooManyAttempts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TooManyAttemptsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return tooManyAttempts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return tooManyAttempts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyAttempts != null) {
      return tooManyAttempts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return tooManyAttempts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return tooManyAttempts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyAttempts != null) {
      return tooManyAttempts(this);
    }
    return orElse();
  }
}

abstract class TooManyAttempts implements AuthFailure {
  const factory TooManyAttempts() = _$TooManyAttemptsImpl;
}

/// @nodoc
abstract class _$$TokenRefreshFailedImplCopyWith<$Res> {
  factory _$$TokenRefreshFailedImplCopyWith(_$TokenRefreshFailedImpl value,
          $Res Function(_$TokenRefreshFailedImpl) then) =
      __$$TokenRefreshFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TokenRefreshFailedImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$TokenRefreshFailedImpl>
    implements _$$TokenRefreshFailedImplCopyWith<$Res> {
  __$$TokenRefreshFailedImplCopyWithImpl(_$TokenRefreshFailedImpl _value,
      $Res Function(_$TokenRefreshFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TokenRefreshFailedImpl implements TokenRefreshFailed {
  const _$TokenRefreshFailedImpl();

  @override
  String toString() {
    return 'AuthFailure.tokenRefreshFailed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TokenRefreshFailedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return tokenRefreshFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return tokenRefreshFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (tokenRefreshFailed != null) {
      return tokenRefreshFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return tokenRefreshFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return tokenRefreshFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (tokenRefreshFailed != null) {
      return tokenRefreshFailed(this);
    }
    return orElse();
  }
}

abstract class TokenRefreshFailed implements AuthFailure {
  const factory TokenRefreshFailed() = _$TokenRefreshFailedImpl;
}

/// @nodoc
abstract class _$$SessionExpiredImplCopyWith<$Res> {
  factory _$$SessionExpiredImplCopyWith(_$SessionExpiredImpl value,
          $Res Function(_$SessionExpiredImpl) then) =
      __$$SessionExpiredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionExpiredImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$SessionExpiredImpl>
    implements _$$SessionExpiredImplCopyWith<$Res> {
  __$$SessionExpiredImplCopyWithImpl(
      _$SessionExpiredImpl _value, $Res Function(_$SessionExpiredImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SessionExpiredImpl implements SessionExpired {
  const _$SessionExpiredImpl();

  @override
  String toString() {
    return 'AuthFailure.sessionExpired()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SessionExpiredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return sessionExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return sessionExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (sessionExpired != null) {
      return sessionExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return sessionExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return sessionExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (sessionExpired != null) {
      return sessionExpired(this);
    }
    return orElse();
  }
}

abstract class SessionExpired implements AuthFailure {
  const factory SessionExpired() = _$SessionExpiredImpl;
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkErrorImpl implements NetworkError {
  const _$NetworkErrorImpl();

  @override
  String toString() {
    return 'AuthFailure.networkError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class NetworkError implements AuthFailure {
  const factory NetworkError() = _$NetworkErrorImpl;
}

/// @nodoc
abstract class _$$ServerErrorImplCopyWith<$Res> {
  factory _$$ServerErrorImplCopyWith(
          _$ServerErrorImpl value, $Res Function(_$ServerErrorImpl) then) =
      __$$ServerErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int statusCode});
}

/// @nodoc
class __$$ServerErrorImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$ServerErrorImpl>
    implements _$$ServerErrorImplCopyWith<$Res> {
  __$$ServerErrorImplCopyWithImpl(
      _$ServerErrorImpl _value, $Res Function(_$ServerErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
  }) {
    return _then(_$ServerErrorImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ServerErrorImpl implements ServerError {
  const _$ServerErrorImpl({required this.statusCode});

  @override
  final int statusCode;

  @override
  String toString() {
    return 'AuthFailure.serverError(statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerErrorImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerErrorImplCopyWith<_$ServerErrorImpl> get copyWith =>
      __$$ServerErrorImplCopyWithImpl<_$ServerErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return serverError(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return serverError?.call(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerError implements AuthFailure {
  const factory ServerError({required final int statusCode}) =
      _$ServerErrorImpl;

  int get statusCode;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerErrorImplCopyWith<_$ServerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnknownFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'AuthFailure.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidPhone,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() smsSendFailed,
    required TResult Function() invalidOtp,
    required TResult Function() otpExpired,
    required TResult Function() tooManyAttempts,
    required TResult Function() tokenRefreshFailed,
    required TResult Function() sessionExpired,
    required TResult Function() networkError,
    required TResult Function(int statusCode) serverError,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidPhone,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? smsSendFailed,
    TResult? Function()? invalidOtp,
    TResult? Function()? otpExpired,
    TResult? Function()? tooManyAttempts,
    TResult? Function()? tokenRefreshFailed,
    TResult? Function()? sessionExpired,
    TResult? Function()? networkError,
    TResult? Function(int statusCode)? serverError,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidPhone,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? smsSendFailed,
    TResult Function()? invalidOtp,
    TResult Function()? otpExpired,
    TResult Function()? tooManyAttempts,
    TResult Function()? tokenRefreshFailed,
    TResult Function()? sessionExpired,
    TResult Function()? networkError,
    TResult Function(int statusCode)? serverError,
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
    required TResult Function(InvalidPhone value) invalidPhone,
    required TResult Function(RateLimited value) rateLimited,
    required TResult Function(SmsSendFailed value) smsSendFailed,
    required TResult Function(InvalidOtp value) invalidOtp,
    required TResult Function(OtpExpired value) otpExpired,
    required TResult Function(TooManyAttempts value) tooManyAttempts,
    required TResult Function(TokenRefreshFailed value) tokenRefreshFailed,
    required TResult Function(SessionExpired value) sessionExpired,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(ServerError value) serverError,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidPhone value)? invalidPhone,
    TResult? Function(RateLimited value)? rateLimited,
    TResult? Function(SmsSendFailed value)? smsSendFailed,
    TResult? Function(InvalidOtp value)? invalidOtp,
    TResult? Function(OtpExpired value)? otpExpired,
    TResult? Function(TooManyAttempts value)? tooManyAttempts,
    TResult? Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult? Function(SessionExpired value)? sessionExpired,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(ServerError value)? serverError,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidPhone value)? invalidPhone,
    TResult Function(RateLimited value)? rateLimited,
    TResult Function(SmsSendFailed value)? smsSendFailed,
    TResult Function(InvalidOtp value)? invalidOtp,
    TResult Function(OtpExpired value)? otpExpired,
    TResult Function(TooManyAttempts value)? tooManyAttempts,
    TResult Function(TokenRefreshFailed value)? tokenRefreshFailed,
    TResult Function(SessionExpired value)? sessionExpired,
    TResult Function(NetworkError value)? networkError,
    TResult Function(ServerError value)? serverError,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements AuthFailure {
  const factory UnknownFailure({required final String message}) =
      _$UnknownFailureImpl;

  String get message;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
