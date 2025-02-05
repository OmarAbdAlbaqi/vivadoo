import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../models/ad_model.dart';
import '../ads_provider/ads_provider.dart';
class HomePageProvider with ChangeNotifier{
  bool isScrollingUp = false;
  double offset = 0.0;

  bool homePageLoading = false;
  ScrollPhysics physics = const BouncingScrollPhysics();

  late ScrollController scrollController;
  late RefreshController refreshController;


  HomePageProvider(BuildContext context){
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: false);
    scrollController.addListener((){
      offset = scrollController.offset;
      var direction = scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse){
        setIsScrollingUp(true);
      }else{
        setIsScrollingUp(false);
      }
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if(context.read<AdsProvider>().hasMore){
            if(!homePageLoading){
              scrollController.animateTo(
                  duration:  const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  scrollController.position.maxScrollExtent + 100);
              setHomePageLoading(true);
              context.read<AdsProvider>().getMoreAds(context).then((_) => setHomePageLoading(false));
            }
          }
        notifyListeners();
      }
    });
  }

  double height = 55;

  void onPageChanged(double page) {
      if (page >= 0 && page <= 1) {
        height = 55.0 * (1.0 - page);
      } else if (page < 0) {
        height = 55.0 * (1.0 + page);
      } else {
        height = 0.0;
      }
      notifyListeners();
  }
  
  setHomePageLoading(bool value){
    homePageLoading = value;
    notifyListeners();
  }

  bool firstAnimated = true;

  setFirstAnimate(bool value){
    firstAnimated = value;
    notifyListeners();
  }

  setIsScrollingUp(bool value){
    isScrollingUp = value;
    notifyListeners();
  }

  onNavigateToHomePage(BuildContext context){
    List<AdModel> ads = context.read<AdsProvider>().adsList;
    context.read<AdDetailsProvider>().setListOfAdDetails(ads, clearList: true);
    HiveStorageManager.hiveBox.put('route', 'Home');
  }

}