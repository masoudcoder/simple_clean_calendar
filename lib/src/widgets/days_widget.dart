import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:simple_clean_calendar/src/controllers/simple_calendar_controller.dart';
import 'package:simple_clean_calendar/src/models/day_values_model.dart';
import 'package:simple_clean_calendar/src/utils/date_time.dart';
import 'package:simple_clean_calendar/src/utils/enums.dart';
import 'package:simple_clean_calendar/src/utils/extensions.dart';

class DaysWidget extends StatelessWidget {
  final SimpleCalendarController simpleCalendarController;
  final DateTime month;
  final Jalali jMonth;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final Layout? layout;
  final Widget Function(
    BuildContext context,
    DayValues values,
  )? dayBuilder;
  final Color? selectedBackgroundColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColorBetween;
  final Color? disableBackgroundColor;
  final Color? dayDisableColor;
  final double radius;
  final TextStyle? textStyle;
  final String locale;

  const DaysWidget(
      {Key? key,
      required this.month,
      required this.jMonth,
      required this.simpleCalendarController,
      required this.calendarCrossAxisSpacing,
      required this.calendarMainAxisSpacing,
      required this.layout,
      required this.dayBuilder,
      required this.selectedBackgroundColor,
      required this.backgroundColor,
      required this.selectedBackgroundColorBetween,
      required this.disableBackgroundColor,
      required this.dayDisableColor,
      required this.radius,
      required this.textStyle,
      required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start weekday - Days per week - The first weekday of this month
    // 7 - 7 - 1 = -1 = 1
    // 6 - 7 - 1 = -2 = 2

    // What it means? The first weekday does not change, but the start weekday have changed,
    // so in the layout we need to change where the calendar first day is going to start.

    final int moonStartWeekday;
    final int lengthOfMoon;
    final int controllerWeekDayStart;
    if (locale.contains(RegExp(r'^(fa|FA)$'))) {
      moonStartWeekday = jMonth.withDay(1).weekDay;
      lengthOfMoon = jMonth.monthLength;
      controllerWeekDayStart = simpleCalendarController.jWeekdayStart;
    } else {
      moonStartWeekday = DateTime(month.year, month.month).weekday;
      lengthOfMoon = DateTime(month.year, month.month + 1, 0).day;
      controllerWeekDayStart = simpleCalendarController.weekdayStart;
    }

    int monthPositionStartDay =
        (controllerWeekDayStart - DateTime.daysPerWeek - moonStartWeekday)
            .abs();

    monthPositionStartDay = monthPositionStartDay > DateTime.daysPerWeek
        ? monthPositionStartDay - DateTime.daysPerWeek
        : monthPositionStartDay;

    final start = monthPositionStartDay == 7 ? 0 : monthPositionStartDay;

    // If the monthPositionStartDay is equal to 7, then in this layout logic will cause a trouble, because it will
    // have a line in blank and in this case 7 is the same as 0.

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      physics: const NeverScrollableScrollPhysics(),
      addRepaintBoundaries: false,
      padding: EdgeInsets.zero,
      crossAxisSpacing: calendarCrossAxisSpacing,
      mainAxisSpacing: calendarMainAxisSpacing,
      shrinkWrap: true,
      children: List.generate(lengthOfMoon + start, (index) {
        if (index < start) return const SizedBox.shrink();
        var gDay = month;
        var jDay = jMonth;
        final text = (index + 1 - start).toString();

        DateTime daySelected = month;

        bool isSelected = false;

        if (locale.contains(RegExp(r'^(fa|FA)$'))) {
          jDay = jMonth.withDay(index + 1 - start);
          isSelected = jDay.toDateTime().isSameDay(DateTimeUtils.todayZeroHour)
              ? true
              : false;
          daySelected = jDay.toDateTime();
        } else {
          gDay = DateTime(month.year, month.month, (index + 1 - start));
          isSelected =
              gDay.isSameDay(DateTimeUtils.todayZeroHour) ? true : false;
          daySelected = gDay;
        }

        if (simpleCalendarController.selectedDay != null) {
          isSelected = daySelected
              .isAtSameMomentAs(simpleCalendarController.selectedDay!);
        }

        Widget widget;

        final dayValues = DayValues(
          day: daySelected,
          jDay: jDay,
          isFirstDayOfWeek:
              gDay.weekday == simpleCalendarController.weekdayStart,
          isLastDayOfWeek: gDay.weekday == simpleCalendarController.weekdayEnd,
          isSelected: isSelected,
          text: text,
          selectedMaxDate: daySelected,
          selectedMinDate:
              daySelected, //TODO: simpleCalendarController.rangeMinDate - handle range selected date
        );

        if (dayBuilder != null) {
          widget = dayBuilder!(context, dayValues);
        } else {
          widget = <Layout, Widget Function()>{
            Layout.simple: () => _pattern(context, dayValues),
            Layout.beauty: () => _beauty(context, dayValues),
          }[layout]!();
        }

        return GestureDetector(
          onTap: () {
            if (!simpleCalendarController.readOnly) {
              simpleCalendarController.onDayClick(daySelected);
            }
          },
          child: widget,
        );
      }),
    );
  }

