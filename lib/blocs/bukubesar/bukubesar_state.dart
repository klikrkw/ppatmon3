import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/bukubesar.dart';
import 'package:newklikrkw/models/bukubesar_filter_range.dart';
import 'package:newklikrkw/models/kode_akun.dart';

class BukubesarState extends Equatable {
  final List<Bukubesar> items;

  final bool loading;
  final bool loadingMore;
  final bool refreshing;

  final bool hasReachedMax;

  final int offset;
  final int limit;

  final BukubesarFilterRange selectedRange;

  final DateTime? startDate;
  final DateTime? endDate;
  final List<KodeAkun> kodeAkuns;
  final int? selectedKodeAkun;

  final String? errorMessage;
  double get totalDebet => items.fold(0, (sum, e) => sum + e.debet);

  double get totalKredit => items.fold(0, (sum, e) => sum + e.kredit);

  double get saldoAkhir => items.isEmpty ? 0 : items.last.saldo;
  const BukubesarState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasReachedMax = false,
    this.offset = 0,
    this.limit = 20,
    this.selectedRange = BukubesarFilterRange.today,
    this.startDate,
    this.endDate,
    this.errorMessage,
    this.kodeAkuns = const [],
    this.selectedKodeAkun,
  });

  BukubesarState copyWith({
    List<Bukubesar>? items,
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? hasReachedMax,
    int? offset,
    int? limit,
    BukubesarFilterRange? selectedRange,
    DateTime? startDate,
    DateTime? endDate,
    String? errorMessage,
    List<KodeAkun>? kodeAkuns,
    int? selectedKodeAkun,
  }) {
    return BukubesarState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      selectedRange: selectedRange ?? this.selectedRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      errorMessage: errorMessage,
      kodeAkuns: kodeAkuns ?? this.kodeAkuns,
      selectedKodeAkun: selectedKodeAkun ?? this.selectedKodeAkun,
    );
  }

  @override
  List<Object?> get props => [
    items,
    loading,
    loadingMore,
    refreshing,
    hasReachedMax,
    offset,
    limit,
    selectedRange,
    startDate,
    endDate,
    errorMessage,
    kodeAkuns,
    selectedKodeAkun,
  ];
}
