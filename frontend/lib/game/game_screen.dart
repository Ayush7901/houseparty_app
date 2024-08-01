import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/game/background.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:frontend/video_call/mediaTracks.dart';
import './countdown_screen.dart';
import './inputs.dart';
import './button_state.dart';
import './points.dart';
import './timer.dart';
import 'positioned_button.dart';
import 'package:provider/provider.dart'; // Ensure you have imported provider package
import 'package:frontend/state/videoCallProvider.dart';
import 'package:http/http.dart' as http;
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';

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
  List<ButtonState> buttonStateList = [];
  var lapCounter = 1;
  double timerPct = 2 * pi;
  bool isChecking = false;
  int textCorrectState = -1;
  Timer? _timer;
  String text = '';
  int points = 0;
  bool isCountdown = false;
  var dMSAJson = DictionaryMSAFlutter();
  Map<String, Input> inputList = {};
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  @override
  initState() {
    super.initState();
    print("inside initState");
    fetchButtonData();
  }

  Future<void> fetchButtonData() async {
    final videoCallProvider =
        Provider.of<VideoCallProvider>(context, listen: false);
    String? roomId = videoCallProvider.roomId;
    print("Room id -> ${roomId}");
    final body = jsonEncode({"roomId": roomId, "roundNo": lapCounter - 1});
    try {
      final response = await http.post(
          Uri.parse('http://$ipAddress:35272/getGameButtons'),
          headers: headers,
          body: body);
      // print("Response -> ${jsonDecode(response.body)}");
      final Map responseData = Map.from((jsonDecode(response.body)));
      List<dynamic> dynamicList = responseData['buttonData']!;
      List<ButtonState> buttonData = dynamicList
          .map((item) => ButtonState.fromMap(item as Map<String, dynamic>))
          .toList();
      setState(() {
        buttonStateList = buttonData;
      });
    } catch (e) {
      print("Errorrrrr: ${e}");
    }
  }

  void finishCountDown() {
    setState(() {
      isCountdown = false;
    });
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
    // Mock function to check if word is valid
    textCorrectState =
        (await lookupWord()) ? 1 : 0; // Assume text is always valid for demo
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

  Future<bool> lookupWord() async {
    bool isValid = await dMSAJson.hasEntry(text.toLowerCase());
    return isValid;
  }

  // Future<void> storePoints(int currPoints) async {
  //   try {
  //     print("In store points");
  //     final videoCallProvider =
  //         Provider.of<VideoCallProvider>(context, listen: false);
  //     String? roomId = videoCallProvider.roomId;
  //     final email = Provider.of<PlayerProvider>(context, listen: false).email;
  //     final body =
  //         jsonEncode({"roomId": roomId, "points": currPoints, "email": email});
  //     await http.post(Uri.parse('http://$ipAddress:35272/storePoints'),
  //         headers: headers, body: body);
  //   } catch (e) {
  //     print("Errorrrrr: ${e}");
  //   }
  // }

  void incrementLap() async {
    // int currPoints = points;
    setState(() {
      lapCounter += 1;
      isCountdown = true;
    });
    print("lapCounter -> $lapCounter");
    await fetchButtonData();
    // await storePoints(currPoints);
  }

  void setTimerPct(double timer) {
    setState(() {
      timerPct = (2 * pi * timer * 1.0) / maxLapTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context).size;
    print("Size: $sizeData");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Screen',
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isCountdown
          ? Countdown(
              finishCountDown: finishCountDown,
            )
          : SingleChildScrollView(
            child: Center(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                    fontFamily: 'BlackHanSans',
                                  ))
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
                          child: Consumer<VideoCallProvider>(
                              builder: (context, videoCallProvider, child) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue,
                                            Colors.purple
                                          ], // Define your gradient colors here
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: sizeData.width * 0.42,
                                          color: Colors
                                              .transparent, // Border color can be set to transparent if you only want the gradient effect
                                        ),
                                      ),
                                    ),
            
                                    // Positioned(
                                    //   top: 10,
                                    //   right: 30,
                                    //   child: SizedBox(
                                    //     height: 100, // Adjust height as needed
                                    //     width: 120, // Adjust width as needed
                                    //     child: RTCVideoView(
                                    //       // Use provider to get remoteStream
                                    //       videoCallProvider.remoteRenderer!,
                                    //       objectFit: RTCVideoViewObjectFit
                                    //           .RTCVideoViewObjectFitCover,
                                    //     ),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //   top: 110,
                                    //   right: 30,
                                    //   child: SizedBox(
                                    //     height: 100, // Adjust height as needed
                                    //     width: 120, // Adjust width as needed
                                    //     child: RTCVideoView(
                                    //       // Use provider to get localStream
                                    //       videoCallProvider.localRenderer!,
                                    //       objectFit: RTCVideoViewObjectFit
                                    //           .RTCVideoViewObjectFitCover,
                                    //     ),
                                    //   ),
                                    // ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: TimerArc(timerPct),
                                    ),
                                    for (int i = 0;
                                        i < buttonStateList.length;
                                        i++)
                                      PositionedButton(
                                        angle:
                                            (2 * pi * i) / buttonStateList.length,
                                        buttonState: buttonStateList[i],
                                        onSelected: selected,
                                        checkInputEvent: checkInputEvent,
                                        isChecking: isChecking,
                                        centerPoint: Offset(
                                            (sizeData.width * 0.9) / 2,
                                            (sizeData.height * 0.40) / 2),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:5.0),
                                  child: Expanded(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(children: [
                                            SizedBox(
                                              height: 80,
                                              width: 100,
                                              child: RTCVideoView(
                                                Provider.of<VideoCallProvider>(
                                                        context)
                                                    .localRenderer,
                                                objectFit: RTCVideoViewObjectFit
                                                    .RTCVideoViewObjectFitCover,
                                              ),
                                            ),
                                            SizedBox(
                                                height: 10, child: MediaTracks()),
                                          ]),
                                          SizedBox(
                                            height: 80,
                                            width: 100,
                                            child: RTCVideoView(
                                              Provider.of<VideoCallProvider>(context)
                                                  .remoteRenderer,
                                              objectFit: RTCVideoViewObjectFit
                                                  .RTCVideoViewObjectFitCover,
                                            ),
                                          ),
                                          Column(children: [
                                            SizedBox(
                                              height: 80,
                                              width: 100,
                                              child: RTCVideoView(
                                                Provider.of<VideoCallProvider>(
                                                        context)
                                                    .localRenderer,
                                                objectFit: RTCVideoViewObjectFit
                                                    .RTCVideoViewObjectFitCover,
                                              ),
                                            ),
                                         
                                          ]),
                                        ]),
                                  ),
                                )
                              ],
                            );
                          }),
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
