import 'package:flutter/material.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:provider/provider.dart';

class MediaTracks extends StatefulWidget {
  @override
  State<MediaTracks> createState() => MediatracksState();
}

class MediatracksState extends State<MediaTracks> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Provider.of<VideoCallProvider>(context).isAudioOn
              ? Icons.mic
              : Icons.mic_off),
          iconSize: 18,
          onPressed: Provider.of<VideoCallProvider>(context).toggleMic,
        ),
        IconButton(
          icon: const Icon(Icons.call_end),
          iconSize: 18,
          onPressed: () {
            Provider.of<VideoCallProvider>(context, listen: false).endCall();
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.cameraswitch),
          iconSize: 18,
          onPressed: Provider.of<VideoCallProvider>(context).switchCamera,
        ),
        IconButton(
          icon: Icon(Provider.of<VideoCallProvider>(context).isVideoOn
              ? Icons.videocam
              : Icons.videocam_off),
          iconSize: 18,
          onPressed: Provider.of<VideoCallProvider>(context).toggleCamera,
        ),
      ],
    );
  }
}
