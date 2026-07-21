import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiaya.dart';

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

  final Map<String, List<String>> validationErrors;
  final Keluarbiaya? keluarbiaya;
  final bool updatingStatus;
  final bool updateStatusSuccess;

  // deleting
  /// Delete
  final bool deleting;
  final bool deleteSuccess;

  const DkeluarbiayaState({
    this.dkeluarbiayas = const [],
    this.itemkegiatans = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.total = 0,
    this.keluarbiayaId = '',
    this.errorMessage,
    this.saving = false,
    this.saveSuccess = false,
    this.validationErrors = const {},
    this.keluarbiaya,
    this.loadingKeluarbiaya = false,
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
    bool? hasMore,
    int? offset,
    int? limit,
    int? total,
    String? keluarbiayaId,
    String? errorMessage,
    bool? saving,
    bool? saveSuccess,
    Map<String, List<String>>? validationErrors,
    Keluarbiaya? keluarbiaya,
    bool? loadingKeluarbiaya,
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
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      keluarbiayaId: keluarbiayaId ?? this.keluarbiayaId,
      errorMessage: errorMessage,
      saving: saving ?? this.saving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      validationErrors: validationErrors ?? this.validationErrors,
      keluarbiaya: keluarbiaya ?? this.keluarbiaya,
      loadingKeluarbiaya: loadingKeluarbiaya ?? this.loadingKeluarbiaya,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      updateStatusSuccess: updateStatusSuccess ?? this.updateStatusSuccess,
      deleting: deleting ?? this.deleting,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }

  String? errorText(String field) {
    if (!validationErrors.containsKey(field)) {
      return null;
    }

    final errors = validationErrors[field];

    if (errors == null || errors.isEmpty) {
      return null;
    }

    return errors.first;
  }

  @override
  List<Object?> get props => [
    dkeluarbiayas,
    itemkegiatans,
    loading,
    loadingMore,
    refreshing,
    hasMore,
    offset,
    limit,
    total,
    keluarbiayaId,
    errorMessage,
    saving,
    saveSuccess,
    validationErrors,
    keluarbiaya,
    loadingKeluarbiaya,
    updatingStatus,
    updateStatusSuccess,
    deleting,
    deleteSuccess,
  ];
}
