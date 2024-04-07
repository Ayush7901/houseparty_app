import 'package:flutter/material.dart';

class Points extends StatelessWidget {
  final int points;
  const Points({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200), // Rounded edges
        color: Colors.blue, // Container color
      ),
      padding: const EdgeInsets.all(5), // Add padding for inner spacing
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Points',
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 18, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
          // SizedBox(height: 2), // Add spacing between texts
          Text(
            '$points', // Replace with your points variable
            style: const TextStyle(
              color: Colors.white, // Text color
              fontSize: 40, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
        ],
      ),
    );
  }
}
