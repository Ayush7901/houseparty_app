import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Gradient gradient;

  GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Set background to transparent
          shadowColor: Colors.transparent, // Remove shadow
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: child,
      ),
    );
  }
}
