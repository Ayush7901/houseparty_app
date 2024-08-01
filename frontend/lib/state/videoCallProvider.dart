import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/game/game_screen.dart';
import 'package:frontend/video_call/signalling_server.dart';
import 'dart:core';
// import 'dart:js' as js;

class VideoCallProvider extends ChangeNotifier {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  bool isHost = false;
  bool _isInCall = false;
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  dynamic offer;
  String? roomId;
  List<RTCIceCandidate> rtcIceCandidates = [];
  String player = "";
  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  RTCPeerConnection? get peerConnection => _peerConnection;
  bool get isInCall => _isInCall;
  final socket = SignallingService.instance.socket;

  void updateOffer(dynamic offer) {
    this.offer = offer;
  }

  void updateRoomId(String roomId) {
    this.roomId = roomId;
  }

  Future<void> initializeRenderers() async {
    print("Here in intialiseRenderes");
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> startCall() async {
    // Your existing code to start the call and set up the peer connection.
    // print("Here in startCall -> $roomId");

    _peerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
            // "turn: turn:192.168.1.4:3478",
            // Add TURN server for better connectivity
            // 'turn:your.turn.server:3478',
            // 'turn:your.turn.server:3478?transport=tcp',
          ],
          // 'username': 'vairak',
          // 'credential': 'abcd1234',
        }
      ]
    });
    // listen for remotePeer mediaTrack event
    _peerConnection!.onTrack = (event) {
      _remoteRenderer.srcObject = event.streams[0];
    };
    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });
    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
    // set source for local video renderer
    _localRenderer.srcObject = _localStream;

    // for Incoming call
    if (offer != null) {
      // listen for Remote IceCandidate
      socket!.on("candidate", (data) {
        String candidate = data["iceCandidate"]["candidate"];
        String sdpMid = data["iceCandidate"]["id"];
        int sdpMLineIndex = data["iceCandidate"]["label"];
        // add iceCandidate
        _peerConnection!.addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ));
      });
      // set SDP offer as remoteDescription for peerConnection
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer["sdp"], offer["type"]),
      );
      // create SDP answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      // set SDP answer as localDescription for peerConnection

      await _peerConnection!.setLocalDescription(answer);
      // send SDP answer to remote peer over signalling
      socket!.emit("answer", {
        "sdpAnswer": answer.toMap(),
      });
    }
    // for Outgoing Call
    else {
      // listen for local iceCandidate and add it to the list of IceCandidate
      _peerConnection!.onIceCandidate =
          (RTCIceCandidate candidate) => rtcIceCandidates.add(candidate);
      // when call is accepted by remote peer

      socket!.on("answer", (data) async {
        // set SDP answer as remoteDescription for
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(
            data["sdpAnswer"]["sdp"],
            data["sdpAnswer"]["type"],
          ),
        );
        // send iceCandidate generated to remote peer over signalling
        for (RTCIceCandidate candidate in rtcIceCandidates) {
          socket!.emit("candidate", {
            "iceCandidate": {
              "id": candidate.sdpMid,
              "label": candidate.sdpMLineIndex,
              "candidate": candidate.candidate
            }
          });
        }

        notifyListeners();
      });
      // create SDP Offer

      RTCSessionDescription tempOffer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(tempOffer);
      // setState(() => offer = tempOffer);
      // set SDP offer as localDescription for peerConnection

      // make a call to remote peer over signalling
      socket!.emit('offer', {
        "calleeId": socket!.id,
        "roomId": roomId,
        "sdpOffer": tempOffer.toMap(),
      });
    }
    _isInCall = true;
    notifyListeners();
  }

  Future<void> endCall() async {
    // Stop all media tracks in the local stream
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }

    // Close and dispose of the peer connection
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection!.dispose();
      _peerConnection = null;
    }

    // Dispose of the local and remote renderers
    // await _localRenderer.dispose();
    // await _remoteRenderer.dispose();

    // Reset renderers' srcObject
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;

    // Update call status
    _isInCall = false;
    notifyListeners();
  }

  void toggleMic() {
    // Your code to toggle the microphone.
    isAudioOn = !isAudioOn;

    // enable or disable video track
    List<MediaStreamTrack> audioTracks =
        List.from(_localStream?.getAudioTracks() ?? []);
    audioTracks.forEach((track) {
      track.enabled = isAudioOn;
    });
    notifyListeners();
  }

  void switchCamera() {
    // Your code to switch the camera.
    isFrontCameraSelected = !isFrontCameraSelected;

    List<MediaStreamTrack> videoTracks =
        List.from(_localStream?.getVideoTracks() ?? []);
    // switch camera
    videoTracks.forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    notifyListeners();
  }

  void toggleCamera() {
    // Your code to toggle the camera
    isVideoOn = !isVideoOn;
    // print("Video -> $isVideoOn");

    List<MediaStreamTrack> videoTracks =
        List.from(_localStream?.getVideoTracks() ?? []);
    // enable or disable video track
    videoTracks.forEach((track) {
      track.enabled = isVideoOn;
    });
    notifyListeners();
  }

  void startGame(BuildContext context) {
    dynamic data = {
      "roomId": roomId,
    };
    socket!.emit("startGame", data);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(),
      ),
    );
  }

  void listenToStartGame(BuildContext context, bool host) {
    print("Host inside $host");
    if (!host) {
      socket!.on('gameStart', (data) {
        print("here in game");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(),
          ),
        );
      });
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:frontend/game/game_screen.dart';
// import 'package:frontend/video_call/signalling_server.dart';
// import 'dart:core';
// import 'dart:js' as js;

