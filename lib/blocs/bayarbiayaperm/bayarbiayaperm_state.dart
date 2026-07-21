import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/bayarbiayaperm.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/models/validation_error.dart';

class BayarbiayapermState extends Equatable {
  static const _unset = Object();

  final List<Bayarbiayaperm> items;

  final bool loading;

  final bool saving;

  final bool hasReachedMax;

  final bool saveSuccess;

  final int offset;

  final int limit;

  final String? query;

  final String? biayapermId;

  final String? error;

  final ValidationError? validationError;
  final List<Metodebayar> metodebayars;
  final List<Rekening> rekenings;
  final bool loadingMetodebayar;
  final bool loadingRekening;

  final Metodebayar? selectedMetodebayar;
  final Rekening? selectedRekening;

  const BayarbiayapermState({
    this.items = const [],
    this.loading = false,
    this.saving = false,
    this.hasReachedMax = false,
    this.saveSuccess = false,
    this.offset = 0,
    this.limit = 20,
    this.query,
    this.biayapermId,
    this.error,
    this.validationError,
    this.metodebayars = const [],
    this.rekenings = const [],
    this.selectedMetodebayar,
    this.selectedRekening,
    this.loadingMetodebayar = false,
    this.loadingRekening = false,
  });

  factory BayarbiayapermState.initial() {
    return const BayarbiayapermState();
  }

  BayarbiayapermState copyWith({
    List<Bayarbiayaperm>? items,
    bool? loading,
    bool? saving,
    bool? hasReachedMax,
    bool? saveSuccess,
    int? offset,
    int? limit,
    Object? query = _unset,
    Object? biayapermId = _unset,
    Object? error = _unset,
    Object? validationError = _unset,
    List<Metodebayar>? metodebayars,
    List<Rekening>? rekenings,
    Metodebayar? selectedMetodebayar,
    Rekening? selectedRekening,
    bool? loadingMetodebayar,
    bool? loadingRekening,
  }) {
    return BayarbiayapermState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      query: identical(query, _unset) ? this.query : query as String?,
      biayapermId: identical(biayapermId, _unset)
          ? this.biayapermId
          : biayapermId as String?,
      error: identical(error, _unset) ? this.error : error as String?,
      validationError: identical(validationError, _unset)
          ? this.validationError
          : validationError as ValidationError?,
      metodebayars: metodebayars ?? this.metodebayars,
      rekenings: rekenings ?? this.rekenings,
      selectedMetodebayar: selectedMetodebayar ?? this.selectedMetodebayar,
      selectedRekening: selectedRekening ?? this.selectedRekening,
      loadingMetodebayar: loadingMetodebayar ?? this.loadingMetodebayar,
      loadingRekening: loadingRekening ?? this.loadingRekening,
    );
  }

  @override
  List<Object?> get props => [
    items,
    loading,
    saving,
    hasReachedMax,
    saveSuccess,
    offset,
    limit,
    query,
    biayapermId,
    error,
    validationError,
    metodebayars,
    rekenings,
    loadingMetodebayar,
    loadingRekening,
  ];
}
