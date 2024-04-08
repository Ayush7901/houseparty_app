import 'dart:math';
import 'package:flutter/material.dart';

class TimerArcPainter extends CustomPainter {
  final double timerPercentage;

  TimerArcPainter(this.timerPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    var paint = Paint()..color = const Color.fromARGB(255, 92, 194, 242);
    // print((1.0 - timerPercentage));
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.width, center.height),
        width: 320,
        height: 320,
      ),
      -pi / 2,
      2 * pi - timerPercentage,
      true,
      paint,
    );
  }

  // void paint(Canvas canvas, Size size) {
  //   const double strokeWidth = 35;
  //   final double radius = (size.width - strokeWidth) / 2;
  //   final Offset center = Offset(size.width / 2, size.height / 2);

  //   final Paint paint = Paint()
  //     ..color = const Color.fromARGB(255, 92, 194, 242)
  //     ..style = PaintingStyle.fill; // Changed to fill to create a sector

  //   const double startAngle = -pi / 2; // Start angle (top center)
  //   final double sweepAngle =
  //       2 * pi * timerPercentage; // Sweep angle based on timer percentage

  //   final Path path = Path();
  //   path.moveTo(center.dx, center.dy); // Move to the center
  //   path.lineTo(center.dx + radius * cos(startAngle),
  //       center.dy + radius * sin(startAngle)); // Move to the start point
  //   path.arcTo(Rect.fromCircle(center: center, radius: radius), startAngle,
  //       sweepAngle, true); // Draw the arc
  //   path.close(); // Close the path to complete the sector
  //   canvas.drawPath(path, paint); // Draw the sector
  // }

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
