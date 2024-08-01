// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoomCodeButton extends StatefulWidget {
  final String roomCode;
  const RoomCodeButton({
    Key? key,
    required this.roomCode,
  }) : super(key: key);
  @override
  State<RoomCodeButton> createState() => _RoomCodeButtonState();
}

class _RoomCodeButtonState extends State<RoomCodeButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          print('Room code button pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
       
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Room Code',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              widget.roomCode,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
