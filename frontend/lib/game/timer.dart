import 'dart:async';
import 'package:flutter/material.dart';
import './inputs.dart';

class LapTimer extends StatefulWidget {
  final Function incrementLap;
  final Function getLapCounter;
  final Function setTimerPct;
  final Map<String, Input> inputList;
  final bool isCountdown;
  const LapTimer(
      {super.key,
      required this.incrementLap,
      required this.getLapCounter,
      required this.setTimerPct,
      required this.inputList,
      required this.isCountdown});

  @override
  State<LapTimer> createState() => _LapTimerState();
}

class _LapTimerState extends State<LapTimer> {
  // final interval = const Duration(seconds: 1);
  static const maxLapTime = 60;
  var timerMaxSeconds = maxLapTime;
  int currentSeconds = 0;
  String get timerText =>
      ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0');

  void startTimeout() {
    // var duration = Duration(milliseconds: milliseconds);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // print(timer.tick);
        // print(widget.isCountdown);
        // if (widget.isCountdown) {
        //   timer.cancel();
        // }
        currentSeconds = timer.tick;
        if (currentSeconds <= timerMaxSeconds) {
          widget.setTimerPct((timerMaxSeconds - currentSeconds) * 1.0);
        }
        if (timer.tick >= timerMaxSeconds) {
          if (widget.getLapCounter() == 3) {
            timer.cancel();
            Navigator.pushReplacementNamed(context, '/points-screen',
                arguments: {'inputList': widget.inputList});
          } else {
            widget.incrementLap();
            timerMaxSeconds += maxLapTime;
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
