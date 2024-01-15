import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_clean_calendar/src/controllers/simple_calendar_controller.dart';
import 'package:simple_clean_calendar/src/models/day_values_model.dart';
import 'package:simple_clean_calendar/src/utils/enums.dart';
import 'package:simple_clean_calendar/src/utils/value_listenable_builder.dart';
import 'package:simple_clean_calendar/src/widgets/days_widget.dart';
import 'package:simple_clean_calendar/src/widgets/month_widget.dart';
import 'package:simple_clean_calendar/src/widgets/weekdays_widget.dart';

class SimpleCalendar extends StatefulWidget {
  /// The language locale
  final String locale;

  /// Scroll controller
  final ScrollController? scrollController;

  /// If is to show or not the weekdays in calendar
  final bool showWeekdays;

  /// `layout` has not been completed yet (we have two layouts with one style!).
  /// What layout (design) is going to be used
  // TODO: Handle layouts
  final Layout? layout;

  /// The space between month and calendar
  final double spaceBetweenMonthAndCalendar;

  /// The space between calendars
  final double spaceBetweenCalendars;

  /// The horizontal space in the calendar dates
  final double calendarCrossAxisSpacing;

  /// The vertical space in the calendar dates
  final double calendarMainAxisSpacing;

  /// The parent padding
  final EdgeInsets? padding;

  /// The label text style of month
  final TextStyle? monthTextStyle;

  /// The label text align of month
  final TextAlign? monthTextAlign;

  /// The label text align of month
  final TextStyle? weekdayTextStyle;

  /// The label text style of day
  final TextStyle? dayTextStyle;

  /// The day selected background color
  final Color? daySelectedBackgroundColor;

  /// The day background color
  final Color? dayBackgroundColor;

  /// The day selected background color that is between day selected edges
  final Color? daySelectedBackgroundColorBetween;

  /// The day disable background color
  final Color? dayDisableBackgroundColor;

  /// The day disable color
  final Color? dayDisableColor;

  /// The radius of day items
  final double dayRadius;

  /// A builder to make a customized month
  final Widget Function(BuildContext context, String month)? monthBuilder;

  /// A builder to make a customized weekday
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;

  /// A builder to make a customized day of calendar
  final Widget Function(BuildContext context, DayValues values)? dayBuilder;

  /// The controller of MonthCalendar
  final SimpleCalendarController calendarController;

  const SimpleCalendar({
    super.key,
    this.locale = 'fa',
    this.scrollController,
    this.showWeekdays = true,
    this.layout = Layout.beauty,
    this.calendarCrossAxisSpacing = 4,
    this.calendarMainAxisSpacing = 4,
    this.spaceBetweenCalendars = 24,
    this.spaceBetweenMonthAndCalendar = 24,
    this.padding,
    this.monthBuilder,
    this.weekdayBuilder,
    this.dayBuilder,
    this.monthTextAlign,
    this.monthTextStyle,
    this.weekdayTextStyle,
    this.daySelectedBackgroundColor,
    this.dayBackgroundColor,
    this.daySelectedBackgroundColorBetween,
    this.dayDisableBackgroundColor,
    this.dayDisableColor,
    this.dayTextStyle,
    this.dayRadius = 6,
    required this.calendarController,
  }) : assert(layout != null ||
            (monthBuilder != null &&
                weekdayBuilder != null &&
                dayBuilder != null));

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  @override
  void initState() {
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: childColumn(),
    );
  }

  Widget childColumn() {
    return ValueListenableBuilder2(
      first: widget.calendarController.startGDateMonth,
      second: widget.calendarController.startJDateMonth,
      builder: (context, gDate, jDate, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: MonthWidget(
                month: gDate,
                jMonth: jDate,
                simpleCalendarController: widget.calendarController,
                locale: widget.locale,
                layout: widget.layout,
                monthBuilder: widget.monthBuilder,
                textAlign: widget.monthTextAlign,
                textStyle: widget.monthTextStyle,
              ),
            ),
            SizedBox(height: widget.spaceBetweenMonthAndCalendar),
            Column(
              children: [
                WeekdaysWidget(
                  showWeekdays: widget.showWeekdays,
                  simpleCalendarController: widget.calendarController,
                  locale: widget.locale,
                  layout: widget.layout,
                  weekdayBuilder: widget.weekdayBuilder,
                  textStyle: widget.weekdayTextStyle,
                ),
                AnimatedBuilder(
                  animation: widget.calendarController,
                  builder: (_, __) {
                    return DaysWidget(
                      month: gDate,
                      jMonth: jDate,
                      simpleCalendarController: widget.calendarController,
                      calendarCrossAxisSpacing: widget.calendarCrossAxisSpacing,
                      calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                      layout: widget.layout,
                      dayBuilder: widget.dayBuilder,
                      backgroundColor: widget.dayBackgroundColor,
                      selectedBackgroundColor:
                          widget.daySelectedBackgroundColor,
                      selectedBackgroundColorBetween:
                          widget.daySelectedBackgroundColorBetween,
                      disableBackgroundColor: widget.dayDisableBackgroundColor,
                      dayDisableColor: widget.dayDisableColor,
                      radius: widget.dayRadius,
                      textStyle: widget.dayTextStyle,
                      locale: widget.locale,
                    );
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }
}
