import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/src/controller.dart';
import 'package:video_player/video_player.dart';

import 'cacheImage.dart';
import 'calculatePicturePosition.dart';
import 'type.dart';
import 'widget/SliderComponent.dart';
import 'widget/pptVideoPlayer.dart';

class FullscreenPlayer extends StatefulWidget {
  /// 视频控制器
  final VideoPlayerController controller;
  final StreamController streamController;

  /// 是否显示底部的播放进度
  final bool showProgressBar;

  /// 倍数
  final double playbackRate;

  /// ppt列表
  final List<PPTType> sliderList;

  /// stack层组件
  final Widget coverChild;

  FullscreenPlayer({
    @required this.controller,
    this.sliderList = const <PPTType>[],
    this.streamController,
    this.showProgressBar = true,
    this.playbackRate = 1.0,
    this.coverChild = const SizedBox(),
  }) : assert(controller != null);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  bool _toggle = false;

  /// 视频播放控制器
  VideoPlayerController get videoController => widget.controller;
  bool bottomNavBarVisible = true;
  Timer _timer;
  bool running = true;
  double topOffset = 10.0;
  double rightOffset = 10.0;

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
      int _currentIndex =
          getListPicture(videoController.value.position, widget.sliderList);
      //        缓存下一张图片
      cacheImage(
        context,
        index: _currentIndex,
        listData: widget.sliderList,
      );
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
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
      _timer = Timer(Duration(milliseconds: 8000), () {
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

  Widget get _smallWindow {
    if (widget.sliderList.isEmpty) {
      return SizedBox();
    }
    return AnimatedPositioned(
      width: 160.0,
      height: 90.0,
      top: topOffset,
      right: rightOffset,
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
            color: Colors.white.withOpacity(0.6),
            width: 160.0,
            height: 90.0,
          ),
          onDragEnd: (dragEndDetails) => setState(() {
            topOffset = dragEndDetails.offset.dy;
            rightOffset = MediaQuery.of(context).size.width -
                160.0 -
                dragEndDetails.offset.dx;
          }),
        ),
      ),
    );
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
                  : Center(child: PPTVideoPlayer(videoController)),
              Positioned.fill(
                top: 0.0,
                left: 0.0,
                child: widget.coverChild,
              ),
              _smallWindow,
              AnimatedPositioned(
                bottom: bottomNavBarVisible ? 0.0 : -60.0,
                left: 0.0,
                right: 0.0,
                child: ControllerBar(
                  videoController,
                  showProgressBar: widget.showProgressBar,
                  streamController: widget.streamController,
                  playbackRate: widget.playbackRate,
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
