part of 'biayaperm_bloc.dart';

abstract class BiayapermEvent {}

class LoadBiayaperms extends BiayapermEvent {
  final bool refresh;
  final bool isTranspermohonanId;

  LoadBiayaperms({this.refresh = false, this.isTranspermohonanId = false});
}

class FilterTranspermohonanBiayaperm extends BiayapermEvent {
  final String? transpermohonanId;
  final bool isTranspermohonanId;
  FilterTranspermohonanBiayaperm(
    this.transpermohonanId, {
    this.isTranspermohonanId = false,
  });
}

/// Load dropdown rincian biaya
class LoadRincianBiayaperm extends BiayapermEvent {
  final String transpermohonanId;
  LoadRincianBiayaperm(this.transpermohonanId);
}

/// Tambah data
class AddBiayaperm extends BiayapermEvent {
  final AddBiayapermRequest request;

  AddBiayaperm(this.request);
}

/// Update data
class UpdateBiayaperm extends BiayapermEvent {
  final String id;

  final AddBiayapermRequest request;

  UpdateBiayaperm({required this.id, required this.request});
}

/// Hapus error validasi
class ResetValidationError extends BiayapermEvent {
  ResetValidationError();
}

/// Reset save success
class ResetSaveState extends BiayapermEvent {
  ResetSaveState();
}

/// Hapus semua state form
class ClearBiayapermForm extends BiayapermEvent {
  ClearBiayapermForm();
}

class LoadBiayaperm extends BiayapermEvent {
  final String biayapermId;
  LoadBiayaperm(this.biayapermId);
}

class FilterStatusBiayaperm extends BiayapermEvent {
  final StatusBiayas status;
  FilterStatusBiayaperm(this.status);
}
