enum DateFilterRange {
  today,
  lastSevenDays,
  thisWeek,
  thisMonth,
  thisYear,
  custom,
}

extension DateFilterRangeExtension on DateFilterRange {
  String get label {
    switch (this) {
      case DateFilterRange.today:
        return "Hari Ini";

      case DateFilterRange.lastSevenDays:
        return "7 Hari Terakhir";

      case DateFilterRange.thisWeek:
        return "Minggu Ini";

      case DateFilterRange.thisMonth:
        return "Bulan Ini";

      case DateFilterRange.thisYear:
        return "Tahun Ini";

      case DateFilterRange.custom:
        return "Tanggal";
    }
  }
}
