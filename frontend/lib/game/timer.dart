import 'dart:async';
import 'package:flutter/material.dart';
import './inputs.dart';
import './points_screen.dart';

class LapTimer extends StatefulWidget {
  final Function incrementLap;
  final Function getLapCounter;
  final Function setTimerPct;
  final Map<String, Input> inputList;
  const LapTimer(
      {super.key,
      required this.incrementLap,
      required this.getLapCounter,
      required this.setTimerPct,
      required this.inputList});

  @override
  State<LapTimer> createState() => _LapTimerState();
}

class _LapTimerState extends State<LapTimer> {
  // final interval = const Duration(seconds: 1);
  var timerMaxSeconds = 90;
  int currentSeconds = 0;
  String get timerText =>
      ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0');

  void startTimeout() {
    // var duration = Duration(milliseconds: milliseconds);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        widget.setTimerPct((timerMaxSeconds - currentSeconds) * 1.0);
        if (timer.tick >= timerMaxSeconds) {
          if (widget.getLapCounter() == 3) {
            timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PointsScreen(inputList: widget.inputList)),
            );
          } else {
            widget.incrementLap();
            timerMaxSeconds += 90;
          }
        }
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const Text('Timer'),
        const Icon(
          Icons.timer,
          size: 40,
          color: Colors.blue,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // const SizedBox(
            //   width: 5,
            // ),
            Text(timerText,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold))
          ],
        )
      ],
    );
  }
}