  Widget _pattern(BuildContext context, DayValues values) {
    Color bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    TextStyle txtStyle =
        (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
      color: backgroundColor != null
          ? backgroundColor!.computeLuminance() > .5
              ? Colors.black
              : Colors.white
          : Theme.of(context).colorScheme.onSurface,
    );

    if (values.isSelected) {
      if ((values.selectedMinDate != null &&
              values.day.isSameDay(values.selectedMinDate!)) ||
          (values.selectedMaxDate != null &&
              values.day.isSameDay(values.selectedMaxDate!))) {
        bgColor =
            selectedBackgroundColor ?? Theme.of(context).colorScheme.primary;
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
          color: selectedBackgroundColor != null
              ? selectedBackgroundColor!.computeLuminance() > .5
                  ? Colors.black
                  : Colors.white
              : Theme.of(context).colorScheme.onPrimary,
        );
      } else {
        bgColor = selectedBackgroundColorBetween ??
            Theme.of(context).colorScheme.primary.withOpacity(.3);
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
          color: selectedBackgroundColor != null &&
                  selectedBackgroundColor == selectedBackgroundColorBetween
              ? selectedBackgroundColor!.computeLuminance() > .5
                  ? Colors.black
                  : Colors.white
              : selectedBackgroundColor ??
                  Theme.of(context).colorScheme.primary,
        );
      }
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: values.day.isSameDay(simpleCalendarController.gDate)
            ? Border.all(
                color: selectedBackgroundColor ??
                    Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Text(
        values.text,
        textAlign: TextAlign.center,
        style: txtStyle,
      ),
    );
  }

  Widget _beauty(BuildContext context, DayValues values) {
    BorderRadiusGeometry? borderRadius;
    Color bgColor = Colors.transparent;
    FontWeight? fontWeight;
    if (locale.contains(RegExp(r'^(fa|FA)$'))) {
      fontWeight = values.jDay.weekDay == 7 ? FontWeight.bold : null;
    } else {
      fontWeight = values.isFirstDayOfWeek || values.isLastDayOfWeek
          ? FontWeight.bold
          : null;
    }
    TextStyle txtStyle =
        (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
            color: backgroundColor != null
                ? backgroundColor!.computeLuminance() > .5
                    ? Colors.black
                    : Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: fontWeight);

    if (values.isSelected) {
      if (values.isFirstDayOfWeek) {
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
        );
      } else if (values.isLastDayOfWeek) {
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      }

      if ((values.selectedMinDate != null &&
              values.day.isSameDay(values.selectedMinDate!)) ||
          (values.selectedMaxDate != null &&
              values.day.isSameDay(values.selectedMaxDate!))) {
        bgColor =
            selectedBackgroundColor ?? Theme.of(context).colorScheme.primary;
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
          color: selectedBackgroundColor != null
              ? selectedBackgroundColor!.computeLuminance() > .5
                  ? Colors.black
                  : Colors.white
              : Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        );

        if (values.selectedMinDate == values.selectedMaxDate) {
          borderRadius = BorderRadius.circular(radius);
        } else if (values.selectedMinDate != null &&
            values.day.isSameDay(values.selectedMinDate!)) {
          borderRadius = BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          );
        } else if (values.selectedMaxDate != null &&
            values.day.isSameDay(values.selectedMaxDate!)) {
          borderRadius = BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          );
        }
      } else {
        bgColor = selectedBackgroundColorBetween ??
            Theme.of(context).colorScheme.primary.withOpacity(.3);
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyLarge)!.copyWith(
          color:
              selectedBackgroundColor ?? Theme.of(context).colorScheme.primary,
          fontWeight: values.isFirstDayOfWeek || values.isLastDayOfWeek
              ? FontWeight.bold
              : null,
        );
      }
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        values.text,
        textAlign: TextAlign.center,
        style: txtStyle,
      ),
    );
  }
}
