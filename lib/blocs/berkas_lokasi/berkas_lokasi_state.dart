part of 'berkas_lokasi_bloc.dart';

class BerkasLokasiState {
  static const _unset = Object();
  final bool loading;
  final bool editing;

  final String? error;

  final Transpermohonan? transpermohonan;

  final Posisiberkas? posisiberkas;

  final Tempatberkas? selectedTempatberkas;

  final List<Tempatberkas> tempatberkases;

  final String? transpermohonanId;
  final bool updateSuccess;

  const BerkasLokasiState({
    this.loading = false,
    this.editing = false,
    this.updateSuccess = false,
    this.error,
    this.transpermohonan,
    this.posisiberkas,
    this.selectedTempatberkas,
    this.tempatberkases = const [],
    this.transpermohonanId,
  });

  BerkasLokasiState copyWith({
    bool? loading,
    bool? editing,
    bool? updateSuccess,
    String? error,
    Transpermohonan? transpermohonan,
    Posisiberkas? posisiberkas,
    Object? selectedTempatberkas,
    List<Tempatberkas>? tempatberkases,
    String? transpermohonanId,
  }) {
    return BerkasLokasiState(
      loading: loading ?? this.loading,
      editing: editing ?? this.editing,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      error: error,

      transpermohonan: transpermohonan ?? this.transpermohonan,

      posisiberkas: posisiberkas ?? this.posisiberkas,

      selectedTempatberkas: selectedTempatberkas == _unset
          ? this.selectedTempatberkas
          : selectedTempatberkas as Tempatberkas?,

      tempatberkases: tempatberkases ?? this.tempatberkases,

      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
    );
  }

  factory BerkasLokasiState.initial() {
    return const BerkasLokasiState();
  }
}
