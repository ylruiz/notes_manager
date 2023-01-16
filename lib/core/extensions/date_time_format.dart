import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  static final DateFormat startWithMonth = DateFormat('MMM dd, yyyy - hh:mm a');

  static String formatCurrentDate() {
    return startWithMonth.format(DateTime.now());
  }

  String formatStartWithMonth() {
    return startWithMonth.format(this).toUpperCase();
  }
}
