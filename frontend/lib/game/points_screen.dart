import 'package:flutter/material.dart';
import './inputs.dart';
import './start_screen.dart';

class PointsScreen extends StatelessWidget {
  final Map<String, Input> inputList;
  PointsScreen({required this.inputList});
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Score List',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 200.0, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: inputList
                            .length, // Replace with your actual item count
                        itemBuilder: (context, index) {
                          final word = inputList.keys.elementAt(index);
                          // final inputData = inputList[key];
                          return ListTile(
                            title: Text(word),
                            trailing: Text('${inputList[key]?.pointsData}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add your button onPressed logic here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                );
              },
              child: const Text('Replay'),
            ),
          ],
        ),
      ),
    );
  }
}
