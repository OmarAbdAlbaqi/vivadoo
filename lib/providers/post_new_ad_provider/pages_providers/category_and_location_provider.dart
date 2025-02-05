import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';


import '../../../models/filters/meta_fields_model.dart';
import '../steps_bar_widget_provider.dart';
class CategoryAndLocationProvider with ChangeNotifier{

  bool bottomSheetOnTop = false;
  String locationLink = "";
  String locationLabel = "";

  String categoryLabel = "";
  String categoryLink = "";
  PersistentBottomSheetController? bottomSheetController;

  List<MetaFieldsModel> categoryMetaFields = [];
  List<dynamic> makesList = [];

  setLocationLabel(String value){
    locationLabel = value;
    notifyListeners();
  }

  setCategoryLabel(String value){
    categoryLabel = value;
    notifyListeners();
  }

  storeLocationInHive(BuildContext context, String value){
    context.read<PostNewAdProvider>().updateAdField('location', value);
    context.read<PostNewAdProvider>().updateAdField('locationLink', locationLink);


  }

  storeCategoryInHive(BuildContext context, String value){
    context.read<PostNewAdProvider>().updateAdField('category', value);
    context.read<PostNewAdProvider>().updateAdField('categoryLink', categoryLink);
    print(categoryLink);
  }

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