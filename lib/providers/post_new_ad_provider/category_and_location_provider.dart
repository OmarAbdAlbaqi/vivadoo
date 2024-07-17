import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widget_provider/steps_bar_widget_provider.dart';
class CategoryAndLocationProvider with ChangeNotifier{

  bool bottomSheetOnTop = false;



  setBottomSheetOnTop(bool newValue){
    bottomSheetOnTop = newValue;
    notifyListeners();
  }
  late TabController tabController;

  void initTabController(BuildContext context,TabController newTabController){
    tabController = newTabController;
    tabController.addListener(() {
      context.read<StepsBarWidgetProvider>().setCurrentTabBarViewIndex(tabController.index);
    });
  }

}