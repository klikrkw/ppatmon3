import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/requests/add_transpermohonan_request.dart';

abstract class TranspermohonanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTranspermohonan extends TranspermohonanEvent {
  final int? userId;
  LoadTranspermohonan({this.userId});
}

class LoadMoreTranspermohonan extends TranspermohonanEvent {}

class RefreshTranspermohonan extends TranspermohonanEvent {}

class SearchTranspermohonan extends TranspermohonanEvent {
  final String query;

  SearchTranspermohonan(this.query);
}

class FilterActiveChanged extends TranspermohonanEvent {
  final bool active;

  FilterActiveChanged(this.active);
}

class UpdateStatusTranspermohonan extends TranspermohonanEvent {
  final String id;
  final bool active;

  UpdateStatusTranspermohonan({required this.id, required this.active});
}

class FilterUserId extends TranspermohonanEvent {
  final int? userId;

  FilterUserId(this.userId);
}

class FilterTranspermohonanId extends TranspermohonanEvent {
  final String? transpermohonanId;
  final bool isTranspermohonanId;

  FilterTranspermohonanId({
    this.transpermohonanId,
    this.isTranspermohonanId = false,
  });
}

class FilterQrCode extends TranspermohonanEvent {
  final String? transpermohonanId;
  final bool? isTranspermohonanId;

  FilterQrCode({this.transpermohonanId, this.isTranspermohonanId});
}

class ResetItem extends TranspermohonanEvent {}

class ResetFilterQrCode extends TranspermohonanEvent {}

///==============================
/// MASTER
///==============================

class LoadMasterTranspermohonan extends TranspermohonanEvent {
  LoadMasterTranspermohonan();
}

class LoadJenishaks extends TranspermohonanEvent {
  LoadJenishaks();
}

class LoadJenispermohonans extends TranspermohonanEvent {
  LoadJenispermohonans();
}

class LoadUsers extends TranspermohonanEvent {
  LoadUsers();
}

class LoadDesas extends TranspermohonanEvent {
  final String query;

  LoadDesas({this.query = ""});

  @override
  List<Object?> get props => [query];
}

class ResetValidationError extends TranspermohonanEvent {
  ResetValidationError();
}

class ResetSaveState extends TranspermohonanEvent {
  ResetSaveState();
}

class AddTranspermohonan extends TranspermohonanEvent {
  final AddTranspermohonanRequest request;

  AddTranspermohonan(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateTranspermohonan extends TranspermohonanEvent {
  final String id;
  final AddTranspermohonanRequest request;

  UpdateTranspermohonan({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class DetailTranspermohonan extends TranspermohonanEvent {
  final String id;

  DetailTranspermohonan(this.id);

  @override
  List<Object?> get props => [id];
}
