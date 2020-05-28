import 'package:flutter/material.dart';
import 'package:flutter_video/src/widget/timerText.dart';
import 'package:video_player/video_player.dart';

class ControllerBar extends StatefulWidget {
  final VideoPlayerController controller;
  ControllerBar(this.controller);

  @override
  _ControllerBarState createState() => _ControllerBarState();
}

class _ControllerBarState extends State<ControllerBar> {
  bool isPlaying;
  VideoPlayerController get videoController => widget.controller;

  Widget get _playPause {
    if (isPlaying) {
      return Image.asset(
        'packages/flutter_video/assets/ic_questions_news_zanting.png',
        width: 20.0,
        height: 18.0,
      );
    }
    return Image.asset(
      'packages/flutter_video/assets/ic_questions_news_quanmjnfbof.png',
      width: 20.0,
      height: 20.0,
    );
  }

  @override
  void initState() {
    super.initState();
    isPlaying = videoController.value.isPlaying;
  }

  void _handleTap() {
    if (isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: 34.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: _playPause,
              onTap: () => _handleTap(),
            ),
            SizedBox(
              width: 58.0,
              child: Center(
                child: TimerText(
                  videoController,
                  type: TimerTextType.position,
                ),
              ),
            ),
          ]),
          Expanded(
            child: VideoProgressIndicator(
              videoController,
              allowScrubbing: true,
              colors: VideoProgressColors(playedColor: Color(0xffFFDC2E)),
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
          Row(children: <Widget>[
            SizedBox(
              width: 58.0,
              child: Center(
                child: TimerText(
                  videoController,
                  type: TimerTextType.duration,
                ),
              ),
            ),
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                SizedBox(
                  height: 34.0,
                  width: 40.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      'packages/flutter_video/assets/ic_questions_news_beisutiaozheng.png',
                      width: 20.0,
                      height: 18.0,
                    ),
                  ),
                ),
                Positioned(
                  top: -10.0,
                  left: 15.0,
                  child: Container(
                    child: Center(
                        child: Text(
                      'x1.6',
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    )),
                    width: 34.0,
                    height: 18.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffED6831),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                height: 34.0,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Image.asset(
                      'packages/flutter_video/assets/ic_questions_news_quanpinxuexi.png',
                      width: 18.0,
                      height: 18.0,
                    ),
                    SizedBox(width: 5.0),
                    Text('退出全屏',
                        style: TextStyle(fontSize: 12.0, color: Colors.white))
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
