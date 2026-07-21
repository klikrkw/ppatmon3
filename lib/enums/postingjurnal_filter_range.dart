enum PostingjurnalFilterRange { today, thisWeek, thisMonth, thisYear, custom }

extension PostingjurnalFilterRangeExtension on PostingjurnalFilterRange {
  String get label {
    switch (this) {
      case PostingjurnalFilterRange.today:
        return "Hari Ini";

      case PostingjurnalFilterRange.thisWeek:
        return "Minggu Ini";

      case PostingjurnalFilterRange.thisMonth:
        return "Bulan Ini";

      case PostingjurnalFilterRange.thisYear:
        return "Tahun Ini";

      case PostingjurnalFilterRange.custom:
        return "Periode";
    }
  }
}
