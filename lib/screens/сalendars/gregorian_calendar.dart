import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class GregorianCalendar extends StatefulWidget {
  const GregorianCalendar({Key? key}) : super(key: key);

  @override
  _GregorianCalendarState createState() => _GregorianCalendarState();
}

class _GregorianCalendarState extends State<GregorianCalendar> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3EEE2),
     
      body: Container(
        decoration: mainScreenGradient,
        child: TableCalendar(
          calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blueAccent),
              isTodayHighlighted: true,
              selectedDecoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              selectedTextStyle: TextStyle(color: Colors.white)),
          daysOfWeekVisible: true,
          onDaySelected: (DateTime selecteDay, DateTime focuseDay) {
            setState(() {
              selectedDay = selecteDay;
              focusedDay = focuseDay;
            });
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: format,
          focusedDay: selectedDay,
          firstDay: DateTime(1988),
          lastDay: DateTime(2050),
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
        ),
      ),
    );
  }
}
