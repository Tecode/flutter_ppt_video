import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video/src/type.dart';
import 'package:video_player/video_player.dart';

import 'cacheImage.dart';
import 'calculatePicturePosition.dart';
import 'full_player.dart';
import 'widget/SliderComponent.dart';
import 'widget/pptVideoPlayer.dart';

class PPtVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final Duration startAt;
  final List<PPTType> sliderList;
  final bool controllerVisible;

  /// stack层组件
  final Widget coverChild;

  PPtVideoPlayer({
    @required this.videoController,
    this.startAt = const Duration(seconds: 0),
    this.sliderList = const <PPTType>[],
    this.controllerVisible = true,
    this.coverChild = const SizedBox(),
  }) : assert(videoController != null);

  @override
  _PPtVideoPlayerState createState() => _PPtVideoPlayerState();
}

class _PPtVideoPlayerState extends State<PPtVideoPlayer> {
  bool _toggle = false;
  PageController _pageController;
  bool running = true;

  double topOffset = 10.0;
  double rightOffset = 10.0;

////  监听ppt播放跳转倍速
  StreamController _streamController = StreamController.broadcast();

  VideoPlayerController get controller => widget.videoController;

  List<PPTType> get sliderList => widget.sliderList;

  void _listenVideoControllerWrapper() {
    controller.addListener(() {
      if (!running) {
        return;
      }
      running = false;
      Future.delayed(Duration(milliseconds: 1500), () {
        running = true;
      });
      if (_pageController.hasClients) {
        int _currentIndex =
            getListPicture(controller.value.position, sliderList);
//        缓存下一张图片
        cacheImage(
          context,
          index: _currentIndex,
          listData: sliderList,
        );
//      播放下一张ppt
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _streamController.stream.listen((event) {
      print(event['key']);
    });
    _pageController = PageController(initialPage: 0);
    _listenVideoControllerWrapper();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void pushFullScreenWidget() {
    _streamController.add({'key': 'FULL', 'value': '全屏'});
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      settings: RouteSettings(name: '全屏播放'),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          FullscreenPlayer(
        controller: controller,
        sliderList: sliderList,
        streamController: _streamController,
      ),
    );

    route.completed.then((void value) {
//      controller.setVolume(0.0);
    });

//    controller.setVolume(1.0);
    Navigator.of(context).push(route).then((_) {
      if (mounted)
        setState(() {
          _listenVideoControllerWrapper();
        });
    });
  }

  Widget get _smallWindow {
    if (sliderList.isEmpty) {
      return SizedBox();
    }
    return AnimatedPositioned(
      width: 90.0,
      height: 50.0,
      top: topOffset,
      right: rightOffset,
      duration: Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () => setState(() {
          _toggle = !_toggle;
        }),
        child: Draggable(
          child: _toggle
              ? PPTVideoPlayer(controller)
              : SliderComponent(
                  _pageController,
                  sliderList: sliderList,
                ),
          feedback: Container(
            color: Colors.white.withOpacity(0.6),
            width: 90.0,
            height: 50.0,
          ),
          onDragEnd: (dragEndDetails) => setState(() {
            topOffset = dragEndDetails.offset.dy;
            rightOffset = MediaQuery.of(context).size.width -
                90.0 -
                dragEndDetails.offset.dx;
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * (9 / 16),
        child: Stack(
          children: <Widget>[
            _toggle
                ? SliderComponent(
                    _pageController,
                    sliderList: sliderList,
                  )
                : PPTVideoPlayer(controller),
            Positioned.fill(
              top: 0.0,
              left: 0.0,
              child: widget.coverChild,
            ),
            _smallWindow,
            Positioned(
              bottom: -6.0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: widget.controllerVisible,
                child: FlatButton(
                  color: Colors.blue,
                  child: Text('全屏'),
                  onPressed: () => pushFullScreenWidget(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
