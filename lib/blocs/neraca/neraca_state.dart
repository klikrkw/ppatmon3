import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/neraca.dart';

class NeracaState extends Equatable {
  final List<Neraca> items;

  final int selectedYear;

  final double totalDebet;
  final double totalKredit;

  final bool loading;
  final bool refreshing;

  final String? errorMessage;
  final String? transpermohonanId;

  const NeracaState({
    this.items = const [],
    required this.selectedYear,
    this.totalDebet = 0,
    this.totalKredit = 0,
    this.loading = false,
    this.refreshing = false,
    this.errorMessage,
    this.transpermohonanId,
  });

  factory NeracaState.initial() {
    return NeracaState(selectedYear: DateTime.now().year);
  }

  NeracaState copyWith({
    List<Neraca>? items,
    int? selectedYear,
    double? totalDebet,
    double? totalKredit,
    bool? loading,
    bool? refreshing,
    String? errorMessage,
    bool clearError = false,
    String? transpermohonanId,
  }) {
    return NeracaState(
      items: items ?? this.items,
      selectedYear: selectedYear ?? this.selectedYear,
      totalDebet: totalDebet ?? this.totalDebet,
      totalKredit: totalKredit ?? this.totalKredit,
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
    );
  }

  /// ==========================
  /// Computed Properties
  /// ==========================

  bool get isEmpty => items.isEmpty;

  bool get hasData => items.isNotEmpty;

  bool get isBalance => totalDebet == totalKredit;

  double get selisih => (totalDebet - totalKredit).abs();

  @override
  List<Object?> get props => [
    items,
    selectedYear,
    totalDebet,
    totalKredit,
    loading,
    refreshing,
    errorMessage,
    transpermohonanId,
  ];
}
