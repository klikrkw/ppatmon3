import 'package:equatable/equatable.dart';

import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/models/pagination.dart';

class DkeluarbiayaByItemResponse extends Equatable {
  final List<Dkeluarbiaya> items;

  final Pagination pagination;

  const DkeluarbiayaByItemResponse({
    required this.items,
    required this.pagination,
  });

  factory DkeluarbiayaByItemResponse.fromJson(Map<String, dynamic> json) {
    return DkeluarbiayaByItemResponse(
      items: (json["data"] as List)
          .map((e) => Dkeluarbiaya.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
