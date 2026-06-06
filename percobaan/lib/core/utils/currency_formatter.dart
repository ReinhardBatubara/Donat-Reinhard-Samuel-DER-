import 'package:intl/intl.dart';

/// Utility untuk memformat angka menjadi format mata uang Rupiah
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Format angka menjadi string Rupiah
  /// Contoh: 15000 -> "Rp 15.000"
  static String format(int amount) {
    return _formatter.format(amount);
  }

  /// Format angka menjadi string Rupiah tanpa simbol
  static String formatNumber(int amount) {
    return NumberFormat('#,###', 'id_ID').format(amount);
  }
}
