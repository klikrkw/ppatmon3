import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/add_keluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/user.dart';

class KeluarbiayapermuserEvent extends Equatable {
  const KeluarbiayapermuserEvent();

  @override
  List<Object?> get props => [];
}

/// Load pertama
class LoadKeluarbiayapermusers extends KeluarbiayapermuserEvent {
  const LoadKeluarbiayapermusers();
}

/// Refresh
class RefreshKeluarbiayapermusers extends KeluarbiayapermuserEvent {
  const RefreshKeluarbiayapermusers();
}

/// Load berikutnya
class LoadMoreKeluarbiayapermusers extends KeluarbiayapermuserEvent {
  const LoadMoreKeluarbiayapermusers();
}

/// Load daftar user
class LoadUsers extends KeluarbiayapermuserEvent {
  const LoadUsers();
}

/// Load daftar status
class LoadStatusKeluarbiayapermusers extends KeluarbiayapermuserEvent {
  const LoadStatusKeluarbiayapermusers();
}

/// Filter user
class FilterUserKeluarbiayapermuser extends KeluarbiayapermuserEvent {
  // final int? userId;
  final User? user;
  // const FilterUserKeluarbiayapermuser(this.userId, this.user);
  const FilterUserKeluarbiayapermuser(this.user);

  @override
  List<Object?> get props => [user];
}

/// Filter status
class FilterStatusKeluarbiayapermuser extends KeluarbiayapermuserEvent {
  final String? status;

  const FilterStatusKeluarbiayapermuser(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadInstansis extends KeluarbiayapermuserEvent {
  final String? kasbonId;
  const LoadInstansis({this.kasbonId});

  @override
  List<Object?> get props => [kasbonId];
}

class LoadMetodebayars extends KeluarbiayapermuserEvent {
  const LoadMetodebayars();
}

class LoadRekenings extends KeluarbiayapermuserEvent {
  final int? metodebayarId;

  const LoadRekenings({this.metodebayarId});

  @override
  List<Object?> get props => [metodebayarId];
}

class LoadKasbons extends KeluarbiayapermuserEvent {
  final int? userId;
  const LoadKasbons({this.userId});
}

class ChangeMetodebayar extends KeluarbiayapermuserEvent {
  final Metodebayar metodebayar;

  const ChangeMetodebayar(this.metodebayar);

  @override
  List<Object?> get props => [metodebayar];
}

class AddKeluarbiayapermuser extends KeluarbiayapermuserEvent {
  final AddKeluarbiayapermuserRequest request;

  const AddKeluarbiayapermuser(this.request);

  @override
  List<Object?> get props => [request];
}

class ResetValidationError extends KeluarbiayapermuserEvent {
  const ResetValidationError();
}

class ResetSaveState extends KeluarbiayapermuserEvent {
  const ResetSaveState();
}

class ClearForm extends KeluarbiayapermuserEvent {
  const ClearForm();
}
