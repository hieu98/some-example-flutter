import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const Text("WELCOME",
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center),
                ),
                Image.asset('assets/rose.jpg'),
                const TextFieldContainer(
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'Your Email',
                        hintTextDirection: TextDirection.ltr,
                        border: InputBorder.none),
                  ),
                ),
                const TextFieldContainer(
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        hintText: 'Your Password',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(29)),
      child: child,
    );
  }
}
