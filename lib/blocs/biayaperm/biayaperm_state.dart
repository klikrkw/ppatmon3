part of 'biayaperm_bloc.dart';

const _unset = Object();

enum StatusBiayas { all, lunas, belumLunas }

extension StatusBiayasExtension on StatusBiayas {
  String get label {
    switch (this) {
      case StatusBiayas.all:
        return "Semua";

      case StatusBiayas.lunas:
        return "Lunas";

      case StatusBiayas.belumLunas:
        return "Belum Lunas";
    }
  }

  IconData get icon {
    switch (this) {
      case StatusBiayas.all:
        return Icons.list_alt_rounded;

      case StatusBiayas.lunas:
        return Icons.check_circle;

      case StatusBiayas.belumLunas:
        return Icons.warning;
    }
  }
}

class BiayapermState {
  final bool loading;

  final bool hasReachedMax;

  final List<Biayaperm> items;
  final String? error;
  final Biayaperm? biayaperm;

  final String? transpermohonanId;
  final bool isTranspermohonanId;

  /// dropdown rincian biaya
  final List<Rincianbiayaperm> rincianBiayaperms;

  /// validation error dari Laravel
  final ValidationError? validationError;

  final bool saving;
  final bool saveSuccess;
  final StatusBiayas status;

  const BiayapermState({
    this.loading = false,
    this.hasReachedMax = false,
    this.items = const [],
    this.biayaperm,
    this.error,
    this.transpermohonanId,
    this.isTranspermohonanId = false,
    this.rincianBiayaperms = const [],
    this.validationError,
    this.saving = false,
    this.saveSuccess = false,
    this.status = StatusBiayas.all,
  });

  factory BiayapermState.initial() {
    return const BiayapermState();
  }

  BiayapermState copyWith({
    bool? loading,
    bool? hasReachedMax,
    List<Biayaperm>? items,
    Biayaperm? biayaperm,
    // String? error,
    // String? transpermohonanId,
    bool? isTranspermohonanId,
    bool? saving,
    Object? saveSuccess = _unset,
    List<Rincianbiayaperm>? rincianBiayaperms,
    Object? transpermohonanId = _unset,
    Object? error = _unset,
    Object? validationError = _unset,
    StatusBiayas? status,
  }) {
    return BiayapermState(
      loading: loading ?? this.loading,

      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isTranspermohonanId: isTranspermohonanId ?? this.isTranspermohonanId,

      items: items ?? this.items,
      saving: saving ?? this.saving,
      error: error == _unset ? this.error : error as String?,
      saveSuccess: saveSuccess == _unset
          ? this.saveSuccess
          : saveSuccess as bool,

      transpermohonanId: transpermohonanId == _unset
          ? this.transpermohonanId
          : transpermohonanId as String?,
      validationError: validationError == _unset
          ? this.validationError
          : validationError as ValidationError?,

      rincianBiayaperms: rincianBiayaperms ?? this.rincianBiayaperms,
      biayaperm: biayaperm ?? this.biayaperm,
      status: status ?? this.status,
    );
  }

  bool get isInitial => items.isEmpty && !loading && error == null;

  bool get hasError => error != null;

  bool get hasValidationError => validationError != null;

  bool get isEmpty => items.isEmpty;

  bool get hasData => items.isNotEmpty;
}
