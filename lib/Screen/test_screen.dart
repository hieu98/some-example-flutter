import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.red[200],
            child: Text('Hê lô'),
            alignment: Alignment(0.0, 0.0),
          ),
        )
    );
  }
}
