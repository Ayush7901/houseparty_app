import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/game/button_state.dart';

class PositionedButton extends StatefulWidget {
  final double angle;
  // final String text;
  final Function onSelected;
  final Function checkInputEvent;
  final bool isChecking;
  // final Function onUnSelected;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double fontSize;
  final ButtonState buttonState;

  PositionedButton(
      {required this.angle,
      // required this.text,
      required this.onSelected,
      required this.checkInputEvent,
      required this.isChecking,
      // required this.onUnSelected,
      this.buttonColor = Colors.white, // Default button color
      this.textColor = Colors.blue, // Default text color
      this.buttonRadius = 35, // Default button radius
      this.fontSize = 40, // Default font size
      required this.buttonState});

  @override
  _PositionedButtonState createState() => _PositionedButtonState();
}

class _PositionedButtonState extends State<PositionedButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // const double circleRadius = 120; // Radius of the circle
    // final double centerX = 175; // X coordinate of the circle center
    // final double centerY = 180; // Y coordinate of the circle center
    const double circleRadius =
        0.3; // Proportion of screen width for circle radius
    const double buttonRadius =
        0.09; // Proportion of screen width for button radius
    final double centerX = MediaQuery.of(context).size.width /
        2.3; // X coordinate of the circle center
    final double centerY = MediaQuery.of(context).size.height / 3.6; // Y coordinate of the circle center
    final double buttonX = centerX +
        circleRadius * MediaQuery.of(context).size.width * cos(widget.angle) -
        buttonRadius * MediaQuery.of(context).size.width;
    final double buttonY = centerY +
        circleRadius * MediaQuery.of(context).size.width * sin(widget.angle) -
        buttonRadius * MediaQuery.of(context).size.width;

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
          minimumSize: Size(buttonRadius * MediaQuery.of(context).size.width * 2, buttonRadius * MediaQuery.of(context).size.width * 2),
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
            fontSize: buttonRadius * MediaQuery.of(context).size.width * 2 * 0.7, // Adjust font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
