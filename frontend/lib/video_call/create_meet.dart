import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:frontend/state/pointsProvider.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:frontend/video_call/signalling_server.dart';
import 'package:frontend/video_call/video_call.dart';
import 'package:provider/provider.dart';

class CreateMeet extends StatefulWidget {
  @override
  State<CreateMeet> createState() => CreateMeetState();
}

class CreateMeetState extends State<CreateMeet> {
  String adminId = "";
  final socket = SignallingService.instance.socket;
  final TextEditingController _roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  String generateRandomCode(int length) {
    const String _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random _rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  void connectToServer() {
    socket!.on('error', (data) {
      // Handle error (e.g., room does not exist)
      print("Error: ${data['message']}");
    });

    socket!.on('offer', (data) {
      Map map = Map.from(data);
      dynamic offer = map['offer'];
      String code = _roomIdController.text;
      _roomIdController.clear();
      Provider.of<VideoCallProvider>(context, listen: false).updateOffer(offer);
      Provider.of<VideoCallProvider>(context, listen: false).updateRoomId(code);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(host: false),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String username =
        Provider.of<PlayerProvider>(context, listen: false).username!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color:Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/");
          },
        ),
        title: Center(
          child: Text(
            'Welcome $username',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600),
          ),
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
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Star decorations
        Positioned.fill(
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/stars.png', // Add your star pattern image in assets folder
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String roomId = generateRandomCode(6);
                    socket!.emit("createRoom", {"roomId": roomId});
                    Provider.of<VideoCallProvider>(context, listen: false)
                        .updateRoomId(roomId);
                    Provider.of<PointsProvider>(context, listen: false)
                        .setRoomId(roomId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VideoCallScreen(host: true)));
                  },
                  child: Center(
                      child: const Text('Create Room',
                          style: TextStyle(fontWeight: FontWeight.w500))),
                ),
                const SizedBox(height: 100),
                Container(
                  width: 200,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        12.0), // Rounded corners for Container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _roomIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Rounded corners for TextField
                        borderSide: BorderSide.none, // Remove the border
                      ),
                      labelText: 'Enter Room ID',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 123, 61, 204)),
                      filled: true,
                      fillColor: Colors.white, // Background color of TextField
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0), // Padding inside TextField
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    try {
                      // Handle join room action with the entered room ID
                      String roomId = _roomIdController.text;

                      socket!.emit("joinRoom", {
                        "roomId": roomId,
                      });
                      // print("Room -> $_roomIdController");
                      // _roomIdController.clear();
                      // print("Room -> $_roomIdController");
                    } catch (e) {
                      print("Error: ${e.toString()}");
                    }
                  },
                  child: Center(
                      child: const Text('Join Room',
                          style: TextStyle(fontWeight: FontWeight.w500))),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
