
import 'package:flutter/material.dart';
import 'package:flutter_app/Screen/calendar_screen.dart';
import 'package:flutter_app/Screen/permission_screen.dart';
import 'package:flutter_app/Screen/take_picture_screen.dart';
import 'package:flutter_app/Screen/coutdown_time_screen.dart';
import 'package:flutter_app/Screen/pick_image_gallery.dart';
import 'package:flutter_app/Screen/weather_screen.dart';
import 'package:flutter_app/Screen/welcome_screen.dart';
import 'Screen/qr_code_screen.dart';
import 'Screen/test_screen.dart';
import 'Screen/to_do_list_screen.dart';

Future<void> main() async{ runApp(MyApp());}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white
      ),
      home: CalendarScreen(),
    );
  }
}

