import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int offset;
  final int limit;
  final int total;
  final bool hasMore;

  const Pagination({
    required this.offset,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      offset: json["offset"] ?? 0,
      limit: json["limit"] ?? 20,
      total: json["total"] ?? 0,
      hasMore: json["has_more"] ?? false,
    );
  }

  @override
  List<Object?> get props => [offset, limit, total, hasMore];
}
