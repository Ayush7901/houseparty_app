import 'dart:async';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  final Function finishCountDown;

  const CountdownScreen({super.key, required this.finishCountDown});


  
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int count = 3;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          timer.cancel();
          // widget.finishCountDown();
          // Navigate to the next screen after the countdown finishes
          Navigator.pop(
            context,
            // MaterialPageRoute(builder: (context) => GameScreen()),
          );
        }
      });
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
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Get ready for the next lap in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
