import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video/src/widget/timerText.dart';
import 'package:video_player/video_player.dart';

class ControllerBar extends StatefulWidget {
  final VideoPlayerController controller;
  final StreamController streamController;
  final double playbackRate;
  final bool showProgressBar;
  ControllerBar(
    this.controller, {
    this.showProgressBar = false,
    this.streamController,
    this.playbackRate = 1.0,
  });

  @override
  _ControllerBarState createState() => _ControllerBarState();
}

class _ControllerBarState extends State<ControllerBar> {
  bool isPlaying;
  VideoPlayerController get videoController => widget.controller;
  StreamController get streamController => widget.streamController;
  double playbackRate;

  List<double> speedArray = [1.0, 1.2, 1.5, 2.0];
  int speed = 0;

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
//    倍速
    playbackRate = widget.playbackRate;
//    倍数数组
    speed = speedArray.indexOf(playbackRate);
//    是否是播放状态
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

//  修改倍数
  void changeSpeed() {
    if (speed == 3) {
      // 设置播放速率
      setState(() {
        speed = 0;
        playbackRate = speedArray[speed];
      });
//      告诉监听者
      streamController.add({'key': 'SPEED', 'value': playbackRate});
    } else {
      setState(() {
        speed += 1;
        playbackRate = speedArray[speed];
      });
//      告诉监听者
      streamController.add({'key': 'SPEED', 'value': playbackRate});
    }
  }

  Widget get _progressBar {
    // 有进度条
    if (widget.showProgressBar) {
      return Row(
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
            GestureDetector(
              onTap: () => changeSpeed(),
              child: Stack(
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
                    child: Visibility(
                      visible: playbackRate != 1.0,
                      child: Container(
                        child: Center(
                            child: Text(
                          'x$playbackRate',
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
                  ),
                ],
              ),
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
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
        )
      ],
    );
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
      child: _progressBar,
    );
  }
}
