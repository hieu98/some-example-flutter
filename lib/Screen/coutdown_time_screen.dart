import 'dart:async';

import 'package:flutter/material.dart';

class CoutdownTimeScreen extends StatefulWidget {
  const CoutdownTimeScreen({Key? key}) : super(key: key);

  @override
  State<CoutdownTimeScreen> createState() => _CoutdownTimeScreenState();
}

class _CoutdownTimeScreenState extends State<CoutdownTimeScreen> {
  Timer? timer;
  int _countedSeconds = 0;
  Duration timedDuration = Duration.zero;
  bool _timerRunning = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    _timerRunning = true;
    timer?.cancel();
    _countedSeconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countedSeconds++;
        timedDuration = Duration(seconds: _countedSeconds);
      });
    });
  }

  void stopTimer() {
    _timerRunning = false;
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    strokeWidth: 20,
                    value: _countedSeconds.remainder(60) / 60,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timedDuration.inMinutes.toString().padLeft(2, '0')),
                  Text(':'),
                  Text(timedDuration.inSeconds
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0')),
                  Text(':'),
                  Text(timedDuration.inMilliseconds
                      .remainder(1000)
                      .toString()
                      .padLeft(3, '0'))
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_timerRunning) {
              setState(() {
                stopTimer();
              });
            } else {
              setState(() {
                startTimer();
              });
            }
          },
          child: Text(_timerRunning ? 'Stop' : 'Go'),
        ),
      ),
    );
  }
}
