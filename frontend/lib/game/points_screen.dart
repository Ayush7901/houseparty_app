import 'package:flutter/material.dart';
import './inputs.dart';

class PointsScreen extends StatelessWidget {
  final Map<String, Input> inputList;

  // Constructor to receive the inputList
  PointsScreen({required this.inputList});

  @override
  Widget build(BuildContext context) {
    // Extract arguments within the build method
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Map<String, Input> inputList =
        args['inputList'] as Map<String, Input>;

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
                    SizedBox(
                      height: 200.0, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: inputList.length,
                        itemBuilder: (context, index) {
                          final word = inputList.keys.elementAt(index);
                          return ListTile(
                            title: Text(word),
                            trailing: Text(
                              '${inputList[word]?.pointsData}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
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
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Replay'),
            ),
          ],
        ),
      ),
    );
  }
}
