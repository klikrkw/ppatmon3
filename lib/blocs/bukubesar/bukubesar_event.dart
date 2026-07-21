import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/bukubesar_filter_range.dart';

abstract class BukubesarEvent extends Equatable {
  const BukubesarEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadBukubesars extends BukubesarEvent {
  const LoadBukubesars();
}

/// Pull to refresh
class RefreshBukubesars extends BukubesarEvent {
  const RefreshBukubesars();
}

/// Infinite scroll
class LoadMoreBukubesars extends BukubesarEvent {
  const LoadMoreBukubesars();
}

/// Ganti filter
class ChangeFilterRange extends BukubesarEvent {
  final BukubesarFilterRange range;

  const ChangeFilterRange(this.range);

  @override
  List<Object?> get props => [range];
}

/// Custom tanggal
class ChangeCustomDateRange extends BukubesarEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ChangeCustomDateRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadKodeAkuns extends BukubesarEvent {
  const LoadKodeAkuns();
}

class ChangeKodeAkun extends BukubesarEvent {
  final int? akunId;

  const ChangeKodeAkun(this.akunId);

  @override
  List<Object?> get props => [akunId];
}
