import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLoading extends StatefulWidget {
  final VideoPlayerController controller;
  VideoLoading(this.controller);

  @override
  _VideoLoadingState createState() => _VideoLoadingState();
}

class _VideoLoadingState extends State<VideoLoading> {
  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(_listener);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedOpacity(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      opacity: controller.value.initialized ? 0.0 : 1.0,
      child: CircularProgressIndicator(
        backgroundColor: Colors.black38,
        valueColor: AlwaysStoppedAnimation(Colors.white30),
      ),
    ));
  }
}
