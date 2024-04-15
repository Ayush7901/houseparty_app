// import 'dart:async';
// import 'package:flutter/material.dart';

// class CountdownScreen extends StatefulWidget {
//   final Function finishCountDown;

//   const CountdownScreen({super.key, required this.finishCountDown});

//   @override
//   _CountdownScreenState createState() => _CountdownScreenState();
// }

// class _CountdownScreenState extends State<CountdownScreen> {
//   int count = 3;

//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//   }

//   void startCountdown() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (count > 0) {
//           count--;
//         } else {
//           timer.cancel();
//           // widget.finishCountDown();
//           // Navigate to the next screen after the countdown finishes
//           Navigator.pop(
//             context,
//             // MaterialPageRoute(builder: (context) => GameScreen()),
//           );
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Game Screen',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(

//         child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Get ready for the next lap in',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 48,
//                   fontWeight: FontWeight.bold,

//                 ),
//               ),
//               Text(
//                 count.toString(),
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontSize: 48,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/game/background.dart';

class Countdown extends StatefulWidget {
  final Function finishCountDown;
  const Countdown({super.key, required this.finishCountDown});
  @override
  State<Countdown> createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  int seconds = 3;

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          widget.finishCountDown();
        }
      });
    });
  }

  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          
          CircularProgressIndicator(
            value: 1 - seconds / 3,
            strokeWidth: 8,
            backgroundColor: Colors.greenAccent,
            // valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
          Center(
            child: Text(
              seconds.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w700),
            ),
          ),
        ]),
      ),
    );
  }
}
