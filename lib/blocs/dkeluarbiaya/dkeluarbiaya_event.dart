import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/add_dkeluarbiaya_request.dart';

class LoadDkeluarbiayas extends Equatable {
  final String keluarbiayaId;

  const LoadDkeluarbiayas(this.keluarbiayaId);

  @override
  List<Object?> get props => [keluarbiayaId];
}

class RefreshDkeluarbiayas extends Equatable {
  const RefreshDkeluarbiayas();

  @override
  List<Object?> get props => [];
}

class LoadMoreDkeluarbiayas extends Equatable {
  const LoadMoreDkeluarbiayas();

  @override
  List<Object?> get props => [];
}

class LoadItemkegiatans extends Equatable {
  const LoadItemkegiatans();

  @override
  List<Object?> get props => [];
}

class AddDkeluarbiaya extends Equatable {
  final String keluarbiayaId;
  final AddDkeluarbiayaRequest request;

  const AddDkeluarbiaya(this.request, {required this.keluarbiayaId});

  @override
  List<Object?> get props => [request];
}

class UpdateDkeluarbiaya extends Equatable {
  final String id;
  final AddDkeluarbiayaRequest request;

  const UpdateDkeluarbiaya({required this.id, required this.request});

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
  final String keluarbiayaId;
  const GetKeluarbiaya(this.keluarbiayaId);

  @override
  List<Object?> get props => [keluarbiayaId];
}

class UpdateStatusKeluarbiaya extends Equatable {
  final String keluarbiayaId;
  final String status;

  const UpdateStatusKeluarbiaya({
    required this.keluarbiayaId,
    required this.status,
  });

  @override
  List<Object?> get props => [keluarbiayaId, status];
}

class ResetUpdateStatus extends Equatable {
  const ResetUpdateStatus();

  @override
  List<Object?> get props => [];
}

class DeleteDkeluarbiaya extends Equatable {
  final String id;

  const DeleteDkeluarbiaya(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetDeleteState extends Equatable {
  const ResetDeleteState();

  @override
  List<Object?> get props => [];
}
