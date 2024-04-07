import 'dart:math';

import 'package:flutter/material.dart';

class PositionedButton extends StatefulWidget {
  final double angle;
  final String text;
  final Function onSelected;
  final Function checkInputEvent;
  final bool isChecking;
  // final Function onUnSelected;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double fontSize;

  PositionedButton({
    required this.angle,
    required this.text,
    required this.onSelected,
    required this.checkInputEvent,
    required this.isChecking,
    // required this.onUnSelected,
    this.buttonColor = Colors.white, // Default button color
    this.textColor = Colors.blue, // Default text color
    this.buttonRadius = 35, // Default button radius
    this.fontSize = 40, // Default font size
  });

  @override
  _PositionedButtonState createState() => _PositionedButtonState();
}

class _PositionedButtonState extends State<PositionedButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 120; // Radius of the circle
    final double centerX = 190; // X coordinate of the circle center
    final double centerY = 210; // Y coordinate of the circle center
    final double buttonX =
        centerX + circleRadius * cos(widget.angle) - widget.buttonRadius;
    final double buttonY =
        centerY + circleRadius * sin(widget.angle) - widget.buttonRadius;
    return Positioned(
      left: buttonX,
      top: buttonY,
      child: ElevatedButton(
        onPressed: () {
          if (!isPressed) {
            setState(() {
              isPressed = true;
            });

            widget.onSelected(widget.text);
            widget.checkInputEvent();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor,
          shape: const CircleBorder(), // Make button circular
          elevation: 3, // Button elevation
          minimumSize: Size(widget.buttonRadius * 2, widget.buttonRadius * 2),
          side: BorderSide(
            color: isPressed ? Colors.orange : widget.textColor,
            width: isPressed ? 10 : 2,
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isPressed ? Colors.orange : widget.textColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
