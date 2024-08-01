import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/game/button_state.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:frontend/state/pointsProvider.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:provider/provider.dart';
import './inputs.dart';

class LapTimer extends StatefulWidget {
  final Function incrementLap;
  final Function getLapCounter;
  final Function setTimerPct;
  final Map<String, Input> inputList;
  final bool isCountdown;
  const LapTimer({
    super.key,
    required this.incrementLap,
    required this.getLapCounter,
    required this.setTimerPct,
    required this.inputList,
    required this.isCountdown,
  });

  @override
  State<LapTimer> createState() => _LapTimerState();
}

class _LapTimerState extends State<LapTimer> {
  Timer? _timer;
  var timerMaxSeconds = maxLapTime;
  int currentSeconds = 0;

  String get timerText =>
      ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0');

  void startTimeout() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        currentSeconds = timer.tick;
        if (currentSeconds <= timerMaxSeconds) {
          widget.setTimerPct((timerMaxSeconds - currentSeconds) * 1.0);
        }
        if (timer.tick >= timerMaxSeconds) {
          if (widget.getLapCounter() == 3) {
            timer.cancel();
            int totalPoints = widget.inputList.values
                .fold(0, (sum, input) => sum + input.points);
            // String? email =
            //     Provider.of<PlayerProvider>(context, listen: false).email;
            // Provider.of<PointsProvider>(context, listen: false)
            //     .updatePoints(email, totalPoints);
            Navigator.pushReplacementNamed(
              context,
              '/points-screen',
              arguments: {'inputList': widget.inputList},
            );
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
    super.initState();
    startTimeout();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.timer,
          size: 40,
          color: Colors.blue,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(timerText,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontFamily: 'BlackHanSans',
                    fontWeight: FontWeight.bold))
          ],
        )
      ],
    );
  }
}
