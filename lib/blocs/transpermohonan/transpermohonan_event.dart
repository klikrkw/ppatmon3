import 'package:equatable/equatable.dart';

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
  final bool isTranspermohonanId;

  FilterQrCode({this.transpermohonanId, this.isTranspermohonanId = true});
}

class ResetItem extends TranspermohonanEvent {}

class ResetFilterQrCode extends TranspermohonanEvent {}
