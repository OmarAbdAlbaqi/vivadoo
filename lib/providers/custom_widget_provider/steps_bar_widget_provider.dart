import 'package:flutter/material.dart';
class StepsBarWidgetProvider with ChangeNotifier{
  int currentIndex = 0;

  bool isBottomSheetOpen = false;

  int currentTabBarViewIndex = 0;

  setCurrentTabBarViewIndex(int index){
    print(index);
    currentTabBarViewIndex = index;
    notifyListeners();
  }

  setIsBottomSheetOpen(bool value){
    print(value);
    isBottomSheetOpen = value;
    notifyListeners();
  }

  setCurrentIndex(int newIndex){
    currentIndex = newIndex;
  }
}