abstract class DateTimeUtils {
  /// Today [DateTime] with zero time, eg. 2022/01/15
  static DateTime get todayZeroHour {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Specific [DateTime] with zero time, eg. 2022/01/15
  static DateTime dateZeroHour(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
