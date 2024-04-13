import 'dart:math';
import 'package:flutter/material.dart';

class TimerArcPainter extends CustomPainter {
  final double timerPercentage;

  TimerArcPainter(this.timerPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    var radius = min(size.width, size.height) - 30;
    var paint = Paint()..color = const Color.fromARGB(255, 92, 194, 242);
    // print('TimerBG button Coordinates: ${size.width} ${size.height}');
    // print((1.0 - timerPercentage));
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.width, center.height),
        width: radius,
        height: radius,
      ),
      -pi / 2,
      2 * pi - timerPercentage,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerArcPainter oldDelegate) {
    return oldDelegate.timerPercentage != timerPercentage;
  }
}

class TimerArc extends StatefulWidget {
  final double timerPercentage; // Percentage of timer completed (0 to 1)

  TimerArc(this.timerPercentage);

  @override
  State<TimerArc> createState() => _TimerArcState();
}

class _TimerArcState extends State<TimerArc> {
  @override
  
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimerArcPainter(widget.timerPercentage),
      size: Size.infinite,
    );
  }
}
