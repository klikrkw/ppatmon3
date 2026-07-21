import 'package:equatable/equatable.dart';

import 'package:newklikrkw/enums/date_filter_range.dart';

abstract class DkeluarbiayaByItemEvent extends Equatable {
  const DkeluarbiayaByItemEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadDkeluarbiayasByItem extends DkeluarbiayaByItemEvent {
  const LoadDkeluarbiayasByItem();
}

/// Pull To Refresh
class RefreshDkeluarbiayasByItem extends DkeluarbiayaByItemEvent {
  const RefreshDkeluarbiayasByItem();
}

/// Infinite Scroll
class LoadMoreDkeluarbiayasByItem extends DkeluarbiayaByItemEvent {
  const LoadMoreDkeluarbiayasByItem();
}

/// Ganti Filter Tanggal
class ChangeDateFilterRange extends DkeluarbiayaByItemEvent {
  final DateFilterRange range;

  const ChangeDateFilterRange(this.range);

  @override
  List<Object?> get props => [range];
}

/// Pilih Tanggal Custom
class ChangeCustomDate extends DkeluarbiayaByItemEvent {
  final DateTime date;

  const ChangeCustomDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Filter Item Kegiatan
class ChangeItemkegiatanFilter extends DkeluarbiayaByItemEvent {
  final int? itemkegiatanId;

  const ChangeItemkegiatanFilter(this.itemkegiatanId);

  @override
  List<Object?> get props => [itemkegiatanId];
}

/// Reset Semua Filter
class ResetFilterDkeluarbiayasByItem extends DkeluarbiayaByItemEvent {
  const ResetFilterDkeluarbiayasByItem();
}

class LoadItemkegiatans extends DkeluarbiayaByItemEvent {
  const LoadItemkegiatans();

  @override
  List<Object?> get props => [];
}

class ChangeCustomDateRange extends DkeluarbiayaByItemEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ChangeCustomDateRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
