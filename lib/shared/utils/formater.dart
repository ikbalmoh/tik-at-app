import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CurrencyFormat {
  static String idr(
    dynamic number,
    int decimalDigit, {
    bool symbol = true,
    bool minus = false,
  }) {
    if (number is num) {
      if (number <= 0) {
        number = 0;
      }
      if (number % 1 == 0 && decimalDigit != 0) {
        decimalDigit = 0;
      }
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: symbol ? 'Rp' : '',
        decimalDigits: decimalDigit,
      );
      return '${minus == true && number > 0 ? '-' : ''}${currencyFormatter.format(number)}';
    }

    return number;
  }

  static num reverse(String formated,
      {int decimalDigit = 0, bool symbol = false}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: symbol ? 'Rp' : '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.parse(formated);
  }

  static CurrencyTextInputFormatter currencyInput() {
    return CurrencyTextInputFormatter.currency(
        locale: 'id', decimalDigits: 0, symbol: '');
  }
}
