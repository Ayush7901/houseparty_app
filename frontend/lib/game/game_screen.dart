import 'dart:async';
import 'dart:math';
// import 'package:dictionaryx/dictentry.dart';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import 'package:flutter/material.dart';
import './countdown_screen.dart';
import './inputs.dart';
import './background.dart';
import './button_state.dart';
import './points.dart';
import './timer.dart';

import 'positioned_button.dart';

// String generateRandomCharacter() {
//   Random random = Random();
//   String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//   int index = random.nextInt(characters.length);
//   return characters[index];
// }

// Function to generate a random vowel
String generateRandomVowel() {
  final vowels = ['A', 'E', 'I', 'O', 'U'];
  return vowels[Random().nextInt(vowels.length)];
}

// Function to generate a random consonant
String generateRandomConsonant() {
  final consonants = [
    'S',
    'T',
    'N',
    'R',
    'L',
    'D',
    'C',
    'M',
    'P',
    'G',
    'H',
    'B',
    'F',
    'V',
    'J',
    'Q',
    'X',
    'Z',
    'W',
    'Y'
  ];
  return consonants[Random().nextInt(consonants.length)];
}

List<ButtonState> generateRandomList() {
  List<String> letters = [];
  // Generate 4 vowels
  for (int i = 0; i < 4; i++) {
    letters.add(generateRandomVowel());
  }
  // Generate 2 common consonants
  for (int i = 0; i < 2; i++) {
    letters.add(generateRandomConsonant());
  }
  // Generate 2 less common consonants
  for (int i = 0; i < 2; i++) {
    letters.add(generateRandomConsonant());
  }
  // Shuffle the letters to make the distribution random
  letters.shuffle();
  final List<ButtonState> buttonStateList = List<ButtonState>.generate(
    8,
    (index) => ButtonState(
      character: letters[index],
      isPressed: false,
      correctState: -1,
    ),
  );
  return buttonStateList;
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  
  List<ButtonState> buttonStateList = generateRandomList();
  var lapCounter = 1;
  double timerPct = 2 * pi;
  bool isChecking = false;
  int textCorrectState = -1;
  Timer? _timer;
  String text = '';
  var dMSAJson = DictionaryMSAFlutter();
  int lastPressedTime = 0;
  int points = 0;
  bool isCountdown = false;
  Map<String, Input> inputList = {};

  void finishCountDown() {
    setState(() {
      isCountdown = false;
    });
  }

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
    if (text.length <= 1 || inputList.containsKey(text)) {
      resetInput();
    }
    textCorrectState = (await lookupWord()) ? 1 : 0;
    if (textCorrectState == 1) {
      inputList[text] = Input(text: text, points: text.length);
    }
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
      // for (int i = 0; i < buttonStateList.length; i++) {
      //   buttonStateList[i].character = generateRandomCharacter();
      // }
      buttonStateList = generateRandomList();
      lapCounter += 1;
      isCountdown = true;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           CountdownScreen(finishCountDown: finishCountDown)),
      // );
    });
  }

  void setTimerPct(double timer) {
    setState(() {
      timerPct = (2 * pi * timer * 1.0) / maxLapTime;
      // print(timerPct);
      // lapCounter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context).size;
    // print('GameScreen button Coordinates: ${MediaQuery.of(context).size.width} ${MediaQuery.of(context).size.width}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Screen',
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: 
      isCountdown
          ? Countdown(
              finishCountDown: finishCountDown,
            )
          : Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Laps',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Colors.blue,
                              ),
                            ),
                            Text('$lapCounter/3',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'BlackHanSans',))
                          ],
                        ),
                        Points(points: points),
                        LapTimer(
                          incrementLap: incrementLap,
                          getLapCounter: getLapCounter,
                          setTimerPct: setTimerPct,
                          inputList: inputList,
                          isCountdown: isCountdown,
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
                              fontFamily: 'BlackHanSans',
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
                    const SizedBox(height: 5),
                    Container(
                      height: sizeData.height * 0.54,
                      width: sizeData.width * 0.9,
                      margin: const EdgeInsets.all(2),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          // alignment: Alignment.center,
                          children: [
                            Container(
                              // height: double.infinity,
                              // width: double.infinity,
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
                                isChecking: isChecking,
                                centerPoint: Offset((sizeData.width * 0.9) / 2,
                                    (sizeData.height * 0.54) / 2),
                              ),
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