// class VideoCallProvider extends ChangeNotifier {
//   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   bool isHost = false;
//   bool _isInCall = false;
//   bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
//   dynamic offer;
//   String? roomId;
//   List<RTCIceCandidate> rtcIceCandidates = [];
//   String player = "";
//   RTCVideoRenderer get localRenderer => _localRenderer;
//   RTCVideoRenderer get remoteRenderer => _remoteRenderer;
//   RTCPeerConnection? get peerConnection => _peerConnection;
//   bool get isInCall => _isInCall;
//   final socket = SignallingService.instance.socket;

//   void updateOffer(dynamic offer) {
//     this.offer = offer;
//   }

//   void updateRoomId(String roomId) {
//     this.roomId = roomId;
//   }

//   Future<void> initializeRenderers() async {
//     print("Here in intialiseRenderes");
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }

//   Future<void> startCall() async {
//     // Your existing code to start the call and set up the peer connection.
//     // print("Here in startCall -> $roomId");

//     _peerConnection = await createPeerConnection({
//       'iceServers': [
//         {
//           'urls': [
//             'stun:stun1.l.google.com:19302',
//             'stun:stun2.l.google.com:19302',
//             // "turn: turn:192.168.1.4:3478",
//             // Add TURN server for better connectivity
//             // 'turn:your.turn.server:3478',
//             // 'turn:your.turn.server:3478?transport=tcp',
//           ],
//           // 'username': 'vairak',
//           // 'credential': 'abcd1234',
//         }
//       ]
//     });
//     // listen for remotePeer mediaTrack event
//     _peerConnection!.onTrack = (event) {
//       _remoteRenderer.srcObject = event.streams[0];
//     };
//     // get localStream
//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': isAudioOn,
//       'video': isVideoOn
//           ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
//           : false,
//     });
//     // add mediaTrack to peerConnection
//     _localStream!.getTracks().forEach((track) {
//       _peerConnection!.addTrack(track, _localStream!);
//     });
//     // set source for local video renderer
//     _localRenderer.srcObject = _localStream;

//     // for Incoming call
//     if (offer != null) {
//       // listen for Remote IceCandidate
//       socket!.on("candidate", (data) {
//         String candidate = data["iceCandidate"]["candidate"];
//         String sdpMid = data["iceCandidate"]["id"];
//         int sdpMLineIndex = data["iceCandidate"]["label"];
//         // add iceCandidate
//         _peerConnection!.addCandidate(RTCIceCandidate(
//           candidate,
//           sdpMid,
//           sdpMLineIndex,
//         ));
//       });
//       // set SDP offer as remoteDescription for peerConnection
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(offer["sdp"], offer["type"]),
//       );
//       // create SDP answer
//       RTCSessionDescription answer = await _peerConnection!.createAnswer();
//       // set SDP answer as localDescription for peerConnection

