// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardEventCopyWith<$Res> {
  factory $DashboardEventCopyWith(
          DashboardEvent value, $Res Function(DashboardEvent) then) =
      _$DashboardEventCopyWithImpl<$Res, DashboardEvent>;
}

/// @nodoc
class _$DashboardEventCopyWithImpl<$Res, $Val extends DashboardEvent>
    implements $DashboardEventCopyWith<$Res> {
  _$DashboardEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DashboardInitializedImplCopyWith<$Res> {
  factory _$$DashboardInitializedImplCopyWith(_$DashboardInitializedImpl value,
          $Res Function(_$DashboardInitializedImpl) then) =
      __$$DashboardInitializedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String zoneId});
}

/// @nodoc
class __$$DashboardInitializedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardInitializedImpl>
    implements _$$DashboardInitializedImplCopyWith<$Res> {
  __$$DashboardInitializedImplCopyWithImpl(_$DashboardInitializedImpl _value,
      $Res Function(_$DashboardInitializedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoneId = null,
  }) {
    return _then(_$DashboardInitializedImpl(
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DashboardInitializedImpl
    with DiagnosticableTreeMixin
    implements DashboardInitialized {
  const _$DashboardInitializedImpl({required this.zoneId});

  @override
  final String zoneId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.initialized(zoneId: $zoneId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.initialized'))
      ..add(DiagnosticsProperty('zoneId', zoneId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardInitializedImpl &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, zoneId);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardInitializedImplCopyWith<_$DashboardInitializedImpl>
      get copyWith =>
          __$$DashboardInitializedImplCopyWithImpl<_$DashboardInitializedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return initialized(zoneId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return initialized?.call(zoneId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(zoneId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return initialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return initialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(this);
    }
    return orElse();
  }
}

abstract class DashboardInitialized implements DashboardEvent {
  const factory DashboardInitialized({required final String zoneId}) =
      _$DashboardInitializedImpl;

  String get zoneId;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardInitializedImplCopyWith<_$DashboardInitializedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardRefreshRequestedImplCopyWith<$Res> {
  factory _$$DashboardRefreshRequestedImplCopyWith(
          _$DashboardRefreshRequestedImpl value,
          $Res Function(_$DashboardRefreshRequestedImpl) then) =
      __$$DashboardRefreshRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardRefreshRequestedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardRefreshRequestedImpl>
    implements _$$DashboardRefreshRequestedImplCopyWith<$Res> {
  __$$DashboardRefreshRequestedImplCopyWithImpl(
      _$DashboardRefreshRequestedImpl _value,
      $Res Function(_$DashboardRefreshRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardRefreshRequestedImpl
    with DiagnosticableTreeMixin
    implements DashboardRefreshRequested {
  const _$DashboardRefreshRequestedImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.refreshRequested()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'DashboardEvent.refreshRequested'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardRefreshRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return refreshRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return refreshRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (refreshRequested != null) {
      return refreshRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return refreshRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return refreshRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (refreshRequested != null) {
      return refreshRequested(this);
    }
    return orElse();
  }
}

abstract class DashboardRefreshRequested implements DashboardEvent {
  const factory DashboardRefreshRequested() = _$DashboardRefreshRequestedImpl;
}

/// @nodoc
abstract class _$$NeedStatusUpdatedImplCopyWith<$Res> {
  factory _$$NeedStatusUpdatedImplCopyWith(_$NeedStatusUpdatedImpl value,
          $Res Function(_$NeedStatusUpdatedImpl) then) =
      __$$NeedStatusUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String needId, String newStatus});
}

/// @nodoc
class __$$NeedStatusUpdatedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$NeedStatusUpdatedImpl>
    implements _$$NeedStatusUpdatedImplCopyWith<$Res> {
  __$$NeedStatusUpdatedImplCopyWithImpl(_$NeedStatusUpdatedImpl _value,
      $Res Function(_$NeedStatusUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needId = null,
    Object? newStatus = null,
  }) {
    return _then(_$NeedStatusUpdatedImpl(
      needId: null == needId
          ? _value.needId
          : needId // ignore: cast_nullable_to_non_nullable
              as String,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NeedStatusUpdatedImpl
    with DiagnosticableTreeMixin
    implements NeedStatusUpdated {
  const _$NeedStatusUpdatedImpl(
      {required this.needId, required this.newStatus});

  @override
  final String needId;
  @override
  final String newStatus;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.needStatusUpdated(needId: $needId, newStatus: $newStatus)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.needStatusUpdated'))
      ..add(DiagnosticsProperty('needId', needId))
      ..add(DiagnosticsProperty('newStatus', newStatus));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedStatusUpdatedImpl &&
            (identical(other.needId, needId) || other.needId == needId) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, needId, newStatus);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedStatusUpdatedImplCopyWith<_$NeedStatusUpdatedImpl> get copyWith =>
      __$$NeedStatusUpdatedImplCopyWithImpl<_$NeedStatusUpdatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return needStatusUpdated(needId, newStatus);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return needStatusUpdated?.call(needId, newStatus);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (needStatusUpdated != null) {
      return needStatusUpdated(needId, newStatus);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return needStatusUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return needStatusUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (needStatusUpdated != null) {
      return needStatusUpdated(this);
    }
    return orElse();
  }
}

abstract class NeedStatusUpdated implements DashboardEvent {
  const factory NeedStatusUpdated(
      {required final String needId,
      required final String newStatus}) = _$NeedStatusUpdatedImpl;

  String get needId;
  String get newStatus;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NeedStatusUpdatedImplCopyWith<_$NeedStatusUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VolunteerAssignedImplCopyWith<$Res> {
  factory _$$VolunteerAssignedImplCopyWith(_$VolunteerAssignedImpl value,
          $Res Function(_$VolunteerAssignedImpl) then) =
      __$$VolunteerAssignedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String needId, String volunteerId});
}

/// @nodoc
class __$$VolunteerAssignedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$VolunteerAssignedImpl>
    implements _$$VolunteerAssignedImplCopyWith<$Res> {
  __$$VolunteerAssignedImplCopyWithImpl(_$VolunteerAssignedImpl _value,
      $Res Function(_$VolunteerAssignedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needId = null,
    Object? volunteerId = null,
  }) {
    return _then(_$VolunteerAssignedImpl(
      needId: null == needId
          ? _value.needId
          : needId // ignore: cast_nullable_to_non_nullable
              as String,
      volunteerId: null == volunteerId
          ? _value.volunteerId
          : volunteerId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VolunteerAssignedImpl
    with DiagnosticableTreeMixin
    implements VolunteerAssigned {
  const _$VolunteerAssignedImpl(
      {required this.needId, required this.volunteerId});

  @override
  final String needId;
  @override
  final String volunteerId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.volunteerAssigned(needId: $needId, volunteerId: $volunteerId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.volunteerAssigned'))
      ..add(DiagnosticsProperty('needId', needId))
      ..add(DiagnosticsProperty('volunteerId', volunteerId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VolunteerAssignedImpl &&
            (identical(other.needId, needId) || other.needId == needId) &&
            (identical(other.volunteerId, volunteerId) ||
                other.volunteerId == volunteerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, needId, volunteerId);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VolunteerAssignedImplCopyWith<_$VolunteerAssignedImpl> get copyWith =>
      __$$VolunteerAssignedImplCopyWithImpl<_$VolunteerAssignedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return volunteerAssigned(needId, volunteerId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return volunteerAssigned?.call(needId, volunteerId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (volunteerAssigned != null) {
      return volunteerAssigned(needId, volunteerId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return volunteerAssigned(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return volunteerAssigned?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (volunteerAssigned != null) {
      return volunteerAssigned(this);
    }
    return orElse();
  }
}

abstract class VolunteerAssigned implements DashboardEvent {
  const factory VolunteerAssigned(
      {required final String needId,
      required final String volunteerId}) = _$VolunteerAssignedImpl;

  String get needId;
  String get volunteerId;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VolunteerAssignedImplCopyWith<_$VolunteerAssignedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterChangedImplCopyWith<$Res> {
  factory _$$FilterChangedImplCopyWith(
          _$FilterChangedImpl value, $Res Function(_$FilterChangedImpl) then) =
      __$$FilterChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? statusFilter, int? priorityFilter, String? sourceFilter});
}

/// @nodoc
class __$$FilterChangedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$FilterChangedImpl>
    implements _$$FilterChangedImplCopyWith<$Res> {
  __$$FilterChangedImplCopyWithImpl(
      _$FilterChangedImpl _value, $Res Function(_$FilterChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusFilter = freezed,
    Object? priorityFilter = freezed,
    Object? sourceFilter = freezed,
  }) {
    return _then(_$FilterChangedImpl(
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      priorityFilter: freezed == priorityFilter
          ? _value.priorityFilter
          : priorityFilter // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceFilter: freezed == sourceFilter
          ? _value.sourceFilter
          : sourceFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FilterChangedImpl
    with DiagnosticableTreeMixin
    implements FilterChanged {
  const _$FilterChangedImpl(
      {this.statusFilter, this.priorityFilter, this.sourceFilter});

  @override
  final String? statusFilter;
  @override
  final int? priorityFilter;
  @override
  final String? sourceFilter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.filterChanged(statusFilter: $statusFilter, priorityFilter: $priorityFilter, sourceFilter: $sourceFilter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.filterChanged'))
      ..add(DiagnosticsProperty('statusFilter', statusFilter))
      ..add(DiagnosticsProperty('priorityFilter', priorityFilter))
      ..add(DiagnosticsProperty('sourceFilter', sourceFilter));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterChangedImpl &&
            (identical(other.statusFilter, statusFilter) ||
                other.statusFilter == statusFilter) &&
            (identical(other.priorityFilter, priorityFilter) ||
                other.priorityFilter == priorityFilter) &&
            (identical(other.sourceFilter, sourceFilter) ||
                other.sourceFilter == sourceFilter));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, statusFilter, priorityFilter, sourceFilter);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterChangedImplCopyWith<_$FilterChangedImpl> get copyWith =>
      __$$FilterChangedImplCopyWithImpl<_$FilterChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return filterChanged(statusFilter, priorityFilter, sourceFilter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return filterChanged?.call(statusFilter, priorityFilter, sourceFilter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (filterChanged != null) {
      return filterChanged(statusFilter, priorityFilter, sourceFilter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return filterChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return filterChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (filterChanged != null) {
      return filterChanged(this);
    }
    return orElse();
  }
}

abstract class FilterChanged implements DashboardEvent {
  const factory FilterChanged(
      {final String? statusFilter,
      final int? priorityFilter,
      final String? sourceFilter}) = _$FilterChangedImpl;

  String? get statusFilter;
  int? get priorityFilter;
  String? get sourceFilter;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterChangedImplCopyWith<_$FilterChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardDisposedImplCopyWith<$Res> {
  factory _$$DashboardDisposedImplCopyWith(_$DashboardDisposedImpl value,
          $Res Function(_$DashboardDisposedImpl) then) =
      __$$DashboardDisposedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardDisposedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardDisposedImpl>
    implements _$$DashboardDisposedImplCopyWith<$Res> {
  __$$DashboardDisposedImplCopyWithImpl(_$DashboardDisposedImpl _value,
      $Res Function(_$DashboardDisposedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardDisposedImpl
    with DiagnosticableTreeMixin
    implements DashboardDisposed {
  const _$DashboardDisposedImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.disposed()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'DashboardEvent.disposed'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DashboardDisposedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return disposed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return disposed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (disposed != null) {
      return disposed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return disposed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return disposed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (disposed != null) {
      return disposed(this);
    }
    return orElse();
  }
}

abstract class DashboardDisposed implements DashboardEvent {
  const factory DashboardDisposed() = _$DashboardDisposedImpl;
}

/// @nodoc
abstract class _$$DashboardStatsArrivedImplCopyWith<$Res> {
  factory _$$DashboardStatsArrivedImplCopyWith(
          _$DashboardStatsArrivedImpl value,
          $Res Function(_$DashboardStatsArrivedImpl) then) =
      __$$DashboardStatsArrivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardStats stats});

  $DashboardStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$DashboardStatsArrivedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardStatsArrivedImpl>
    implements _$$DashboardStatsArrivedImplCopyWith<$Res> {
  __$$DashboardStatsArrivedImplCopyWithImpl(_$DashboardStatsArrivedImpl _value,
      $Res Function(_$DashboardStatsArrivedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
  }) {
    return _then(_$DashboardStatsArrivedImpl(
      null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as DashboardStats,
    ));
  }

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardStatsCopyWith<$Res> get stats {
    return $DashboardStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value));
    });
  }
}

/// @nodoc

class _$DashboardStatsArrivedImpl
    with DiagnosticableTreeMixin
    implements _DashboardStatsArrived {
  const _$DashboardStatsArrivedImpl(this.stats);

  @override
  final DashboardStats stats;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.statsArrived(stats: $stats)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.statsArrived'))
      ..add(DiagnosticsProperty('stats', stats));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsArrivedImpl &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stats);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsArrivedImplCopyWith<_$DashboardStatsArrivedImpl>
      get copyWith => __$$DashboardStatsArrivedImplCopyWithImpl<
          _$DashboardStatsArrivedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return statsArrived(stats);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return statsArrived?.call(stats);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (statsArrived != null) {
      return statsArrived(stats);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return statsArrived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return statsArrived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (statsArrived != null) {
      return statsArrived(this);
    }
    return orElse();
  }
}

abstract class _DashboardStatsArrived implements DashboardEvent {
  const factory _DashboardStatsArrived(final DashboardStats stats) =
      _$DashboardStatsArrivedImpl;

  DashboardStats get stats;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsArrivedImplCopyWith<_$DashboardStatsArrivedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardNeedsArrivedImplCopyWith<$Res> {
  factory _$$DashboardNeedsArrivedImplCopyWith(
          _$DashboardNeedsArrivedImpl value,
          $Res Function(_$DashboardNeedsArrivedImpl) then) =
      __$$DashboardNeedsArrivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<NeedSummary> needs});
}

/// @nodoc
class __$$DashboardNeedsArrivedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardNeedsArrivedImpl>
    implements _$$DashboardNeedsArrivedImplCopyWith<$Res> {
  __$$DashboardNeedsArrivedImplCopyWithImpl(_$DashboardNeedsArrivedImpl _value,
      $Res Function(_$DashboardNeedsArrivedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needs = null,
  }) {
    return _then(_$DashboardNeedsArrivedImpl(
      null == needs
          ? _value._needs
          : needs // ignore: cast_nullable_to_non_nullable
              as List<NeedSummary>,
    ));
  }
}

/// @nodoc

class _$DashboardNeedsArrivedImpl
    with DiagnosticableTreeMixin
    implements _DashboardNeedsArrived {
  const _$DashboardNeedsArrivedImpl(final List<NeedSummary> needs)
      : _needs = needs;

  final List<NeedSummary> _needs;
  @override
  List<NeedSummary> get needs {
    if (_needs is EqualUnmodifiableListView) return _needs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_needs);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.needsArrived(needs: $needs)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.needsArrived'))
      ..add(DiagnosticsProperty('needs', needs));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardNeedsArrivedImpl &&
            const DeepCollectionEquality().equals(other._needs, _needs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_needs));

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardNeedsArrivedImplCopyWith<_$DashboardNeedsArrivedImpl>
      get copyWith => __$$DashboardNeedsArrivedImplCopyWithImpl<
          _$DashboardNeedsArrivedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return needsArrived(needs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return needsArrived?.call(needs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (needsArrived != null) {
      return needsArrived(needs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return needsArrived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return needsArrived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (needsArrived != null) {
      return needsArrived(this);
    }
    return orElse();
  }
}

abstract class _DashboardNeedsArrived implements DashboardEvent {
  const factory _DashboardNeedsArrived(final List<NeedSummary> needs) =
      _$DashboardNeedsArrivedImpl;

  List<NeedSummary> get needs;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardNeedsArrivedImplCopyWith<_$DashboardNeedsArrivedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardStreamFailedImplCopyWith<$Res> {
  factory _$$DashboardStreamFailedImplCopyWith(
          _$DashboardStreamFailedImpl value,
          $Res Function(_$DashboardStreamFailedImpl) then) =
      __$$DashboardStreamFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardFailure failure});

  $DashboardFailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$DashboardStreamFailedImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$DashboardStreamFailedImpl>
    implements _$$DashboardStreamFailedImplCopyWith<$Res> {
  __$$DashboardStreamFailedImplCopyWithImpl(_$DashboardStreamFailedImpl _value,
      $Res Function(_$DashboardStreamFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$DashboardStreamFailedImpl(
      null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as DashboardFailure,
    ));
  }

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardFailureCopyWith<$Res> get failure {
    return $DashboardFailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$DashboardStreamFailedImpl
    with DiagnosticableTreeMixin
    implements _DashboardStreamFailed {
  const _$DashboardStreamFailedImpl(this.failure);

  @override
  final DashboardFailure failure;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.streamFailed(failure: $failure)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardEvent.streamFailed'))
      ..add(DiagnosticsProperty('failure', failure));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStreamFailedImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStreamFailedImplCopyWith<_$DashboardStreamFailedImpl>
      get copyWith => __$$DashboardStreamFailedImplCopyWithImpl<
          _$DashboardStreamFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zoneId) initialized,
    required TResult Function() refreshRequested,
    required TResult Function(String needId, String newStatus)
        needStatusUpdated,
    required TResult Function(String needId, String volunteerId)
        volunteerAssigned,
    required TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)
        filterChanged,
    required TResult Function() disposed,
    required TResult Function(DashboardStats stats) statsArrived,
    required TResult Function(List<NeedSummary> needs) needsArrived,
    required TResult Function(DashboardFailure failure) streamFailed,
  }) {
    return streamFailed(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zoneId)? initialized,
    TResult? Function()? refreshRequested,
    TResult? Function(String needId, String newStatus)? needStatusUpdated,
    TResult? Function(String needId, String volunteerId)? volunteerAssigned,
    TResult? Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult? Function()? disposed,
    TResult? Function(DashboardStats stats)? statsArrived,
    TResult? Function(List<NeedSummary> needs)? needsArrived,
    TResult? Function(DashboardFailure failure)? streamFailed,
  }) {
    return streamFailed?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zoneId)? initialized,
    TResult Function()? refreshRequested,
    TResult Function(String needId, String newStatus)? needStatusUpdated,
    TResult Function(String needId, String volunteerId)? volunteerAssigned,
    TResult Function(
            String? statusFilter, int? priorityFilter, String? sourceFilter)?
        filterChanged,
    TResult Function()? disposed,
    TResult Function(DashboardStats stats)? statsArrived,
    TResult Function(List<NeedSummary> needs)? needsArrived,
    TResult Function(DashboardFailure failure)? streamFailed,
    required TResult orElse(),
  }) {
    if (streamFailed != null) {
      return streamFailed(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitialized value) initialized,
    required TResult Function(DashboardRefreshRequested value) refreshRequested,
    required TResult Function(NeedStatusUpdated value) needStatusUpdated,
    required TResult Function(VolunteerAssigned value) volunteerAssigned,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(DashboardDisposed value) disposed,
    required TResult Function(_DashboardStatsArrived value) statsArrived,
    required TResult Function(_DashboardNeedsArrived value) needsArrived,
    required TResult Function(_DashboardStreamFailed value) streamFailed,
  }) {
    return streamFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitialized value)? initialized,
    TResult? Function(DashboardRefreshRequested value)? refreshRequested,
    TResult? Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult? Function(VolunteerAssigned value)? volunteerAssigned,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(DashboardDisposed value)? disposed,
    TResult? Function(_DashboardStatsArrived value)? statsArrived,
    TResult? Function(_DashboardNeedsArrived value)? needsArrived,
    TResult? Function(_DashboardStreamFailed value)? streamFailed,
  }) {
    return streamFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitialized value)? initialized,
    TResult Function(DashboardRefreshRequested value)? refreshRequested,
    TResult Function(NeedStatusUpdated value)? needStatusUpdated,
    TResult Function(VolunteerAssigned value)? volunteerAssigned,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(DashboardDisposed value)? disposed,
    TResult Function(_DashboardStatsArrived value)? statsArrived,
    TResult Function(_DashboardNeedsArrived value)? needsArrived,
    TResult Function(_DashboardStreamFailed value)? streamFailed,
    required TResult orElse(),
  }) {
    if (streamFailed != null) {
      return streamFailed(this);
    }
    return orElse();
  }
}

abstract class _DashboardStreamFailed implements DashboardEvent {
  const factory _DashboardStreamFailed(final DashboardFailure failure) =
      _$DashboardStreamFailedImpl;

  DashboardFailure get failure;

  /// Create a copy of DashboardEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStreamFailedImplCopyWith<_$DashboardStreamFailedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DashboardState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)
        loaded,
    required TResult Function(
            DashboardFailure failure, DashboardStats? lastKnownStats)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult? Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitial value) initial,
    required TResult Function(DashboardLoading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(DashboardError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitial value)? initial,
    TResult? Function(DashboardLoading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(DashboardError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitial value)? initial,
    TResult Function(DashboardLoading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(DashboardError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DashboardInitialImplCopyWith<$Res> {
  factory _$$DashboardInitialImplCopyWith(_$DashboardInitialImpl value,
          $Res Function(_$DashboardInitialImpl) then) =
      __$$DashboardInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardInitialImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardInitialImpl>
    implements _$$DashboardInitialImplCopyWith<$Res> {
  __$$DashboardInitialImplCopyWithImpl(_$DashboardInitialImpl _value,
      $Res Function(_$DashboardInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardInitialImpl
    with DiagnosticableTreeMixin
    implements DashboardInitial {
  const _$DashboardInitialImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'DashboardState.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DashboardInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)
        loaded,
    required TResult Function(
            DashboardFailure failure, DashboardStats? lastKnownStats)
        error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult? Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitial value) initial,
    required TResult Function(DashboardLoading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(DashboardError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitial value)? initial,
    TResult? Function(DashboardLoading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(DashboardError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitial value)? initial,
    TResult Function(DashboardLoading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(DashboardError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class DashboardInitial implements DashboardState {
  const factory DashboardInitial() = _$DashboardInitialImpl;
}

/// @nodoc
abstract class _$$DashboardLoadingImplCopyWith<$Res> {
  factory _$$DashboardLoadingImplCopyWith(_$DashboardLoadingImpl value,
          $Res Function(_$DashboardLoadingImpl) then) =
      __$$DashboardLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardLoadingImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardLoadingImpl>
    implements _$$DashboardLoadingImplCopyWith<$Res> {
  __$$DashboardLoadingImplCopyWithImpl(_$DashboardLoadingImpl _value,
      $Res Function(_$DashboardLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardLoadingImpl
    with DiagnosticableTreeMixin
    implements DashboardLoading {
  const _$DashboardLoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'DashboardState.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DashboardLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)
        loaded,
    required TResult Function(
            DashboardFailure failure, DashboardStats? lastKnownStats)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult? Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitial value) initial,
    required TResult Function(DashboardLoading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(DashboardError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitial value)? initial,
    TResult? Function(DashboardLoading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(DashboardError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitial value)? initial,
    TResult Function(DashboardLoading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(DashboardError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DashboardLoading implements DashboardState {
  const factory DashboardLoading() = _$DashboardLoadingImpl;
}

/// @nodoc
abstract class _$$DashboardLoadedImplCopyWith<$Res> {
  factory _$$DashboardLoadedImplCopyWith(_$DashboardLoadedImpl value,
          $Res Function(_$DashboardLoadedImpl) then) =
      __$$DashboardLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {DashboardStats stats,
      List<NeedSummary> needs,
      String? statusFilter,
      int? priorityFilter,
      String? sourceFilter,
      bool isRefreshing,
      DateTime lastRefreshedAt});

  $DashboardStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$DashboardLoadedImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardLoadedImpl>
    implements _$$DashboardLoadedImplCopyWith<$Res> {
  __$$DashboardLoadedImplCopyWithImpl(
      _$DashboardLoadedImpl _value, $Res Function(_$DashboardLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? needs = null,
    Object? statusFilter = freezed,
    Object? priorityFilter = freezed,
    Object? sourceFilter = freezed,
    Object? isRefreshing = null,
    Object? lastRefreshedAt = null,
  }) {
    return _then(_$DashboardLoadedImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as DashboardStats,
      needs: null == needs
          ? _value._needs
          : needs // ignore: cast_nullable_to_non_nullable
              as List<NeedSummary>,
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      priorityFilter: freezed == priorityFilter
          ? _value.priorityFilter
          : priorityFilter // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceFilter: freezed == sourceFilter
          ? _value.sourceFilter
          : sourceFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      lastRefreshedAt: null == lastRefreshedAt
          ? _value.lastRefreshedAt
          : lastRefreshedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardStatsCopyWith<$Res> get stats {
    return $DashboardStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value));
    });
  }
}

/// @nodoc

class _$DashboardLoadedImpl
    with DiagnosticableTreeMixin
    implements DashboardLoaded {
  const _$DashboardLoadedImpl(
      {required this.stats,
      required final List<NeedSummary> needs,
      required this.statusFilter,
      required this.priorityFilter,
      required this.sourceFilter,
      required this.isRefreshing,
      required this.lastRefreshedAt})
      : _needs = needs;

  @override
  final DashboardStats stats;
  final List<NeedSummary> _needs;
  @override
  List<NeedSummary> get needs {
    if (_needs is EqualUnmodifiableListView) return _needs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_needs);
  }

  @override
  final String? statusFilter;
  @override
  final int? priorityFilter;
  @override
  final String? sourceFilter;
  @override
  final bool isRefreshing;
  @override
  final DateTime lastRefreshedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.loaded(stats: $stats, needs: $needs, statusFilter: $statusFilter, priorityFilter: $priorityFilter, sourceFilter: $sourceFilter, isRefreshing: $isRefreshing, lastRefreshedAt: $lastRefreshedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardState.loaded'))
      ..add(DiagnosticsProperty('stats', stats))
      ..add(DiagnosticsProperty('needs', needs))
      ..add(DiagnosticsProperty('statusFilter', statusFilter))
      ..add(DiagnosticsProperty('priorityFilter', priorityFilter))
      ..add(DiagnosticsProperty('sourceFilter', sourceFilter))
      ..add(DiagnosticsProperty('isRefreshing', isRefreshing))
      ..add(DiagnosticsProperty('lastRefreshedAt', lastRefreshedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardLoadedImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality().equals(other._needs, _needs) &&
            (identical(other.statusFilter, statusFilter) ||
                other.statusFilter == statusFilter) &&
            (identical(other.priorityFilter, priorityFilter) ||
                other.priorityFilter == priorityFilter) &&
            (identical(other.sourceFilter, sourceFilter) ||
                other.sourceFilter == sourceFilter) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.lastRefreshedAt, lastRefreshedAt) ||
                other.lastRefreshedAt == lastRefreshedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      stats,
      const DeepCollectionEquality().hash(_needs),
      statusFilter,
      priorityFilter,
      sourceFilter,
      isRefreshing,
      lastRefreshedAt);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardLoadedImplCopyWith<_$DashboardLoadedImpl> get copyWith =>
      __$$DashboardLoadedImplCopyWithImpl<_$DashboardLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)
        loaded,
    required TResult Function(
            DashboardFailure failure, DashboardStats? lastKnownStats)
        error,
  }) {
    return loaded(stats, needs, statusFilter, priorityFilter, sourceFilter,
        isRefreshing, lastRefreshedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult? Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
  }) {
    return loaded?.call(stats, needs, statusFilter, priorityFilter,
        sourceFilter, isRefreshing, lastRefreshedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(stats, needs, statusFilter, priorityFilter, sourceFilter,
          isRefreshing, lastRefreshedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitial value) initial,
    required TResult Function(DashboardLoading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(DashboardError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitial value)? initial,
    TResult? Function(DashboardLoading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(DashboardError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitial value)? initial,
    TResult Function(DashboardLoading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(DashboardError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class DashboardLoaded implements DashboardState {
  const factory DashboardLoaded(
      {required final DashboardStats stats,
      required final List<NeedSummary> needs,
      required final String? statusFilter,
      required final int? priorityFilter,
      required final String? sourceFilter,
      required final bool isRefreshing,
      required final DateTime lastRefreshedAt}) = _$DashboardLoadedImpl;

  DashboardStats get stats;
  List<NeedSummary> get needs;
  String? get statusFilter;
  int? get priorityFilter;
  String? get sourceFilter;
  bool get isRefreshing;
  DateTime get lastRefreshedAt;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardLoadedImplCopyWith<_$DashboardLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardErrorImplCopyWith<$Res> {
  factory _$$DashboardErrorImplCopyWith(_$DashboardErrorImpl value,
          $Res Function(_$DashboardErrorImpl) then) =
      __$$DashboardErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardFailure failure, DashboardStats? lastKnownStats});

  $DashboardFailureCopyWith<$Res> get failure;
  $DashboardStatsCopyWith<$Res>? get lastKnownStats;
}

/// @nodoc
class __$$DashboardErrorImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardErrorImpl>
    implements _$$DashboardErrorImplCopyWith<$Res> {
  __$$DashboardErrorImplCopyWithImpl(
      _$DashboardErrorImpl _value, $Res Function(_$DashboardErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
    Object? lastKnownStats = freezed,
  }) {
    return _then(_$DashboardErrorImpl(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as DashboardFailure,
      lastKnownStats: freezed == lastKnownStats
          ? _value.lastKnownStats
          : lastKnownStats // ignore: cast_nullable_to_non_nullable
              as DashboardStats?,
    ));
  }

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardFailureCopyWith<$Res> get failure {
    return $DashboardFailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardStatsCopyWith<$Res>? get lastKnownStats {
    if (_value.lastKnownStats == null) {
      return null;
    }

    return $DashboardStatsCopyWith<$Res>(_value.lastKnownStats!, (value) {
      return _then(_value.copyWith(lastKnownStats: value));
    });
  }
}

/// @nodoc

class _$DashboardErrorImpl
    with DiagnosticableTreeMixin
    implements DashboardError {
  const _$DashboardErrorImpl({required this.failure, this.lastKnownStats});

  @override
  final DashboardFailure failure;
  @override
  final DashboardStats? lastKnownStats;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.error(failure: $failure, lastKnownStats: $lastKnownStats)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardState.error'))
      ..add(DiagnosticsProperty('failure', failure))
      ..add(DiagnosticsProperty('lastKnownStats', lastKnownStats));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.lastKnownStats, lastKnownStats) ||
                other.lastKnownStats == lastKnownStats));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure, lastKnownStats);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardErrorImplCopyWith<_$DashboardErrorImpl> get copyWith =>
      __$$DashboardErrorImplCopyWithImpl<_$DashboardErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)
        loaded,
    required TResult Function(
            DashboardFailure failure, DashboardStats? lastKnownStats)
        error,
  }) {
    return error(failure, lastKnownStats);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult? Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
  }) {
    return error?.call(failure, lastKnownStats);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            DashboardStats stats,
            List<NeedSummary> needs,
            String? statusFilter,
            int? priorityFilter,
            String? sourceFilter,
            bool isRefreshing,
            DateTime lastRefreshedAt)?
        loaded,
    TResult Function(DashboardFailure failure, DashboardStats? lastKnownStats)?
        error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure, lastKnownStats);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitial value) initial,
    required TResult Function(DashboardLoading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(DashboardError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitial value)? initial,
    TResult? Function(DashboardLoading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(DashboardError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitial value)? initial,
    TResult Function(DashboardLoading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(DashboardError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DashboardError implements DashboardState {
  const factory DashboardError(
      {required final DashboardFailure failure,
      final DashboardStats? lastKnownStats}) = _$DashboardErrorImpl;

  DashboardFailure get failure;
  DashboardStats? get lastKnownStats;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardErrorImplCopyWith<_$DashboardErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
