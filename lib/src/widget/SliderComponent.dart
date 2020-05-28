import 'package:flutter/material.dart';

class SliderComponent extends StatelessWidget {
  final PageController pageController;
  final List<String> sliderList;

  SliderComponent(this.pageController, {this.sliderList})
      : assert(pageController != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            FadeInImage.assetNetwork(
          placeholder: 'packages/flutter_video/assets/loading.gif',
          image: sliderList[index],
          fit: BoxFit.cover,
        ),
        itemCount: sliderList.length,
      ),
    );
  }
}
