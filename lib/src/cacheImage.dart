import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_video/src/type.dart';

/// 预备加载图片
void cacheImage(
  BuildContext context, {
  int index,
  List<PPTType> listData,
}) {
  if (listData.isEmpty) return;
  int currentIndex = 0;
  () {
    currentIndex = min(index + 1, listData.length - 1);
//    没有图片就不再缓存
    if (index == currentIndex) return;
    Image cacheImage = Image.network(listData[currentIndex].url);
    precacheImage(cacheImage.image, context);
  }();
}
