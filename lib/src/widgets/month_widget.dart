import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:simple_clean_calendar/src/controllers/simple_calendar_controller.dart';
import 'package:simple_clean_calendar/src/utils/enums.dart';
import 'package:simple_clean_calendar/src/utils/extensions.dart';

class MonthWidget extends StatelessWidget {
  final DateTime month;
  final Jalali jMonth;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final SimpleCalendarController simpleCalendarController;
  final Widget Function(BuildContext context, String month)? monthBuilder;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.jMonth,
    required this.simpleCalendarController,
    required this.locale,
    required this.layout,
    required this.monthBuilder,
    required this.textStyle,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text =
        '${DateFormat('MMMM', locale).format(DateTime(month.year, month.month)).capitalize()} ${DateFormat('yyyy', locale).format(DateTime(month.year, month.month))}';
    final Future<String> monthTitle;
    if (locale.contains(RegExp(r'^(fa|FA)$'))) {
      monthTitle = Jalali(jMonth.year, jMonth.month)
          .toDateTime()
          .localizedTitleMMYY(LanguageCode.fa);
    } else {
      monthTitle =
          DateTime(month.year, month.month).localizedTitleMMYY(LanguageCode.en);
    }

    if (monthBuilder != null) {
      return monthBuilder!(context, text);
    }

    return <Layout, Widget Function()>{
      Layout.simple: () => _pattern(context, monthTitle),
      Layout.beauty: () => _beauty(context, monthTitle)
    }[layout]!();
  }

  Widget _pattern(BuildContext context, Future<String> monthTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: simpleCalendarController.onPreviousMonthClick,
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30.0,
            color: Colors.blueAccent,
          ),
        ),
        FutureBuilder(
            future: monthTitle,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              return Text(
                snapshot.requireData,
                textAlign: textAlign ?? TextAlign.center,
                style: textStyle ?? Theme.of(context).textTheme.titleLarge!,
              );
            }),
        IconButton(
          onPressed: simpleCalendarController.onNextMonthClick,
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 30.0,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _beauty(BuildContext context, Future<String> monthTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: simpleCalendarController.onPreviousMonthClick,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blueAccent,
          ),
        ),
        FutureBuilder(
          future: monthTitle,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            return Text(
              snapshot.requireData,
              textAlign: textAlign ?? TextAlign.center,
              style: textStyle ?? Theme.of(context).textTheme.titleLarge!,
            );
          },
        ),
        IconButton(
          onPressed: simpleCalendarController.onNextMonthClick,
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
