import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CurrencyHelper {
  static final formatter = CurrencyTextInputFormatter.currency(
    locale: 'id',
    decimalDigits: 0,
    symbol: '',
  );

  static double parse(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }
}
