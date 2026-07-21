class SearchColumn {
  final String title;

  /// Lebar kolom
  final int flex;

  /// Alignment teks
  final bool numeric;

  const SearchColumn({
    required this.title,
    this.flex = 1,
    this.numeric = false,
  });
}
