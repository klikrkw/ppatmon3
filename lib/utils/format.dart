import 'package:intl/intl.dart';

String toCamelCase(String input) {
  RegExp regex = RegExp(r'_([a-z])');

  String camelCase = input.replaceAllMapped(regex, (Match match) {
    return match[1]!
        .toUpperCase(); // Capitalizes the letter after the underscore
  });
  return camelCase;
}

String formatRupiah(dynamic angka) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCurrency.format(angka);
}

String formatToRupiah<t>(t angka) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCurrency.format(angka);
}

String formatDecimal(dynamic angka) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    decimalDigits: 0,
    symbol: '',
  );
  return formatCurrency.format(angka);
}

// Format Tanggal Indonesia (Contoh: 09 Juni 2026)
String formatDateTimeIndo({
  required String tanggal,
  String format = 'dd MMMM yyyy HH:mm',
}) {
  final date = DateFormat(format, 'id_ID').format(DateTime.parse(tanggal));
  return date;
}
