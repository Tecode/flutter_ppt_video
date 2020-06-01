import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/flutter_video.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VideoPlayerController _videoController;

  final List<PPTType> _pptList = [
    PPTType(
      index: 0,
      startPosition: 0,
      url:
          'https://static.naoxuejia.com/327ea19026232967c9e1680b10523e1587b5ed54.jpeg',
    ),
    PPTType(
      index: 1,
      startPosition: 10,
      url:
          'https://static.naoxuejia.com/c59849a0e90204e209be1ebfa7d0679442161891.jpeg',
    ),
    PPTType(
      index: 2,
      startPosition: 15,
      url:
          'https://static.naoxuejia.com/f6554ea40f1798f851848341185b66d493cd8dd9.jpeg',
    ),
    PPTType(
      index: 3,
      startPosition: 20,
      url:
          'https://static.naoxuejia.com/db455af302764acb35e573adc208eb1f9e9f509b.jpeg',
    ),
    PPTType(
      index: 4,
      startPosition: 25,
      url:
          'https://static.naoxuejia.com/3e943402f8b69903160f5077ac362efc7145f788.jpeg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _videoController = VideoPlayerController.network(
        'https://video.pearvideo.com/mp4/third/20200520/cont-1675588-10735030-173120-hd.mp4');
    _videoController.addListener(() {
//      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.restoreSystemUIOverlays();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            PPtVideoPlayer(
              videoController: _videoController,
              sliderList: [],
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
