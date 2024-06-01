import 'package:flutter/material.dart';
class UserAdsScreenProvider with ChangeNotifier{
  double scrollValue = -1.0;
  double maxPixels = 256;
  final ScrollController scrollController = ScrollController();


  double calculateScrollValue(double scrollPixels, double maxPixels) {
    if (scrollPixels > maxPixels) {
      scrollPixels = maxPixels;
    }
    double value = -1 + (0.9 * (scrollPixels / maxPixels));
    return value.clamp(-1, -0.1);
  }

  setScrollValue (double newValue){
    scrollValue = newValue;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    scrollController.addListener(() {
      setScrollValue(calculateScrollValue(scrollController.position.pixels, maxPixels));
    });
    super.addListener(listener);

  }
}