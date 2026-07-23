import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiaya.dart';
import 'package:newklikrkw/models/validation_error.dart';

const _unset = Object();

class DkeluarbiayaState extends Equatable {
  ///==============================
  /// LIST
  ///==============================
  final List<Dkeluarbiaya> dkeluarbiayas;

  ///==============================
  /// MASTER
  ///==============================
  final List<Itemkegiatan> itemkegiatans;

  ///==============================
  /// LOADING
  ///==============================
  final bool loading;
  final bool loadingMore;
  final bool refreshing;
  final bool loadingKeluarbiaya;

  ///==============================
  /// PAGINATION
  ///==============================
  final bool hasMore;
  final int offset;
  final int limit;
  final int total;

  ///==============================
  /// FILTER
  ///==============================
  final String keluarbiayaId;

  ///==============================
  /// ERROR
  ///==============================
  final String? errorMessage;

  final bool saving;
  final bool saveSuccess;

  final ValidationError? validationError;

  final Keluarbiaya? keluarbiaya;

  final bool updatingStatus;
  final bool updateStatusSuccess;

  /// Delete
  final bool deleting;
  final bool deleteSuccess;

  const DkeluarbiayaState({
    this.dkeluarbiayas = const [],
    this.itemkegiatans = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.loadingKeluarbiaya = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.total = 0,
    this.keluarbiayaId = '',
    this.errorMessage,
    this.saving = false,
    this.saveSuccess = false,
    this.validationError,
    this.keluarbiaya,
    this.updatingStatus = false,
    this.updateStatusSuccess = false,
    this.deleting = false,
    this.deleteSuccess = false,
  });

  factory DkeluarbiayaState.initial() {
    return const DkeluarbiayaState();
  }

  DkeluarbiayaState copyWith({
    List<Dkeluarbiaya>? dkeluarbiayas,
    List<Itemkegiatan>? itemkegiatans,
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? loadingKeluarbiaya,
    bool? hasMore,
    int? offset,
    int? limit,
    int? total,
    String? keluarbiayaId,
    String? errorMessage,
    bool? saving,
    bool? saveSuccess,
    Object? validationError = _unset,
    Keluarbiaya? keluarbiaya,
    bool? updatingStatus,
    bool? updateStatusSuccess,
    bool? deleting,
    bool? deleteSuccess,
  }) {
    return DkeluarbiayaState(
      dkeluarbiayas: dkeluarbiayas ?? this.dkeluarbiayas,
      itemkegiatans: itemkegiatans ?? this.itemkegiatans,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      loadingKeluarbiaya: loadingKeluarbiaya ?? this.loadingKeluarbiaya,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      keluarbiayaId: keluarbiayaId ?? this.keluarbiayaId,
      errorMessage: errorMessage,
      saving: saving ?? this.saving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      validationError: identical(validationError, _unset)
          ? this.validationError
          : validationError as ValidationError?,
      keluarbiaya: keluarbiaya ?? this.keluarbiaya,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      updateStatusSuccess: updateStatusSuccess ?? this.updateStatusSuccess,
      deleting: deleting ?? this.deleting,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }

  String? errorText(String field) {
    return validationError?.firstError(field);
  }

  @override
  List<Object?> get props => [
    dkeluarbiayas,
    itemkegiatans,
    loading,
    loadingMore,
    refreshing,
    loadingKeluarbiaya,
    hasMore,
    offset,
    limit,
    total,
    keluarbiayaId,
    errorMessage,
    saving,
    saveSuccess,
    validationError,
    keluarbiaya,
    updatingStatus,
    updateStatusSuccess,
    deleting,
    deleteSuccess,
  ];
}
