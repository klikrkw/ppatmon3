import '../models/paged_result.dart';

typedef SearchRequest<T> = Future<PagedResult<T>> Function(
  String keyword,
  int page,
  int pageSize,
);
