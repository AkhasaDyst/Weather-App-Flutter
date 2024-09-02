import 'package:intl/intl.dart';

String formatTimestamp(String timestamp) {
  DateTime dateTime = DateTime(
    int.parse(timestamp.substring(0, 4)),
    int.parse(timestamp.substring(4, 6)),
    int.parse(timestamp.substring(6, 8)),
    int.parse(timestamp.substring(8, 10)),
    int.parse(timestamp.substring(10, 12)),
    int.parse(timestamp.substring(12, 14)),
  );

  dateTime = dateTime.add(Duration(hours: 7));

  DateFormat dayFormatter = DateFormat.EEEE('id_ID');
  DateFormat dateFormatter = DateFormat('d MMMM', 'id_ID');
  DateFormat timeFormatter = DateFormat('HH:mm');

  return '${dayFormatter.format(dateTime)}, ${dateFormatter.format(dateTime)} ${timeFormatter.format(dateTime)}';
}

String formatTimestampContent(String timestamp) {
  DateTime dateTime = DateTime(
    int.parse(timestamp.substring(0, 4)),
    int.parse(timestamp.substring(4, 6)),
    int.parse(timestamp.substring(6, 8)),
    int.parse(timestamp.substring(8, 10)),
    int.parse(timestamp.substring(10, 12)),
  );

  dateTime = dateTime.add(Duration(hours: 7));

  DateFormat dayFormatter = DateFormat.EEEE('id_ID');
  DateFormat dateFormatter = DateFormat('d MMMM', 'id_ID');
  DateFormat timeFormatter = DateFormat('HH:mm');

  return '${dayFormatter.format(dateTime)}, ${dateFormatter.format(dateTime)} ${timeFormatter.format(dateTime)}';
}