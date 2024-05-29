import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamingPage extends StatelessWidget {
  final String liveId;
  final bool isHost;

  const LiveStreamingPage(
      {Key? key, required this.isHost, required this.liveId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1040397391,
        appSign:
            "e4d7d3b5bfeaea95393bb5fe8dc5c6a68781fc07dbbdddcf811a64e4a3418a27",
        userID: Random().nextInt(100000).toString(),
        userName: "user",
        liveID: liveId,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
