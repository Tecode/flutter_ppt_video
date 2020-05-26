import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  FullscreenPlayer({this.controller});
  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  @override
  void initState() {
    super.initState();
//    隐藏状态栏
    SystemChrome.setEnabledSystemUIOverlays([]);
//    屏幕横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
//    显示状态栏
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    屏幕竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(widget.controller),
      ),
    );
  }
}
