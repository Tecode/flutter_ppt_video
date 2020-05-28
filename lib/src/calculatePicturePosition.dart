import '../flutter_video.dart';

int getListPicture(Duration duration, List<PPTType> pptData) {
  return pptData
      .lastWhere(
        (PPTType data) => duration.inSeconds > data.startPosition,
        orElse: () => PPTType(index: 0),
      )
      .index;
}
