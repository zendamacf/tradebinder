import 'package:intl/intl.dart';

class Utils {
  static final moneyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

  static String formatMoney(double? n) {
    if (n == null) return '';
    return moneyFormatter.format(n);
  }

  static double parseMoney(String s) {
    return moneyFormatter.parse(s) as double;
  }
}
