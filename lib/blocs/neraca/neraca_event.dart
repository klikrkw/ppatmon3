import 'package:equatable/equatable.dart';

abstract class NeracaEvent extends Equatable {
  const NeracaEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadNeraca extends NeracaEvent {
  const LoadNeraca();
}

/// Pull to Refresh
class RefreshNeraca extends NeracaEvent {
  const RefreshNeraca();
}

class RefreshNeracaPermohonan extends NeracaEvent {
  const RefreshNeracaPermohonan();
}

/// Ganti Tahun
class ChangeYear extends NeracaEvent {
  final int year;

  const ChangeYear(this.year);

  @override
  List<Object?> get props => [year];
}

class LoadNeracaPermohonan extends NeracaEvent {
  final String? transpermohonanId;
  const LoadNeracaPermohonan(this.transpermohonanId);
}
