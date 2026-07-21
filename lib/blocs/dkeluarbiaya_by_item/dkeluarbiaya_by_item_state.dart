import 'package:equatable/equatable.dart';

import 'package:newklikrkw/enums/date_filter_range.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';

class DkeluarbiayaByItemState extends Equatable {
  final List<Dkeluarbiaya> items;

  /// Pagination
  final int offset;
  final int limit;
  final bool hasMore;

  /// Operation State
  final bool loading;
  final bool loadingMore;
  final bool refreshing;

  /// Error
  final String? errorMessage;

  /// Filter
  final DateFilterRange selectedRange;

  /// digunakan jika range == custom
  final DateTime selectedDate;
  final DateTime? startDate;
  final DateTime? endDate;

  final int? selectedItemkegiatanId;

  final List<Itemkegiatan> itemkegiatans;

  const DkeluarbiayaByItemState({
    this.items = const [],

    this.offset = 0,
    this.limit = 20,
    this.hasMore = true,

    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,

    this.errorMessage,

    this.selectedRange = DateFilterRange.today,

    required this.selectedDate,
    this.startDate,
    this.endDate,

    this.selectedItemkegiatanId,
    this.itemkegiatans = const [],
  });

  factory DkeluarbiayaByItemState.initial() {
    return DkeluarbiayaByItemState(selectedDate: DateTime.now());
  }

  DkeluarbiayaByItemState copyWith({
    List<Dkeluarbiaya>? items,

    int? offset,
    int? limit,
    bool? hasMore,

    bool? loading,
    bool? loadingMore,
    bool? refreshing,

    String? errorMessage,
    bool clearError = false,

    DateFilterRange? selectedRange,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,

    int? selectedItemkegiatanId,
    bool clearSelectedItem = false,
    List<Itemkegiatan>? itemkegiatans,
  }) {
    return DkeluarbiayaByItemState(
      items: items ?? this.items,

      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,

      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),

      selectedRange: selectedRange ?? this.selectedRange,

      selectedDate: selectedDate ?? this.selectedDate,

      selectedItemkegiatanId: clearSelectedItem
          ? null
          : (selectedItemkegiatanId ?? this.selectedItemkegiatanId),

      itemkegiatans: itemkegiatans ?? this.itemkegiatans,

      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  ///==============================
  /// Computed Property
  ///==============================

  bool get isEmpty => items.isEmpty;

  bool get hasData => items.isNotEmpty;

  int get totalTransaksi => items.length;

  double get totalBiaya {
    return items.fold<double>(0, (total, item) => total + item.jumlahBiaya);
  }

  @override
  List<Object?> get props => [
    items,

    offset,
    limit,
    hasMore,

    loading,
    loadingMore,
    refreshing,

    errorMessage,

    selectedRange,
    selectedDate,
    selectedItemkegiatanId,
    itemkegiatans,

    startDate,
    endDate,
  ];
}
