import 'package:flutter/material.dart';

class Points extends StatelessWidget {
  const Points({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200), // Rounded edges
        color: Colors.blue, // Container color
      ),
      padding: const EdgeInsets.all(5), // Add padding for inner spacing
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Points',
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 18, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
          // SizedBox(height: 2), // Add spacing between texts
          Text(
            '100', // Replace with your points variable
            style: TextStyle(
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
