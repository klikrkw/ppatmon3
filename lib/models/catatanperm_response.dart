import 'catatanperm.dart';

class CatatanpermResponse {
  final List<Catatanperm> items;
  final CatatanpermPagination pagination;

  const CatatanpermResponse({required this.items, required this.pagination});

  factory CatatanpermResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return CatatanpermResponse(
      items: data
          .map((e) => Catatanperm.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: CatatanpermPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CatatanpermPagination {
  final int offset;
  final int limit;
  final int total;
  final bool hasMore;

  const CatatanpermPagination({
    required this.offset,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  factory CatatanpermPagination.fromJson(Map<String, dynamic> json) {
    return CatatanpermPagination(
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      hasMore: json['has_more'] ?? false,
    );
  }
}
