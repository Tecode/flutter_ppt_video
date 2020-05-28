import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/src/controller.dart';
import 'package:video_player/video_player.dart';

import 'widget/SliderComponent.dart';
import 'widget/pptVideoPlayer.dart';

class FullscreenPlayer extends StatefulWidget {
  /// 视频控制器
  final VideoPlayerController controller;

  /// ppt列表
  final List<String> sliderList;

  /// pageView控制器
  final PageController pageController;

  FullscreenPlayer({
    @required this.controller,
    this.sliderList,
    this.pageController,
  }) : assert(controller != null);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  bool _toggle = false;
  VideoPlayerController get videoController => widget.controller;
  bool bottomNavBarVisible = true;
  Timer _timer;

  @override
  void initState() {
    super.initState();
//    隐藏状态栏
    SystemChrome.setEnabledSystemUIOverlays([]);
//    屏幕横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        bottomNavBarVisible = !bottomNavBarVisible;
      });
    });
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
    _timer?.cancel();
  }

  void changeBottomPosition() {
    if (!mounted) {
      return;
    }
    if (!bottomNavBarVisible) {
      _timer = Timer(Duration(milliseconds: 5000), () {
        setState(() {
          bottomNavBarVisible = !bottomNavBarVisible;
        });
      });
    } else {
      _timer?.cancel();
    }
    setState(() {
      bottomNavBarVisible = !bottomNavBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => changeBottomPosition(),
        child: Stack(
          children: <Widget>[
            _toggle
                ? SliderComponent(
                    widget.pageController,
                    sliderList: widget.sliderList,
                  )
                : PPTVideoPlayer(videoController),
            Positioned(
              width: 160.0,
              height: 90.0,
              top: 10.0,
              right: 10.0,
              child: GestureDetector(
                onTap: () => setState(() {
                  _toggle = !_toggle;
                }),
                child: _toggle
                    ? PPTVideoPlayer(videoController)
                    : SliderComponent(
                        widget.pageController,
                        sliderList: widget.sliderList,
                      ),
              ),
            ),
            AnimatedPositioned(
              bottom: bottomNavBarVisible ? 0.0 : -40.0,
              left: 0.0,
              right: 0.0,
              child: ControllerBar(videoController),
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}
