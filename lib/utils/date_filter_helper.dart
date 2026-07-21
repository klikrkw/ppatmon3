class DateFilterHelper {
  static DateTime firstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime lastDayOfWeek(DateTime date) {
    return firstDayOfWeek(date).add(const Duration(days: 6));
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
}
