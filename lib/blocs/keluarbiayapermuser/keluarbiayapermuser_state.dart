import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/models/user.dart';

class KeluarbiayapermuserState extends Equatable {
  final bool loading;

  final bool loadingMore;

  final bool refreshing;

  final bool hasMore;

  final String? error;

  final List<Keluarbiayapermuser> keluarbiayapermusers;

  final List<User> users;

  final List<String> statusKeluarbiayapermusers;

  final int offset;

  final int limit;

  final int total;

  final User? selectedUser;

  final String? selectedStatus;

  ///==============================
  /// Master Dropdown
  ///==============================

  final List<Instansi> instansis;

  final List<Metodebayar> metodebayars;

  final List<Rekening> rekenings;

  final List<Kasbon> kasbons;

  ///==============================
  /// Selected Item
  ///==============================

  final Instansi? selectedInstansi;

  final Metodebayar? selectedMetodebayar;

  final Rekening? selectedRekening;

  final Kasbon? selectedKasbon;

  ///==============================
  /// Save State
  ///==============================

  final bool saving;

  final bool saveSuccess;

  ///==============================
  /// Validation Error
  ///==============================

  final Map<String, List<String>> validationErrors;

  const KeluarbiayapermuserState({
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasMore = true,
    this.error,
    this.keluarbiayapermusers = const [],
    this.users = const [],
    this.statusKeluarbiayapermusers = const [],
    this.offset = 0,
    this.limit = 20,
    this.total = 0,
    this.selectedUser,
    this.selectedStatus,

    /// Add Form
    this.instansis = const [],

    this.metodebayars = const [],

    this.rekenings = const [],

    this.kasbons = const [],

    this.selectedInstansi,

    this.selectedMetodebayar,

    this.selectedRekening,

    this.selectedKasbon,

    this.saving = false,

    this.saveSuccess = false,

    this.validationErrors = const {},
  });

  KeluarbiayapermuserState copyWith({
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? hasMore,
    String? error,
    List<Keluarbiayapermuser>? keluarbiayapermusers,
    List<User>? users,
    List<String>? statusKeluarbiayapermusers,
    int? offset,
    int? limit,
    int? total,
    User? selectedUser,
    String? selectedStatus,
    bool clearSelectedUser = false,
    bool clearSelectedStatus = false,
    List<Instansi>? instansis,

    List<Metodebayar>? metodebayars,

    List<Rekening>? rekenings,

    List<Kasbon>? kasbons,

    Instansi? selectedInstansi,

    Metodebayar? selectedMetodebayar,

    Rekening? selectedRekening,

    Kasbon? selectedKasbon,

    bool clearSelectedInstansi = false,

    bool clearSelectedMetodebayar = false,

    bool clearSelectedRekening = false,

    bool clearSelectedKasbon = false,

    bool? saving,

    bool? saveSuccess,

    Map<String, List<String>>? validationErrors,

    bool clearValidationErrors = false,
  }) {
    return KeluarbiayapermuserState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      keluarbiayapermusers: keluarbiayapermusers ?? this.keluarbiayapermusers,
      users: users ?? this.users,
      statusKeluarbiayapermusers:
          statusKeluarbiayapermusers ?? this.statusKeluarbiayapermusers,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      selectedUser: clearSelectedUser
          ? null
          : (selectedUser ?? this.selectedUser),
      selectedStatus: clearSelectedStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
      instansis: instansis ?? this.instansis,

      metodebayars: metodebayars ?? this.metodebayars,

      rekenings: rekenings ?? this.rekenings,

      kasbons: kasbons ?? this.kasbons,

      selectedInstansi: clearSelectedInstansi
          ? null
          : (selectedInstansi ?? this.selectedInstansi),

      selectedMetodebayar: clearSelectedMetodebayar
          ? null
          : (selectedMetodebayar ?? this.selectedMetodebayar),

      selectedRekening: clearSelectedRekening
          ? null
          : (selectedRekening ?? this.selectedRekening),

      selectedKasbon: clearSelectedKasbon
          ? null
          : (selectedKasbon ?? this.selectedKasbon),

      saving: saving ?? this.saving,

      saveSuccess: saveSuccess ?? this.saveSuccess,

      validationErrors: clearValidationErrors
          ? {}
          : (validationErrors ?? this.validationErrors),
    );
  }

  String? errorText(String key) {
    if (!validationErrors.containsKey(key)) {
      return null;
    }

    final errors = validationErrors[key];

    if (errors == null || errors.isEmpty) {
      return null;
    }

    return errors.first;
  }

  bool get isBusy {
    return loading || loadingMore || refreshing || saving;
  }

  bool get canLoadMore {
    return !loading && !loadingMore && hasMore;
  }

  bool get hasData => keluarbiayapermusers.isNotEmpty;
  bool get isEmpty => keluarbiayapermusers.isEmpty;

  @override
  List<Object?> get props => [
    loading,
    loadingMore,
    refreshing,
    hasMore,
    error,
    keluarbiayapermusers,
    users,
    statusKeluarbiayapermusers,
    offset,
    limit,
    total,
    selectedUser,
    selectedStatus,
    instansis,
    metodebayars,
    rekenings,
    kasbons,
    selectedInstansi,
    selectedMetodebayar,
    selectedRekening,
    selectedKasbon,
    saving,
    saveSuccess,
    validationErrors,
  ];
}
