import 'package:equatable/equatable.dart';
import 'package:newklikrkw/enums/catatanperm_date_filter.dart';
import 'package:newklikrkw/models/requests/add_edit_catatanperm_request.dart';

abstract class CatatanpermEvent extends Equatable {
  const CatatanpermEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadCatatanperms extends CatatanpermEvent {
  final String? transpermohonanId;

  const LoadCatatanperms({this.transpermohonanId});

  @override
  List<Object?> get props => [transpermohonanId];
}

/// Load more
class LoadMoreCatatanperms extends CatatanpermEvent {
  const LoadMoreCatatanperms();
}

/// Refresh
class RefreshCatatanperms extends CatatanpermEvent {
  const RefreshCatatanperms();
}

/// Filter tanggal
class ChangeCatatanpermDateFilter extends CatatanpermEvent {
  final CatatanpermDateFilter filter;

  const ChangeCatatanpermDateFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Custom date
class ChangeCatatanpermCustomDate extends CatatanpermEvent {
  final DateTime date;

  const ChangeCatatanpermCustomDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Filter fieldcatatan
class ChangeCatatanpermFieldcatatanFilter extends CatatanpermEvent {
  final int? fieldcatatanId;

  const ChangeCatatanpermFieldcatatanFilter(this.fieldcatatanId);

  @override
  List<Object?> get props => [fieldcatatanId];
}

/// Search isi catatan
class SearchCatatanpermChanged extends CatatanpermEvent {
  final String keyword;

  const SearchCatatanpermChanged(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

/// Reset
class ResetCatatanpermFilter extends CatatanpermEvent {
  const ResetCatatanpermFilter();
}

class LoadFieldcatatans extends CatatanpermEvent {
  const LoadFieldcatatans();

  @override
  List<Object?> get props => [];
}

class AddCatatanperm extends CatatanpermEvent {
  final AddEditCatatanpermRequest request;

  const AddCatatanperm(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateCatatanperm extends CatatanpermEvent {
  final int id;
  final AddEditCatatanpermRequest request;

  const UpdateCatatanperm({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class ResetCatatanpermValidationError extends CatatanpermEvent {
  const ResetCatatanpermValidationError();

  @override
  List<Object?> get props => [];
}

class ResetCatatanpermSaveState extends CatatanpermEvent {
  const ResetCatatanpermSaveState();

  @override
  List<Object?> get props => [];
}

class DeleteCatatanperm extends CatatanpermEvent {
  final int id;

  const DeleteCatatanperm(this.id);

  @override
  List<Object> get props => [id];
}
