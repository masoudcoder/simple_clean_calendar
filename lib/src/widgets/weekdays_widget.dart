import 'package:flutter/material.dart';
import 'package:simple_clean_calendar/src/controllers/simple_calendar_controller.dart';
import 'package:simple_clean_calendar/src/utils/enums.dart';
import 'package:simple_clean_calendar/src/utils/extensions.dart';

class WeekdaysWidget extends StatelessWidget {
  final bool showWeekdays;
  final SimpleCalendarController simpleCalendarController;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;

  const WeekdaysWidget({
    Key? key,
    this.showWeekdays = true,
    required this.simpleCalendarController,
    required this.locale,
    required this.layout,
    required this.weekdayBuilder,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showWeekdays) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(DateTime.daysPerWeek, (index) {
        final weekDay = simpleCalendarController.getDaysOfWeek(locale)[index];

        if (weekdayBuilder != null) {
          return weekdayBuilder!(context, weekDay);
        }

        return <Layout, Widget Function()>{
          Layout.simple: () => _pattern(context, weekDay),
          Layout.beauty: () => _beauty(context, weekDay)
        }[layout]!();
      }),
    );
  }

  Widget _pattern(BuildContext context, String weekday) {
    return Center(
      child: Text(
        weekday.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }

  Widget _beauty(BuildContext context, String weekday) {
    return Center(
      child: Text(
        weekday.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}
