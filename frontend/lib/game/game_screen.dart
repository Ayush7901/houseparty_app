import 'dart:async';
import 'dart:math';
import 'package:dictionaryx/dictentry.dart';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import 'package:flutter/material.dart';
import './background.dart';
import './button_state.dart';
import './points.dart';
import './timer.dart';

import 'positioned_button.dart';

String generateRandomCharacter() {
  Random random = Random();
  String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  int index = random.nextInt(characters.length);
  return characters[index];
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // final List<String> buttonLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final List<ButtonState> buttonStateList = List<ButtonState>.generate(
    8,
    (index) => ButtonState(
      character: generateRandomCharacter(),
      isPressed: false,
      correctState: -1,
    ),
  );
  var lapCounter = 1;
  double timerPct = 0.0;
  bool isChecking = false;
  int textCorrectState = -1;
  Timer? _timer;
  String text = '';
  var dMSAJson = DictionaryMSAFlutter();
  int lastPressedTime = 0;
  int points = 0;

  Future<bool> lookupWord() async {
    bool isValid = await dMSAJson.hasEntry(text.toLowerCase());
    return isValid;
  }

  void resetInput() {
    setState(() {
      if (textCorrectState == 1) {
        points += text.length;
      }
      for (int i = 0; i < buttonStateList.length; i++) {
        buttonStateList[i].correctState = -1;
        buttonStateList[i].isPressed = false;
      }
      text = '';
      isChecking = false;

      textCorrectState = -1;
    });
  }

  void stateUpdate() async {
    isChecking = true;
    textCorrectState = (await lookupWord()) ? 1 : 0;
    for (int i = 0; i < buttonStateList.length; i++) {
      if (buttonStateList[i].isPressed) {
        buttonStateList[i].correctState = (textCorrectState == 1) ? 1 : 0;
      }
    }
  }

  void checkInputEvent() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 625), () async {
      setState(() {
        stateUpdate();
      });
      await Future.delayed(const Duration(milliseconds: 650));
      resetInput();
    });
  }

  void selected(String val) {
    setState(() {
      text += val;
    });
  }

  int getLapCounter() {
    return lapCounter;
  }

  void incrementLap() {
    setState(() {
      for (int i = 0; i < buttonStateList.length; i++) {
        buttonStateList[i].character = generateRandomCharacter();
      }
      lapCounter += 1;
    });
  }

  void setTimerPct(double timer) {
    setState(() {
      timerPct = (2 * pi * timer * 1.0) / 90.0;
      // print(timerPct);
      // lapCounter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Laps',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      Text('$lapCounter/3',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Points(points: points),
                  LapTimer(
                    incrementLap: incrementLap,
                    getLapCounter: getLapCounter,
                    setTimerPct: setTimerPct,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textCorrectState == -1
                            ? (Colors.blue)
                            : (textCorrectState == 1
                                ? Colors.green
                                : Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 15,
                          ),
                        ),
                      ),
                      // TimerArc(timerPct),
                      Positioned(
                        // Adjust position to center the arc
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: TimerArc(timerPct),
                      ),
                      for (int i = 0; i < buttonStateList.length; i++)
                        PositionedButton(
                            angle: (2 * pi * i) / buttonStateList.length,
                            buttonState: buttonStateList[i],
                            onSelected: selected,
                            checkInputEvent: checkInputEvent,
                            isChecking: isChecking),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
