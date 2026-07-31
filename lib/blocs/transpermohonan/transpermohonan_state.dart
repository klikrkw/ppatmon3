import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/models/jenishak.dart';
import 'package:newklikrkw/models/jenispermohonan.dart';
import 'package:newklikrkw/models/transpermohonan_model.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/validation_error.dart';

const _unset = Object();

class TranspermohonanState extends Equatable {
  final List<Transpermohonan> items;
  final bool loading;
  final bool hasReachedMax;
  final String? error;
  final String? errorMessage;
  final String query;
  final bool? active;
  final int? userId;
  final String? transpermohonanId;
  final Transpermohonan? item;
  final Transpermohonan? transpermohonan;
  final TranspermohonanModel? transpermohonanModel;

  ///==============================
  /// MASTER
  ///==============================

  final List<Jenishak> jenishaks;

  final List<Jenispermohonan> jenispermohonans;

  final List<User> users;

  final List<Desa> desas;

  final bool loadingMasters;
  final bool loadingDetail;

  ///==============================
  /// SAVE
  ///==============================

  final bool saving;

  final bool saveSuccess;

  final ValidationError? validationError;
  const TranspermohonanState({
    this.items = const [],
    this.loading = false,
    this.hasReachedMax = false,
    this.error,
    this.query = '',
    this.active,
    this.userId,
    this.transpermohonanId,
    this.item,
    this.transpermohonan,
    this.errorMessage,
    this.transpermohonanModel,
    this.loadingDetail = false,

    ///==============================
    /// MASTER
    ///==============================
    this.jenishaks = const [],
    this.jenispermohonans = const [],
    this.users = const [],
    this.desas = const [],
    this.loadingMasters = false,

    ///==============================
    /// SAVE
    ///==============================
    this.saving = false,
    this.saveSuccess = false,
    this.validationError,
  });

  TranspermohonanState copyWith({
    List<Transpermohonan>? items,
    bool? loading,
    bool? hasReachedMax,
    String? error,
    String? errorMessage,
    String? query,
    bool? active,
    Object? userId = _unset,
    String? transpermohonanId,
    Object? item = _unset,
    Object? transpermohonan = _unset,
    List<Jenishak>? jenishaks,
    List<Jenispermohonan>? jenispermohonans,
    List<User>? users,
    List<Desa>? desas,
    bool? loadingMasters,
    bool? saving,
    bool? saveSuccess,
    bool? loadingDetail,
    ValidationError? validationError,
    Object? transpermohonanModel = _unset,
  }) {
    return TranspermohonanState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
      errorMessage: errorMessage,
      query: query ?? this.query,
      active: active ?? this.active,
      userId: userId == _unset ? this.userId : userId as int?,
      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
      item: item == _unset ? this.item : item as Transpermohonan?,
      transpermohonan: transpermohonan == _unset
          ? this.transpermohonan
          : transpermohonan as Transpermohonan?,
      transpermohonanModel: transpermohonanModel == _unset
          ? this.transpermohonanModel
          : transpermohonanModel as TranspermohonanModel?,

      jenishaks: jenishaks ?? this.jenishaks,

      jenispermohonans: jenispermohonans ?? this.jenispermohonans,

      users: users ?? this.users,

      desas: desas ?? this.desas,

      loadingMasters: loadingMasters ?? this.loadingMasters,

      saving: saving ?? this.saving,

      saveSuccess: saveSuccess ?? this.saveSuccess,

      validationError: validationError,

      loadingDetail: loadingDetail ?? this.loadingDetail,
    );
  }

  @override
  List<Object?> get props => [
    items,
    loading,
    hasReachedMax,
    error,
    active,
    userId,
    transpermohonanId,
    item,
    transpermohonan,
    query,
    jenishaks,
    jenispermohonans,
    users,
    desas,
    loadingMasters,
    saving,
    saveSuccess,
    validationError,
    errorMessage,
    transpermohonanModel,
    loadingDetail,
  ];
}
