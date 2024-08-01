import 'package:flutter/material.dart';
import 'package:frontend/game/winner.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:frontend/state/pointsProvider.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:provider/provider.dart';
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
    final roomId =
        Provider.of<VideoCallProvider>(context, listen: false).roomId;
    final Map<String?, int>? overallPoints =
        Provider.of<PointsProvider>(context, listen: false).getPoints(roomId);

    String winner = "";
    String loser = "";
    int winnerPoints = 0;
    int loserPoints = 0;

    overallPoints!.forEach((key, value) {
      if (value > winnerPoints) {
        winner = key!;
        loser = winner;
        winnerPoints = value;
        loserPoints = winnerPoints;
      } else {
        loser = key!;
        loserPoints = value;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Result',
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Winner(
              winnerName: winner,
              winnerPoints: winnerPoints,
              opponentName: loser,
              opponentPoints: loserPoints),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(200), // Rounded edges
                            color: Colors.blue, // Container color
                          ),
                          child: const Center(
                            child: Text(
                              'Top Words',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'BlackHanSans',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 300.0, // Adjust the height as needed
                          child: ListView.builder(
                            itemCount: inputList.length,
                            itemBuilder: (context, index) {
                              final word = inputList.keys.elementAt(index);
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(word,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'OpenSans',
                                        )),
                                    trailing: Container(
                                      width: 45,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            200), // Rounded edges
                                        color: Colors.green, // Container color
                                      ),
                                      // padding: const EdgeInsets.all(5), // Add padding for inner spacing
                                      child: Center(
                                        child: Text(
                                          '${inputList[word]?.pointsData}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontFamily: 'BlackHanSans'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: Colors.grey,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                ],
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Button border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0), // Button padding
                    elevation: 5.0, // Button elevation
                    textStyle: const TextStyle(
                      fontSize: 24.0, // Button text size
                    ),
                  ),
                  child: const Text(
                    'Replay',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'BlackHanSans',
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
