class CurrencyParser {
  static double parse(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final text = value.toString().replaceAll(",", "");

    return double.tryParse(text) ?? 0;
  }
}
