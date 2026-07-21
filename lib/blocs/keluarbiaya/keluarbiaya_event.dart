import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/add_keluarbiaya_request.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/user.dart';

class KeluarbiayaEvent extends Equatable {
  const KeluarbiayaEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadKeluarbiayas extends KeluarbiayaEvent {
  const LoadKeluarbiayas();
}

/// Refresh
class RefreshKeluarbiayas extends KeluarbiayaEvent {
  const RefreshKeluarbiayas();
}

/// Load berikutnya
class LoadMoreKeluarbiayas extends KeluarbiayaEvent {
  const LoadMoreKeluarbiayas();
}

/// Load daftar user
class LoadUsers extends KeluarbiayaEvent {
  const LoadUsers();
}

/// Load daftar status
class LoadStatusKeluarbiayas extends KeluarbiayaEvent {
  const LoadStatusKeluarbiayas();
}

/// Filter user
class FilterUserKeluarbiaya extends KeluarbiayaEvent {
  // final int? userId;
  final User? user;
  // const FilterUserKeluarbiaya(this.userId, this.user);
  const FilterUserKeluarbiaya(this.user);

  @override
  List<Object?> get props => [user];
}

/// Filter status
class FilterStatusKeluarbiaya extends KeluarbiayaEvent {
  final String? status;

  const FilterStatusKeluarbiaya(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadInstansis extends KeluarbiayaEvent {
  final String? kasbonId;
  const LoadInstansis({this.kasbonId});

  @override
  List<Object?> get props => [kasbonId];
}

class LoadMetodebayars extends KeluarbiayaEvent {
  const LoadMetodebayars();
}

class LoadRekenings extends KeluarbiayaEvent {
  final int? metodebayarId;

  const LoadRekenings({this.metodebayarId});

  @override
  List<Object?> get props => [metodebayarId];
}

class LoadKasbons extends KeluarbiayaEvent {
  final int? userId;
  const LoadKasbons({this.userId});
}

class ChangeMetodebayar extends KeluarbiayaEvent {
  final Metodebayar metodebayar;

  const ChangeMetodebayar(this.metodebayar);

  @override
  List<Object?> get props => [metodebayar];
}

class AddKeluarbiaya extends KeluarbiayaEvent {
  final AddKeluarbiayaRequest request;

  const AddKeluarbiaya(this.request);

  @override
  List<Object?> get props => [request];
}

class ResetValidationError extends KeluarbiayaEvent {
  const ResetValidationError();
}

class ResetSaveState extends KeluarbiayaEvent {
  const ResetSaveState();
}

class ClearForm extends KeluarbiayaEvent {
  const ClearForm();
}
