import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/hive_manager.dart';
class StepsBarWidgetProvider with ChangeNotifier{
  int currentIndex = 0;

  bool isBottomSheetOpen = false;

  int currentTabBarViewIndex = 0;

  setCurrentTabBarViewIndex(int index){
    currentTabBarViewIndex = index;
    notifyListeners();
  }

  setIsBottomSheetOpen(bool value){
    isBottomSheetOpen = value;
    notifyListeners();
  }


  setCurrentPostNewAdPage(BuildContext context){
    int tempIndex = context.read<StepsBarWidgetProvider>().currentIndex;
    switch(tempIndex){
      case 0 : HiveStorageManager.hiveBox.put('route', 'PostNewAd');
      break;
      case 1 : HiveStorageManager.hiveBox.put('route', 'Category And Location');
      break;
      case 2 : HiveStorageManager.hiveBox.put('route', 'NewAdDetails');
      break;
      case 3 : HiveStorageManager.hiveBox.put('route', 'PosterInformation');
      break;
    }
  }
  setCurrentIndex(int newIndex){
    currentIndex = newIndex;
  }
}