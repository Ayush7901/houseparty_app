
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import './background.dart';

class Countdown extends StatefulWidget {
  final Function finishCountDown;
  const Countdown({super.key, required this.finishCountDown});
  @override
  State<Countdown> createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  int seconds = 3;

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          widget.finishCountDown();
        }
      });
    });
  }

  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          
          CircularProgressIndicator(
            value: 1 - seconds / 3,
            strokeWidth: 8,
            backgroundColor: Colors.greenAccent,
            // valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
          Center(
            child: Text(
              seconds.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w700),
            ),
          ),
        ]),
      ),
    );
  }
}
