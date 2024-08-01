import 'dart:math';
import 'package:flutter/material.dart';

class FallingLettersScreen extends StatefulWidget {
  @override
  _FallingLettersScreenState createState() => _FallingLettersScreenState();
}

class _FallingLettersScreenState extends State<FallingLettersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Letter> _letters = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _startAnimation();
  }

  void _startAnimation() {
    _letters.clear();
    for (int i = 0; i < 10; i++) {
      final letter = Letter(
        key: UniqueKey(),
        text: String.fromCharCode(Random().nextInt(26) + 65), // Random letter
        offset: Offset(
          Random().nextDouble() * MediaQuery.of(context).size.width,
          -50.0, // Start above the screen
        ),
        speed: Random().nextDouble() * 3 + 1, // Random speed
      );
      _letters.add(letter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Falling Letters')),
      body: Stack(
        children: _letters.map((letter) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double animationValue = _controller.value;
              return Positioned(
                left: letter.offset.dx,
                top: letter.offset.dy + letter.speed * animationValue * MediaQuery.of(context).size.height,
                child: Text(
                  letter.text,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Letter {
  final Key key;
  final String text;
  final Offset offset;
  final double speed;

  Letter({
    required this.key,
    required this.text,
    required this.offset,
    required this.speed,
  });
}
