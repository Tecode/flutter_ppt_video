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

  final List<String> _pptList = [
    'https://image.pearvideo.com/cont/20200508/11905134-153651-1.png',
    'https://image.pearvideo.com/cont/20200509/cont-1673461-12377763.jpg',
    'https://image.pearvideo.com/cont/20200521/cont-1675814-12387507.jpg',
    'https://image.pearvideo.com/cont/20200525/11905134-140255-1.png',
    'https://image1.pearvideo.com/cont/20200523/11905134-112111-1.png',
    'https://image.pearvideo.com/cont/20200522/cont-1675703-12388272.jpg',
    'https://image2.pearvideo.com/cont/20200514/cont-1674383-12381791.jpg',
    'https://image1.pearvideo.com/cont/20200428/12655266-164922-1.png',
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
        body: PPtVideoPlayer(
          videoController: _videoController,
          sliderList: _pptList,
        ),
      ),
    );
  }
}
