import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_clean_calendar/simple_clean_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calendar',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fa'), // Persian
      ],
      locale: const Locale('en'), // Change `en` to `fa` to test Shamsi calendar
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final calendarController = SimpleCalendarController(
    onDayTapped: (date) {
      debugPrint('on day tapped is: $date');
    },
    onChangeMonthTapped: (sDate, eDate) {
      debugPrint('Start date is: $sDate and end date is: $eDate');
    },
    weekdayStart: DateTime.saturday,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SimpleCalendar(
          calendarController: calendarController,
          calendarCrossAxisSpacing: 0,
          locale: const Locale('en').languageCode, // Change `en` to `fa` to test Shamsi calendar
          daySelectedBackgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
