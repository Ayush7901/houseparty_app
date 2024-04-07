import 'dart:async';
import 'dart:math';
import 'package:dictionaryx/dictentry.dart';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import 'package:flutter/material.dart';


import 'positioned_button.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> buttonLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];


  bool isChecking = false;
  Timer? _timer;
  String text = '';

  var dMSAJson = DictionaryMSAFlutter();
  DictEntry _entry = DictEntry('', [], [], []);

  int lastPressedTime = 0;

  

   Future<bool> lookupWord() async {
    bool isValid = await dMSAJson.hasEntry(text.toLowerCase());
    return isValid;
   }


  void checkInputEvent(){
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 625), () async {
      bool check = await lookupWord();
      print(check);
    });
  }

  void selected(String val) {
    setState(() {
      text += val;
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Laps'),
                  Text('Points'),
                  Text('Timer'),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
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
                      for (int i = 0; i < buttonLabels.length; i++)
                        PositionedButton(
                          angle: (2 * pi * i) / buttonLabels.length,
                          text: buttonLabels[i],
                          onSelected: selected,
                          checkInputEvent:checkInputEvent,
                          isChecking: isChecking
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
