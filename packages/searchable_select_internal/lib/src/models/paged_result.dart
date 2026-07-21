class PagedResult<T> {
  final List<T> data;

  final bool hasMore;

  const PagedResult({
    required this.data,
    required this.hasMore,
  });
}
