import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/game/button_state.dart';

class PositionedButton extends StatefulWidget {
  final double angle;
  // final String text;
  final Function onSelected;
  final Function checkInputEvent;
  final Offset centerPoint;
  final bool isChecking;
  // final Function onUnSelected;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double fontSize;
  final ButtonState buttonState;

  PositionedButton({
    required this.angle,
    // required this.text,
    required this.onSelected,
    required this.checkInputEvent,
    required this.isChecking,
    // required this.onUnSelected,
    this.buttonColor = Colors.white, // Default button color
    this.textColor = Colors.blue, // Default text color
    this.buttonRadius = 70, // Default button radius
    this.fontSize = 40, // Default font size
    required this.buttonState,
    required this.centerPoint,
  });

  @override
  _PositionedButtonState createState() => _PositionedButtonState();
}

class _PositionedButtonState extends State<PositionedButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    double circleRadius = min(widget.centerPoint.dx, widget.centerPoint.dy); // Proportion of screen width for circle radius
    final double buttonRadius = widget.buttonRadius; // Proportion of screen width for button radius

    final double buttonX = widget.centerPoint.dx + circleRadius * cos(widget.angle) * 0.75 - buttonRadius/2;
    final double buttonY = widget.centerPoint.dy + circleRadius * sin(widget.angle) * 0.75 - buttonRadius/2;

    return Positioned(

      left: buttonX,
      top: buttonY,
      child: ElevatedButton(
        onPressed: widget.isChecking
            ? () {}
            : () {
                if (!widget.buttonState.isPressed) {
                  setState(() {
                    widget.buttonState.isPressed = true;
                  });

                  widget.onSelected(widget.buttonState.character);

                  widget.checkInputEvent();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor,
          shape: const CircleBorder(), // Make button circular
          elevation: 3, // Button elevation
          minimumSize: Size(widget.buttonRadius, widget.buttonRadius),
          side: BorderSide(
            color: widget.buttonState.correctState == -1
                ? (widget.buttonState.isPressed
                    ? Colors.orange
                    : widget.textColor)
                : (widget.buttonState.correctState == 1
                    ? Colors.green
                    : Colors.red),
            width: widget.buttonState.isPressed ? 10 : 2,
          ),
        ),
        child: Text(
          widget.buttonState.character,
          style: TextStyle(
            color: widget.buttonState.correctState == -1
                ? (widget.buttonState.isPressed
                    ? Colors.orange
                    : widget.textColor)
                : (widget.buttonState.correctState == 1
                    ? Colors.green
                    : Colors.red),
            fontSize: widget.fontSize, // Adjust font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
