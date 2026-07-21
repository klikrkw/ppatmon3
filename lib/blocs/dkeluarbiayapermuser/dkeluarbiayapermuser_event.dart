import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/add_dkeluarbiayapermuser_request.dart';

class LoadDkeluarbiayapermusers extends Equatable {
  final String keluarbiayapermuserId;

  const LoadDkeluarbiayapermusers(this.keluarbiayapermuserId);

  @override
  List<Object?> get props => [keluarbiayapermuserId];
}

class RefreshDkeluarbiayapermusers extends Equatable {
  const RefreshDkeluarbiayapermusers();

  @override
  List<Object?> get props => [];
}

class LoadMoreDkeluarbiayapermusers extends Equatable {
  const LoadMoreDkeluarbiayapermusers();

  @override
  List<Object?> get props => [];
}

class LoadItemkegiatans extends Equatable {
  const LoadItemkegiatans();

  @override
  List<Object?> get props => [];
}

class AddDkeluarbiayapermuser extends Equatable {
  final String keluarbiayapermuserId;
  final AddDKeluarbiayapermuserRequest request;

  const AddDkeluarbiayapermuser(
    this.request, {
    required this.keluarbiayapermuserId,
  });

  @override
  List<Object?> get props => [request];
}

class UpdateDkeluarbiayapermuser extends Equatable {
  final String id;
  final AddDKeluarbiayapermuserRequest request;

  const UpdateDkeluarbiayapermuser({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class ResetSaveState extends Equatable {
  const ResetSaveState();

  @override
  List<Object?> get props => [];
}

class ResetValidationError extends Equatable {
  const ResetValidationError();

  @override
  List<Object?> get props => [];
}

class ClearForm extends Equatable {
  const ClearForm();

  @override
  List<Object?> get props => [];
}

class GetKeluarbiaya extends Equatable {
  final String keluarbiayapermuserId;
  const GetKeluarbiaya(this.keluarbiayapermuserId);

  @override
  List<Object?> get props => [keluarbiayapermuserId];
}

class UpdateStatusKeluarbiaya extends Equatable {
  final String keluarbiayapermuserId;
  final String status;

  const UpdateStatusKeluarbiaya({
    required this.keluarbiayapermuserId,
    required this.status,
  });

  @override
  List<Object?> get props => [keluarbiayapermuserId, status];
}

class ResetUpdateStatus extends Equatable {
  const ResetUpdateStatus();

  @override
  List<Object?> get props => [];
}

class DeleteDkeluarbiayapermuser extends Equatable {
  final String id;

  const DeleteDkeluarbiayapermuser(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetDeleteState extends Equatable {
  const ResetDeleteState();

  @override
  List<Object?> get props => [];
}

class FilterByTranspermohonanId extends Equatable {
  final String transpermohonanId;

  const FilterByTranspermohonanId(this.transpermohonanId);

  @override
  List<Object?> get props => [transpermohonanId];
}
