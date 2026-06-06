import 'package:intl/intl.dart';

/// Utility untuk memformat DateTime ke string yang mudah dibaca
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');

  /// Format: "06 Juni 2025"
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format: "06 Jun 2025, 14:30"
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format: "14:30"
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format: "06/06/2025"
  static String formatShort(DateTime date) => _shortDateFormat.format(date);

  /// Hitung berapa lama dari sekarang
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return formatDate(date);
  }
}
