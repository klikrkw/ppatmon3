enum BukubesarFilterRange { today, thisWeek, thisMonth, thisYear, custom }

extension BukubesarFilterRangeExtension on BukubesarFilterRange {
  String get label {
    switch (this) {
      case BukubesarFilterRange.today:
        return "Hari Ini";

      case BukubesarFilterRange.thisWeek:
        return "Minggu Ini";

      case BukubesarFilterRange.thisMonth:
        return "Bulan Ini";

      case BukubesarFilterRange.thisYear:
        return "Tahun Ini";

      case BukubesarFilterRange.custom:
        return "Tanggal";
    }
  }
}
