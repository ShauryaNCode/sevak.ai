// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'replication_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncPushResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> syncedIds,
            List<SyncPushItemError> errors, String serverSeq)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPushSuccess value) success,
    required TResult Function(SyncPushFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPushSuccess value)? success,
    TResult? Function(SyncPushFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPushSuccess value)? success,
    TResult Function(SyncPushFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncPushResultCopyWith<$Res> {
  factory $SyncPushResultCopyWith(
          SyncPushResult value, $Res Function(SyncPushResult) then) =
      _$SyncPushResultCopyWithImpl<$Res, SyncPushResult>;
}

/// @nodoc
class _$SyncPushResultCopyWithImpl<$Res, $Val extends SyncPushResult>
    implements $SyncPushResultCopyWith<$Res> {
  _$SyncPushResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncPushSuccessImplCopyWith<$Res> {
  factory _$$SyncPushSuccessImplCopyWith(_$SyncPushSuccessImpl value,
          $Res Function(_$SyncPushSuccessImpl) then) =
      __$$SyncPushSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<String> syncedIds,
      List<SyncPushItemError> errors,
      String serverSeq});
}

/// @nodoc
class __$$SyncPushSuccessImplCopyWithImpl<$Res>
    extends _$SyncPushResultCopyWithImpl<$Res, _$SyncPushSuccessImpl>
    implements _$$SyncPushSuccessImplCopyWith<$Res> {
  __$$SyncPushSuccessImplCopyWithImpl(
      _$SyncPushSuccessImpl _value, $Res Function(_$SyncPushSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncedIds = null,
    Object? errors = null,
    Object? serverSeq = null,
  }) {
    return _then(_$SyncPushSuccessImpl(
      syncedIds: null == syncedIds
          ? _value._syncedIds
          : syncedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<SyncPushItemError>,
      serverSeq: null == serverSeq
          ? _value.serverSeq
          : serverSeq // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncPushSuccessImpl
    with DiagnosticableTreeMixin
    implements SyncPushSuccess {
  const _$SyncPushSuccessImpl(
      {required final List<String> syncedIds,
      required final List<SyncPushItemError> errors,
      required this.serverSeq})
      : _syncedIds = syncedIds,
        _errors = errors;

  final List<String> _syncedIds;
  @override
  List<String> get syncedIds {
    if (_syncedIds is EqualUnmodifiableListView) return _syncedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_syncedIds);
  }

  final List<SyncPushItemError> _errors;
  @override
  List<SyncPushItemError> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  final String serverSeq;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncPushResult.success(syncedIds: $syncedIds, errors: $errors, serverSeq: $serverSeq)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncPushResult.success'))
      ..add(DiagnosticsProperty('syncedIds', syncedIds))
      ..add(DiagnosticsProperty('errors', errors))
      ..add(DiagnosticsProperty('serverSeq', serverSeq));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPushSuccessImpl &&
            const DeepCollectionEquality()
                .equals(other._syncedIds, _syncedIds) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.serverSeq, serverSeq) ||
                other.serverSeq == serverSeq));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_syncedIds),
      const DeepCollectionEquality().hash(_errors),
      serverSeq);

  /// Create a copy of SyncPushResult
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
    required TResult Function(List<String> syncedIds,
            List<SyncPushItemError> errors, String serverSeq)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) {
    return success(syncedIds, errors, serverSeq);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) {
    return success?.call(syncedIds, errors, serverSeq);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(syncedIds, errors, serverSeq);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPushSuccess value) success,
    required TResult Function(SyncPushFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPushSuccess value)? success,
    TResult? Function(SyncPushFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPushSuccess value)? success,
    TResult Function(SyncPushFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SyncPushSuccess implements SyncPushResult {
  const factory SyncPushSuccess(
      {required final List<String> syncedIds,
      required final List<SyncPushItemError> errors,
      required final String serverSeq}) = _$SyncPushSuccessImpl;

  List<String> get syncedIds;
  List<SyncPushItemError> get errors;
  String get serverSeq;

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPushSuccessImplCopyWith<_$SyncPushSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncPushFailureImplCopyWith<$Res> {
  factory _$$SyncPushFailureImplCopyWith(_$SyncPushFailureImpl value,
          $Res Function(_$SyncPushFailureImpl) then) =
      __$$SyncPushFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isRetryable});
}

