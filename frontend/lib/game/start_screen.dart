import 'package:flutter/material.dart';
import './game_screen.dart';

class StartScreen extends StatelessWidget {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Add your button onPressed logic here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button border radius
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 40.0), // Button padding
              elevation: 5.0, // Button elevation
              textStyle: const TextStyle(
                fontSize: 24.0, // Button text size
              ),
            ),
            child: const Text(
              'Start Game',
              style: TextStyle(
                color: Colors.white,
              ),
            ), // Button text
          ),
        ),
      ),
    );
  }
}
