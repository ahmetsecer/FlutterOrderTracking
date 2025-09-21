import 'package:intl/intl.dart';

class DateUtilsX {
  static String formatHuman(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} s önce';
    if (diff.inDays < 7) return '${diff.inDays} g önce';
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }
  static String formatDate(DateTime dt) => DateFormat('dd.MM.yyyy').format(dt);
}