/// @nodoc
class __$$SyncPushFailureImplCopyWithImpl<$Res>
    extends _$SyncPushResultCopyWithImpl<$Res, _$SyncPushFailureImpl>
    implements _$$SyncPushFailureImplCopyWith<$Res> {
  __$$SyncPushFailureImplCopyWithImpl(
      _$SyncPushFailureImpl _value, $Res Function(_$SyncPushFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isRetryable = null,
  }) {
    return _then(_$SyncPushFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRetryable: null == isRetryable
          ? _value.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SyncPushFailureImpl
    with DiagnosticableTreeMixin
    implements SyncPushFailure {
  const _$SyncPushFailureImpl(
      {required this.message, required this.isRetryable});

  @override
  final String message;
  @override
  final bool isRetryable;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncPushResult.failure(message: $message, isRetryable: $isRetryable)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncPushResult.failure'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('isRetryable', isRetryable));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPushFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRetryable);

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPushFailureImplCopyWith<_$SyncPushFailureImpl> get copyWith =>
      __$$SyncPushFailureImplCopyWithImpl<_$SyncPushFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> syncedIds,
            List<SyncPushItemError> errors, String serverSeq)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) {
    return failure(message, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) {
    return failure?.call(message, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> syncedIds, List<SyncPushItemError> errors,
            String serverSeq)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message, isRetryable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPushSuccess value) success,
    required TResult Function(SyncPushFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPushSuccess value)? success,
    TResult? Function(SyncPushFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPushSuccess value)? success,
    TResult Function(SyncPushFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SyncPushFailure implements SyncPushResult {
  const factory SyncPushFailure(
      {required final String message,
      required final bool isRetryable}) = _$SyncPushFailureImpl;

  String get message;
  bool get isRetryable;

  /// Create a copy of SyncPushResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPushFailureImplCopyWith<_$SyncPushFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SyncPushItemError {
  String get documentId => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Create a copy of SyncPushItemError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncPushItemErrorCopyWith<SyncPushItemError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncPushItemErrorCopyWith<$Res> {
  factory $SyncPushItemErrorCopyWith(
          SyncPushItemError value, $Res Function(SyncPushItemError) then) =
      _$SyncPushItemErrorCopyWithImpl<$Res, SyncPushItemError>;
  @useResult
  $Res call({String documentId, int statusCode, String reason});
}

/// @nodoc
class _$SyncPushItemErrorCopyWithImpl<$Res, $Val extends SyncPushItemError>
    implements $SyncPushItemErrorCopyWith<$Res> {
  _$SyncPushItemErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncPushItemError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? statusCode = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncPushItemErrorImplCopyWith<$Res>
    implements $SyncPushItemErrorCopyWith<$Res> {
  factory _$$SyncPushItemErrorImplCopyWith(_$SyncPushItemErrorImpl value,
          $Res Function(_$SyncPushItemErrorImpl) then) =
      __$$SyncPushItemErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String documentId, int statusCode, String reason});
}

/// @nodoc
class __$$SyncPushItemErrorImplCopyWithImpl<$Res>
    extends _$SyncPushItemErrorCopyWithImpl<$Res, _$SyncPushItemErrorImpl>
    implements _$$SyncPushItemErrorImplCopyWith<$Res> {
  __$$SyncPushItemErrorImplCopyWithImpl(_$SyncPushItemErrorImpl _value,
      $Res Function(_$SyncPushItemErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPushItemError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? statusCode = null,
    Object? reason = null,
  }) {
    return _then(_$SyncPushItemErrorImpl(
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncPushItemErrorImpl
    with DiagnosticableTreeMixin
    implements _SyncPushItemError {
  const _$SyncPushItemErrorImpl(
      {required this.documentId,
      required this.statusCode,
      required this.reason});

  @override
  final String documentId;
  @override
  final int statusCode;
  @override
  final String reason;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncPushItemError(documentId: $documentId, statusCode: $statusCode, reason: $reason)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncPushItemError'))
      ..add(DiagnosticsProperty('documentId', documentId))
      ..add(DiagnosticsProperty('statusCode', statusCode))
      ..add(DiagnosticsProperty('reason', reason));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPushItemErrorImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentId, statusCode, reason);

  /// Create a copy of SyncPushItemError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPushItemErrorImplCopyWith<_$SyncPushItemErrorImpl> get copyWith =>
      __$$SyncPushItemErrorImplCopyWithImpl<_$SyncPushItemErrorImpl>(
          this, _$identity);
}

abstract class _SyncPushItemError implements SyncPushItemError {
  const factory _SyncPushItemError(
      {required final String documentId,
      required final int statusCode,
      required final String reason}) = _$SyncPushItemErrorImpl;

  @override
  String get documentId;
  @override
  int get statusCode;
  @override
  String get reason;

  /// Create a copy of SyncPushItemError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPushItemErrorImplCopyWith<_$SyncPushItemErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SyncPullResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPullSuccess value) success,
    required TResult Function(SyncPullFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPullSuccess value)? success,
    TResult? Function(SyncPullFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPullSuccess value)? success,
    TResult Function(SyncPullFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncPullResultCopyWith<$Res> {
  factory $SyncPullResultCopyWith(
          SyncPullResult value, $Res Function(SyncPullResult) then) =
      _$SyncPullResultCopyWithImpl<$Res, SyncPullResult>;
}

/// @nodoc
class _$SyncPullResultCopyWithImpl<$Res, $Val extends SyncPullResult>
    implements $SyncPullResultCopyWith<$Res> {
  _$SyncPullResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncPullSuccessImplCopyWith<$Res> {
  factory _$$SyncPullSuccessImplCopyWith(_$SyncPullSuccessImpl value,
          $Res Function(_$SyncPullSuccessImpl) then) =
      __$$SyncPullSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Map<String, dynamic>> changes, String lastSeq, bool hasMore});
}

/// @nodoc
class __$$SyncPullSuccessImplCopyWithImpl<$Res>
    extends _$SyncPullResultCopyWithImpl<$Res, _$SyncPullSuccessImpl>
    implements _$$SyncPullSuccessImplCopyWith<$Res> {
  __$$SyncPullSuccessImplCopyWithImpl(
      _$SyncPullSuccessImpl _value, $Res Function(_$SyncPullSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changes = null,
    Object? lastSeq = null,
    Object? hasMore = null,
  }) {
    return _then(_$SyncPullSuccessImpl(
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      lastSeq: null == lastSeq
          ? _value.lastSeq
          : lastSeq // ignore: cast_nullable_to_non_nullable
              as String,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SyncPullSuccessImpl
    with DiagnosticableTreeMixin
    implements SyncPullSuccess {
  const _$SyncPullSuccessImpl(
      {required final List<Map<String, dynamic>> changes,
      required this.lastSeq,
      required this.hasMore})
      : _changes = changes;

  final List<Map<String, dynamic>> _changes;
  @override
  List<Map<String, dynamic>> get changes {
    if (_changes is EqualUnmodifiableListView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_changes);
  }

  @override
  final String lastSeq;
  @override
  final bool hasMore;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncPullResult.success(changes: $changes, lastSeq: $lastSeq, hasMore: $hasMore)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncPullResult.success'))
      ..add(DiagnosticsProperty('changes', changes))
      ..add(DiagnosticsProperty('lastSeq', lastSeq))
      ..add(DiagnosticsProperty('hasMore', hasMore));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPullSuccessImpl &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.lastSeq, lastSeq) || other.lastSeq == lastSeq) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_changes), lastSeq, hasMore);

  /// Create a copy of SyncPullResult
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
    required TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) {
    return success(changes, lastSeq, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) {
    return success?.call(changes, lastSeq, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(changes, lastSeq, hasMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPullSuccess value) success,
    required TResult Function(SyncPullFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPullSuccess value)? success,
    TResult? Function(SyncPullFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPullSuccess value)? success,
    TResult Function(SyncPullFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SyncPullSuccess implements SyncPullResult {
  const factory SyncPullSuccess(
      {required final List<Map<String, dynamic>> changes,
      required final String lastSeq,
      required final bool hasMore}) = _$SyncPullSuccessImpl;

  List<Map<String, dynamic>> get changes;
  String get lastSeq;
  bool get hasMore;

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPullSuccessImplCopyWith<_$SyncPullSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncPullFailureImplCopyWith<$Res> {
  factory _$$SyncPullFailureImplCopyWith(_$SyncPullFailureImpl value,
          $Res Function(_$SyncPullFailureImpl) then) =
      __$$SyncPullFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isRetryable});
}

/// @nodoc
class __$$SyncPullFailureImplCopyWithImpl<$Res>
    extends _$SyncPullResultCopyWithImpl<$Res, _$SyncPullFailureImpl>
    implements _$$SyncPullFailureImplCopyWith<$Res> {
  __$$SyncPullFailureImplCopyWithImpl(
      _$SyncPullFailureImpl _value, $Res Function(_$SyncPullFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isRetryable = null,
  }) {
    return _then(_$SyncPullFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRetryable: null == isRetryable
          ? _value.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SyncPullFailureImpl
    with DiagnosticableTreeMixin
    implements SyncPullFailure {
  const _$SyncPullFailureImpl(
      {required this.message, required this.isRetryable});

  @override
  final String message;
  @override
  final bool isRetryable;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncPullResult.failure(message: $message, isRetryable: $isRetryable)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncPullResult.failure'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('isRetryable', isRetryable));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPullFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRetryable);

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPullFailureImplCopyWith<_$SyncPullFailureImpl> get copyWith =>
      __$$SyncPullFailureImplCopyWithImpl<_$SyncPullFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)
        success,
    required TResult Function(String message, bool isRetryable) failure,
  }) {
    return failure(message, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult? Function(String message, bool isRetryable)? failure,
  }) {
    return failure?.call(message, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<Map<String, dynamic>> changes, String lastSeq, bool hasMore)?
        success,
    TResult Function(String message, bool isRetryable)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message, isRetryable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncPullSuccess value) success,
    required TResult Function(SyncPullFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncPullSuccess value)? success,
    TResult? Function(SyncPullFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncPullSuccess value)? success,
    TResult Function(SyncPullFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SyncPullFailure implements SyncPullResult {
  const factory SyncPullFailure(
      {required final String message,
      required final bool isRetryable}) = _$SyncPullFailureImpl;

  String get message;
  bool get isRetryable;

  /// Create a copy of SyncPullResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPullFailureImplCopyWith<_$SyncPullFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
