import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/src/controller.dart';
import 'package:video_player/video_player.dart';

import 'calculatePicturePosition.dart';
import 'type.dart';
import 'widget/SliderComponent.dart';
import 'widget/pptVideoPlayer.dart';

class FullscreenPlayer extends StatefulWidget {
  /// 视频控制器
  final VideoPlayerController controller;
  final StreamController streamController;
  final bool showProgressBar;

  /// ppt列表
  final List<PPTType> sliderList;

  FullscreenPlayer({
    @required this.controller,
    this.sliderList = const <PPTType>[],
    this.streamController,
    this.showProgressBar = true,
  }) : assert(controller != null);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  bool _toggle = false;
  VideoPlayerController get videoController => widget.controller;
  bool bottomNavBarVisible = true;
  Timer _timer;
  bool running = true;
  double topOffset = 10.0;
  double leftOffset = 10.0;
  double retate;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage:
          getListPicture(videoController.value.position, widget.sliderList),
    );
    videoController.addListener(() {
      if (!running) {
        return;
      }
      running = false;
      Future.delayed(Duration(milliseconds: 2000), () {
        running = true;
      });
//      跳转到对应ppt索引
      int _index =
          getListPicture(videoController.value.position, widget.sliderList);
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _index,
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        );
      }
    });
//    隐藏状态栏
    SystemChrome.setEnabledSystemUIOverlays([]);
//    屏幕横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Future.delayed(Duration(milliseconds: 1000), () {
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
    _pageController.dispose();
  }

  void changeBottomPosition() {
    if (!mounted) {
      return;
    }
    if (!bottomNavBarVisible) {
      _timer = Timer(Duration(milliseconds: 5000), () {
//        setState(() {
//          bottomNavBarVisible = !bottomNavBarVisible;
//        });
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
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => changeBottomPosition(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              _toggle
                  ? SliderComponent(
                      _pageController,
                      sliderList: widget.sliderList,
                    )
                  : Center(
                      child: PPTVideoPlayer(videoController),
                    ),
              AnimatedPositioned(
                width: 160.0,
                height: 90.0,
                top: topOffset,
                left: leftOffset,
                duration: Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _toggle = !_toggle;
                  }),
                  child: Draggable(
                    child: _toggle
                        ? PPTVideoPlayer(videoController)
                        : SliderComponent(
                            _pageController,
                            sliderList: widget.sliderList,
                          ),
                    feedback: Container(
                      color: Colors.blue,
                      width: 160.0,
                      height: 90.0,
                      child: _toggle
                          ? PPTVideoPlayer(videoController)
                          : SliderComponent(
                              _pageController,
                              sliderList: widget.sliderList,
                            ),
                    ),
                    onDragEnd: (dragEndDetails) => setState(() {
                      topOffset = dragEndDetails.offset.dy;
                      leftOffset = dragEndDetails.offset.dx;
                    }),
                  ),
                ),
              ),
              AnimatedPositioned(
                bottom: bottomNavBarVisible ? 0.0 : -60.0,
                left: 0.0,
                right: 0.0,
                child: ControllerBar(
                  videoController,
                  showProgressBar: widget.showProgressBar,
                ),
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
