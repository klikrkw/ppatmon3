import 'package:equatable/equatable.dart';

import 'package:newklikrkw/models/pagination.dart';
import 'postingjurnal.dart';

class PostingjurnalResponse extends Equatable {
  final List<Postingjurnal> items;

  final Pagination pagination;

  const PostingjurnalResponse({required this.items, required this.pagination});

  factory PostingjurnalResponse.fromJson(Map<String, dynamic> json) {
    return PostingjurnalResponse(
      items: (json["data"] as List)
          .map((e) => Postingjurnal.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
