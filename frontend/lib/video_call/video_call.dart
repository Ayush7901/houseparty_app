import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/common/button.dart';
import 'package:frontend/common/fallingLetter.dart';
import 'package:frontend/common/gradientButton.dart';
import 'package:frontend/game/game_screen.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:frontend/video_call/mediaTracks.dart';
import 'package:frontend/video_call/signalling_server.dart';
import 'package:provider/provider.dart';

class VideoCallScreen extends StatefulWidget {
  bool host;
  VideoCallScreen({Key? key, required this.host}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final socket = SignallingService.instance.socket;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<VideoCallProvider>(context, listen: false)
        ..initializeRenderers()
        ..startCall()
        ..listenToStartGame(context, widget.host);
    });
  }

  @override
  Widget build(BuildContext context) {
    String? roomId =
        Provider.of<VideoCallProvider>(context, listen: false).roomId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/create-meet");
          },
        ),
        // title: widget.host ? RoomCodeButton(roomCode: roomId!) : null,
        title: widget.host
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Room Code',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      roomId ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : null,
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Share this code to play with your friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            ),
            Expanded(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Remote Video View
                  SizedBox(
                    height: 150,
                    width: 200,
                    child: RTCVideoView(
                      Provider.of<VideoCallProvider>(context).remoteRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Space between video views and media track icons
                  // Local Video View
                  SizedBox(
                    height: 150,
                    width: 200,
                    child: RTCVideoView(
                      Provider.of<VideoCallProvider>(context).localRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                  SizedBox(height: 20,child:MediaTracks()), 
                  // MediaTracks(),
                ],
              )),
            ),
            // Expanded(
            //   child: Stack(
            //     children: [
            //       Center(
            //         child: Positioned(
            //           right: 20,
            //           bottom: 300,
            //           child: SizedBox(
            //             height: 150,
            //             width: 160,
            //             child: RTCVideoView(
            //               Provider.of<VideoCallProvider>(context)
            //                   .remoteRenderer,
            //               objectFit:
            //                   RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Center(
            //         child: Column(children: [
            //           Positioned(
            //             right: 40,
            //             bottom: 120,
            //             child: SizedBox(
            //               height: 150,
            //               width: 160,
            //               child: RTCVideoView(
            //                 Provider.of<VideoCallProvider>(context).localRenderer,
            //                 objectFit:
            //                     RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            //               ),
            //             ),
            //           ),
            //           Positioned(
            //             right: 40,
            //             bottom: 20,
            //             child: Container(
            //                 width: 140,
            //                 height: 50,
            //                 // Full width container for buttons
            //                 // padding: const EdgeInsets.symmetric(vertical: 12),
            //                 child: MediaTracks()),
            //           )
            //         ]),
            //       )
            //     ],
            //   ),
            // ),
            if (widget.host)
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GradientButton(
                    onPressed: () {
                      // Your onPressed action
                      Provider.of<VideoCallProvider>(context, listen: false)
                          .startGame(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(),
                        ),
                      );
                    },
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Start Game',
                          style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                  // child: ElevatedButton(
                  //   onPressed: () {
                  //     Provider.of<VideoCallProvider>(context, listen: false)
                  //         .startGame(context);
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => GameScreen(),
                  //       ),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color.fromARGB(255, 131, 78, 253),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 20.0, horizontal: 40.0),
                  //     elevation: 5.0,
                  //     textStyle: const TextStyle(
                  //       fontSize: 24.0,
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Start Game',
                  //     style: TextStyle(
                  //         color: Colors.white, fontFamily: 'BlackHanSans'),
                  //   ),
                  // ),
                  ),
          ],
        ),
      ),
    );
  }
}