//       await _peerConnection!.setLocalDescription(answer);
//       // send SDP answer to remote peer over signalling
//       socket!.emit("answer", {
//         "sdpAnswer": answer.toMap(),
//       });
//     }
//     // for Outgoing Call
//     else {
//       // listen for local iceCandidate and add it to the list of IceCandidate
//       _peerConnection!.onIceCandidate =
//           (RTCIceCandidate candidate) => rtcIceCandidates.add(candidate);
//       // when call is accepted by remote peer

//       socket!.on("answer", (data) async {
//         // set SDP answer as remoteDescription for
//         await _peerConnection!.setRemoteDescription(
//           RTCSessionDescription(
//             data["sdpAnswer"]["sdp"],
//             data["sdpAnswer"]["type"],
//           ),
//         );
//         // send iceCandidate generated to remote peer over signalling
//         for (RTCIceCandidate candidate in rtcIceCandidates) {
//           socket!.emit("candidate", {
//             "iceCandidate": {
//               "id": candidate.sdpMid,
//               "label": candidate.sdpMLineIndex,
//               "candidate": candidate.candidate
//             }
//           });
//         }

//         notifyListeners();
//       });
//       // create SDP Offer

//       RTCSessionDescription tempOffer = await _peerConnection!.createOffer();
//       await _peerConnection!.setLocalDescription(tempOffer);
//       // setState(() => offer = tempOffer);
//       // set SDP offer as localDescription for peerConnection

//       // make a call to remote peer over signalling
//       socket!.emit('offer', {
//         "calleeId": socket!.id,
//         "roomId": roomId,
//         "sdpOffer": tempOffer.toMap(),
//       });
//     }
//     _isInCall = true;
//     notifyListeners();
//   }

//   Future<void> endCall() async {
//     // Stop all media tracks in the local stream
//     if (_localStream != null) {
//       _localStream!.getTracks().forEach((track) {
//         track.stop();
//       });
//       await _localStream!.dispose();
//       _localStream = null;
//     }

//     // Close and dispose of the peer connection
//     if (_peerConnection != null) {
//       await _peerConnection!.close();
//       _peerConnection!.dispose();
//       _peerConnection = null;
//     }

//     // Dispose of the local and remote renderers
//     // await _localRenderer.dispose();
//     // await _remoteRenderer.dispose();

//     // Reset renderers' srcObject
//     _localRenderer.srcObject = null;
//     _remoteRenderer.srcObject = null;

//     // Update call status
//     _isInCall = false;
//     notifyListeners();
//   }

//   void toggleMic() {
//     // Your code to toggle the microphone.
//     isAudioOn = !isAudioOn;

//     // enable or disable video track
//     final jsArray = _localStream?.jsStream.getAudioTracks();
//     List<MediaStreamTrack> audioTracks =
//         List.from(_localStream?.getAudioTracks() ?? []);
//     audioTracks.forEach((track) {
//       track.enabled = isAudioOn;
//     });
//     notifyListeners();
//   }

//   void switchCamera() {
//     // Your code to switch the camera.
//     isFrontCameraSelected = !isFrontCameraSelected;

//     List<MediaStreamTrack> videoTracks =
//         List.from(_localStream?.getVideoTracks() ?? []);
//     // switch camera
//     videoTracks.forEach((track) {
//       // ignore: deprecated_member_use
//       track.switchCamera();
//     });
//     notifyListeners();
//   }

//   void toggleCamera() {
//     // Your code to toggle the camera
//     isVideoOn = !isVideoOn;
//     // print("Video -> $isVideoOn");

//     List<MediaStreamTrack> videoTracks =
//         List.from(_localStream?.getVideoTracks() ?? []);
//     // enable or disable video track
//     videoTracks.forEach((track) {
//       track.enabled = isVideoOn;
//     });
//     notifyListeners();
//   }

//   void startGame(BuildContext context) {
//     dynamic data = {
//       "roomId": roomId,
//     };
//     socket!.emit("startGame", data);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GameScreen(),
//       ),
//     );
//   }

//   void listenToStartGame(BuildContext context, bool host) {
//     print("Host inside $host");
//     if (!host) {
//       socket!.on('gameStart', (data) {
//         print("here in game");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GameScreen(),
//           ),
//         );
//       });
//     }
//   }
// }


