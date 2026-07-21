import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/add_bayarbiayaperm_request.dart';

abstract class BayarbiayapermEvent extends Equatable {
  const BayarbiayapermEvent();

  @override
  List<Object?> get props => [];
}

/// Load Infinite List
class LoadBayarbiayaperms extends BayarbiayapermEvent {
  final bool refresh;

  const LoadBayarbiayaperms({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

/// Filter berdasarkan BiayaPerm
class FilterBayarbiayaperm extends BayarbiayapermEvent {
  final String? biayapermId;
  final String? query;

  const FilterBayarbiayaperm({this.biayapermId, this.query});

  @override
  List<Object?> get props => [biayapermId, query];
}

/// Add
class AddBayarbiayaperm extends BayarbiayapermEvent {
  final AddBayarbiayapermRequest request;

  const AddBayarbiayaperm(this.request);

  @override
  List<Object?> get props => [request];
}

// /// Update
class UpdateBayarbiayaperm extends BayarbiayapermEvent {
  final String id;
  final AddBayarbiayapermRequest request;

  const UpdateBayarbiayaperm({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

/// Delete
class DeleteBayarbiayaperm extends BayarbiayapermEvent {
  final String id;

  const DeleteBayarbiayaperm(this.id);

  @override
  List<Object?> get props => [id];
}

/// Reset Error Validasi Laravel
class ResetValidationError extends BayarbiayapermEvent {
  const ResetValidationError();
}

/// Reset Save Success
class ResetSaveState extends BayarbiayapermEvent {
  const ResetSaveState();
}

/// Bersihkan Form
class ClearBayarbiayapermForm extends BayarbiayapermEvent {
  const ClearBayarbiayapermForm();
}

class LoadRekening extends BayarbiayapermEvent {
  final int metodebayarId;

  const LoadRekening({required this.metodebayarId});

  @override
  List<Object?> get props => [metodebayarId];
}

class LoadMetodebayars extends BayarbiayapermEvent {
  const LoadMetodebayars();
}

class LoadRekenings extends BayarbiayapermEvent {
  final int? metodebayarId;

  const LoadRekenings({this.metodebayarId});

  @override
  List<Object?> get props => [metodebayarId];
}
