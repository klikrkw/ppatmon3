import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/dkeluarbiayapermuser.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/models/validation_error.dart';

const _unset = Object();

class DkeluarbiayapermuserState extends Equatable {
  ///==============================
  /// LIST
  ///==============================
  final List<Dkeluarbiayapermuser> dkeluarbiayapermusers;

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
  final bool loadingKeluarbiayapermuser;

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
  final String keluarbiayapermuserId;
  final String transpermohonanId;

  ///==============================
  /// ERROR
  ///==============================
  final String? errorMessage;

  final bool saving;

  final bool saveSuccess;

  final ValidationError? validationError;
  final Keluarbiayapermuser? keluarbiayapermuser;
  final bool updatingStatus;
  final bool updateStatusSuccess;

  // deleting
  /// Delete
  final bool deleting;
  final bool deleteSuccess;

  const DkeluarbiayapermuserState({
    this.dkeluarbiayapermusers = const [],
    this.itemkegiatans = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.total = 0,
    this.keluarbiayapermuserId = '',
    this.transpermohonanId = '',
    this.errorMessage,
    this.saving = false,
    this.saveSuccess = false,
    this.validationError,
    this.keluarbiayapermuser,
    this.loadingKeluarbiayapermuser = false,
    this.updatingStatus = false,
    this.updateStatusSuccess = false,
    this.deleting = false,
    this.deleteSuccess = false,
  });

  factory DkeluarbiayapermuserState.initial() {
    return const DkeluarbiayapermuserState();
  }

  DkeluarbiayapermuserState copyWith({
    List<Dkeluarbiayapermuser>? dkeluarbiayapermusers,
    List<Itemkegiatan>? itemkegiatans,
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? hasMore,
    int? offset,
    int? limit,
    int? total,
    String? keluarbiayapermuserId,
    String? transpermohonanId,
    String? errorMessage,
    bool? saving,
    bool? saveSuccess,
    Object? validationError,
    Keluarbiayapermuser? keluarbiayapermuser,
    bool? loadingKeluarbiayapermuser,
    bool? updatingStatus,
    bool? updateStatusSuccess,
    bool? deleting,
    bool? deleteSuccess,
  }) {
    return DkeluarbiayapermuserState(
      dkeluarbiayapermusers:
          dkeluarbiayapermusers ?? this.dkeluarbiayapermusers,
      itemkegiatans: itemkegiatans ?? this.itemkegiatans,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      keluarbiayapermuserId:
          keluarbiayapermuserId ?? this.keluarbiayapermuserId,
      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
      errorMessage: errorMessage,
      saving: saving ?? this.saving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      validationError: identical(validationError, _unset)
          ? this.validationError
          : validationError as ValidationError?,
      keluarbiayapermuser: keluarbiayapermuser ?? this.keluarbiayapermuser,
      loadingKeluarbiayapermuser:
          loadingKeluarbiayapermuser ?? this.loadingKeluarbiayapermuser,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      updateStatusSuccess: updateStatusSuccess ?? this.updateStatusSuccess,
      deleting: deleting ?? this.deleting,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }

  String? errorText(String field) {
    // if (!validationError!.errors.containsKey(field)) {
    //   return null;
    // }
    if (validationError == null || validationError?.firstError(field) == null) {
      return null;
    }

    final errors = validationError!.firstError(field);

    if (errors == null) {
      return null;
    }

    return errors;
  }

  @override
  List<Object?> get props => [
    dkeluarbiayapermusers,
    itemkegiatans,
    loading,
    loadingMore,
    refreshing,
    hasMore,
    offset,
    limit,
    total,
    keluarbiayapermuserId,
    errorMessage,
    saving,
    saveSuccess,
    validationError,
    keluarbiayapermuser,
    loadingKeluarbiayapermuser,
    updatingStatus,
    updateStatusSuccess,
    deleting,
    deleteSuccess,
    transpermohonanId,
  ];
}
