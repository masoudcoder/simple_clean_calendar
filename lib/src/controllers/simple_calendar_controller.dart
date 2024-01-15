import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:simple_clean_calendar/src/utils/date_time.dart';

class SimpleCalendarController extends ChangeNotifier {
  /// Not has been completed
  /// If the range is enabled
  // TODO: Handle rangeMode
  final bool rangeMode;

  /// If the calendar is readOnly
  final bool readOnly;

  /// In what weekday position the calendar is going to start
  final int weekdayStart;

  /// In what jalali weekday position the calendar is going to start
  final int jWeekdayStart;

  /// Function when a day is tapped
  final Function(DateTime date)? onDayTapped;

  /// Function when on change month tapped
  final Function(DateTime startDay, DateTime endDay)? onChangeMonthTapped;

  /// Function when a range is selected
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;

  /// An initial selected date
  final DateTime? initialDateSelected;

  /// The end of selected range
  final DateTime? endDateSelected;

  /// An initial focus date
  final DateTime? initialFocusDate;

  late ValueNotifier<DateTime> startGDateMonth;
  late ValueNotifier<Jalali> startJDateMonth;

  late int weekdayEnd;
  late Jalali jDate;
  late DateTime gDate;

  SimpleCalendarController({
    this.rangeMode = false,
    this.readOnly = false,
    this.endDateSelected,
    this.initialDateSelected,
    this.onDayTapped,
    this.onChangeMonthTapped,
    this.onRangeSelected,
    this.weekdayStart = DateTime.monday,
    this.jWeekdayStart = 1,
    this.initialFocusDate,
  })  : assert(weekdayStart <= DateTime.sunday),
        assert(weekdayStart >= DateTime.monday) {
    final x = weekdayStart - 1;
    weekdayEnd = x == 0 ? 7 : x;
    gDate = DateTimeUtils.todayZeroHour;
    jDate = Jalali.fromDateTime(gDate);
    startGDateMonth = ValueNotifier(gDate);
    startJDateMonth = ValueNotifier(jDate);
  }

  DateTime? rangeMinDate;
  DateTime? rangeMaxDate;
  DateTime? selectedDay;

  List<String> getDaysOfWeek([String locale = 'fa']) {
    var today = DateTimeUtils.todayZeroHour;
    final String weekDayFormat;

    while (today.weekday != weekdayStart) {
      today = today.subtract(const Duration(days: 1));
    }
    weekDayFormat = DateFormat.ABBR_WEEKDAY;
    final dateFormat = DateFormat(weekDayFormat, locale);
    final daysOfWeek = [
      dateFormat.format(today),
      dateFormat.format(today.add(const Duration(days: 1))),
      dateFormat.format(today.add(const Duration(days: 2))),
      dateFormat.format(today.add(const Duration(days: 3))),
      dateFormat.format(today.add(const Duration(days: 4))),
      dateFormat.format(today.add(const Duration(days: 5))),
      dateFormat.format(today.add(const Duration(days: 6)))
    ];

    return daysOfWeek;
  }

  void onDayClick(DateTime date, {bool update = true}) {
    selectedDay = date;
    if (update) {
      if (onDayTapped != null) {
        onDayTapped!(DateTimeUtils.dateZeroHour(date));
      }

      if (onRangeSelected != null) {
        onRangeSelected!(rangeMinDate!, rangeMaxDate);
      }
    }
    notifyListeners();
  }

  void clearSelectedDate() {
    selectedDay = null;
    notifyListeners();
  }

  void onNextMonthClick() {
    Jalali jFirstDayMonth = jDate.withDay(1);
    startJDateMonth.value = jFirstDayMonth.addMonths(1);
    jDate = startJDateMonth.value;
    startGDateMonth.value = DateTime(gDate.year, gDate.month + 1);
    gDate = startGDateMonth.value;
    if (onChangeMonthTapped != null) {
      onChangeMonthTapped!(
          jDate.toDateTime(), jDate.addMonths(1).addDays(-1).toDateTime());
    }
    notifyListeners();
  }

  void onPreviousMonthClick() {
    Jalali jFirstDayMonth = jDate.withDay(1);
    startJDateMonth.value = jFirstDayMonth.addMonths(-1);
    jDate = startJDateMonth.value;
    startGDateMonth.value = DateTime(gDate.year, gDate.month - 1);
    gDate = startGDateMonth.value;
    if (onChangeMonthTapped != null) {
      onChangeMonthTapped!(
          jDate.toDateTime(), jDate.addMonths(1).addDays(-1).toDateTime());
    }
    notifyListeners();
  }
}
