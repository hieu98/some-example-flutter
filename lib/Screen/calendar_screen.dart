import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController? _calendarController;
  DateTime? _selectedDay;
  DateTime? _focusDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _calendarController?.selectedDate = DateTime.now();
    _calendarController?.displayDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2005),
                  lastDay: DateTime.utc(2055),
                selectedDayPredicate: (day){
                    return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusDay = focusedDay;
                    });
                }, 
                ),
            ],
          ),
        )
    );
  }
}
