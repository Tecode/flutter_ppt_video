import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'full_player.dart';

class PPtVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final Duration startAt;
  final List<String> sliderList;

  PPtVideoPlayer({
    @required this.videoController,
    this.startAt = const Duration(seconds: 0),
    this.sliderList = const [],
  }) : assert(videoController != null);

  @override
  _PPtVideoPlayerState createState() => _PPtVideoPlayerState();
}

class _PPtVideoPlayerState extends State<PPtVideoPlayer> {
  bool _toggle = false;
  PageController _pageController = PageController(initialPage: 0);

  VideoPlayerController get controller => widget.videoController;

  List<String> get sliderList => widget.sliderList;

  void _listenVideoControllerWrapper() {
    controller.addListener(() {
      if (mounted)
        setState(() {
//          _addShowControllerListener();
//          _autoPlay();
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _listenVideoControllerWrapper();
  }

//  @override
//  void didUpdateWidget(PPtVideoPlayer oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    oldWidget.videoController.removeListener(_listener); // <<<<< controller has already been disposed at this point resulting in the exception being thrown
////    _textureId = widget.controller.textureId;
//    widget.videoController.addListener(_listener);
//  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  Widget get _buildPlayer {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoPlayer(controller),
    );
  }

  Widget get _buildSlider {
    return Container(
      color: Colors.deepOrange,
      child: PageView.builder(
        controller: _pageController,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            FadeInImage.assetNetwork(
          placeholder: 'assets/loading.gif',
          image: sliderList[index],
        ),
        itemCount: sliderList.length,
      ),
    );
  }

  void pushFullScreenWidget() {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      settings: RouteSettings(name: '全屏播放'),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          FullscreenPlayer(controller: controller,),
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * (9 / 16),
        child: Stack(
          children: <Widget>[
            _toggle ? _buildSlider : _buildPlayer,
            Positioned(
              width: 200.0,
              height: 112.5,
              bottom: 10.0,
              right: 10.0,
              child: GestureDetector(
                onTap: () => setState(() {
                  _toggle = !_toggle;
                }),
                child: _toggle ? _buildPlayer : _buildSlider,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FlatButton(
                child: Text('全屏'),
                onPressed: () => pushFullScreenWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
