import 'package:flutter/widgets.dart';
import 'package:flutter_video/src/duration_formatter.dart';
import 'package:video_player/video_player.dart';

enum TimerTextType { position, duration }

class TimerText extends StatefulWidget {
  final VideoPlayerController controller;
  final TimerTextType type;

  TimerText(
    this.controller, {
    this.type = TimerTextType.duration,
  });

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  VoidCallback listener;
  VideoPlayerController get videoController => widget.controller;

  _TimerTextState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    videoController.addListener(listener);
  }

  @override
  void deactivate() {
    videoController.removeListener(listener);
    super.deactivate();
  }

  String get _buildPosition {
    if (videoController.value.initialized) {
      if (widget.type == TimerTextType.duration) {
        return durationFormatter(videoController.value.duration.inMilliseconds);
      }
      return durationFormatter(videoController.value.position.inMilliseconds);
    }
    return '00:00';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildPosition,
      style: TextStyle(
        fontSize: 12.0,
        color: Color(0xffffffff),
      ),
    );
  }
}
