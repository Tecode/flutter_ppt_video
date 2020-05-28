import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PPTVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  PPTVideoPlayer(this.controller);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
