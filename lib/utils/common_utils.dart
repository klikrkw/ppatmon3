import 'dart:math';

import 'package:intl/intl.dart';

class CommonUtils {
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$suffix';
  }

  static String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  static String formatDate(DateTime? date, {required String format}) {
    if (date == null) {
      return '-';
    }
    return DateFormat(
      format.isNotEmpty ? format : 'dd/MM/yyyy HH:mm',
    ).format(date);
  }
}
