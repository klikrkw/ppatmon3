import 'package:newklikrkw/models/store_prosespermohonan_request.dart';

abstract class ProsespermohonanEvent {}

class LoadProsespermohonan extends ProsespermohonanEvent {
  final String? transpermohonanId;
  final int? statusprosespermId;
  final int? itemprosespermId;
  final String query;
  final bool? isTranspermohonanId;
  final int? userId;

  LoadProsespermohonan({
    this.transpermohonanId,
    this.query = '',
    this.statusprosespermId,
    this.itemprosespermId,
    this.isTranspermohonanId,
    this.userId,
  });
}

class LoadMoreProsespermohonan extends ProsespermohonanEvent {}

class SearchProsespermohonan extends ProsespermohonanEvent {
  final String query;

  SearchProsespermohonan(this.query);
}

class FilterStatusProsespermohonan extends ProsespermohonanEvent {
  final int? statusProsespermId;
  final int? itemProsespermId;
  final String? query;

  FilterStatusProsespermohonan(
    this.statusProsespermId,
    this.query,
    this.itemProsespermId,
  );
}

class FilterItemProsespermohonan extends ProsespermohonanEvent {
  final int? itemProsespermId;

  FilterItemProsespermohonan(this.itemProsespermId);
}

class FilterUserId extends ProsespermohonanEvent {
  final int? userId;

  FilterUserId(this.userId);
}

class StoreProsespermohonan extends ProsespermohonanEvent {
  final StoreProsespermohonanrequest request;
  StoreProsespermohonan(this.request);
}

class UpdateProsespermohonan extends ProsespermohonanEvent {
  final StoreProsespermohonanrequest request;
  UpdateProsespermohonan(this.request);
}

class NewProsespermohonan extends ProsespermohonanEvent {}

class LoadStatusOptions extends ProsespermohonanEvent {}

class ResetValidationError extends ProsespermohonanEvent {}
