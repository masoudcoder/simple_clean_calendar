import 'package:shamsi_date/shamsi_date.dart';

class DayValues {
  /// The current day in layout
  final DateTime day;

  /// The current jalali day in layout
  final Jalali jDay;

  /// The text (day)
  final String text;

  /// If the item is select or not
  final bool isSelected;

  /// The first day in the row for each week
  final bool isFirstDayOfWeek;

  /// The last day in the row for each week, but just the item seven
  final bool isLastDayOfWeek;

  /// The min date selected
  /// If [rangeMode] is false the rangeMinDate is the date selected (don't use [rangeMaxDate])
  final DateTime? selectedMinDate;

  /// The max date selected
  final DateTime? selectedMaxDate;

  DayValues({
    required this.day,
    required this.jDay,
    required this.text,
    required this.isSelected,
    required this.isFirstDayOfWeek,
    required this.isLastDayOfWeek,
    this.selectedMinDate,
    this.selectedMaxDate,
  });
}
