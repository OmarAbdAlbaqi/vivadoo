import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../ads_provider/ads_provider.dart';
import '../ads_provider/filtered_ads_provider.dart';
class HomePageProvider with ChangeNotifier{
  bool isScrollingUp = false;
  double offset = 0.0;
  List<String> searchedResult = [];
  bool homePageLoading = false;
  TextEditingController textEditingController = TextEditingController();
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
        notifyListeners();
         String page = HiveStorageManager.hiveBox.get('route');
        if(page == "Home"){
          scrollController.animateTo(
              duration:  const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              scrollController.position.maxScrollExtent);
          if(!homePageLoading){
            setHomePageLoading(true);
            context.read<AdsProvider>().getMoreAds(context).then((_) => setHomePageLoading(false));
          }
        }else if (page == "FilteredHome"){
          context.read<FilteredAdsProvider>().setLoading(true);
          scrollController.animateTo(
              duration:  const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              scrollController.position.maxScrollExtent);
          context.read<FilteredAdsProvider>().getMoreFilteredAds(context);
        }
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

  resetSearch(){
    searchedResult = [];
    notifyListeners();
  }
  
  setHomePageLoading(bool value){
    homePageLoading = value;
    notifyListeners();
  }
  
  autoCompleteSearch (String query) async {
    Uri url = Uri.parse("https://www.vivadoo.com/autocomplete.php?query=$query&lang=en");
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        searchedResult = items.map((e) => e['value'].toString()).toList();
        print(searchedResult);
        notifyListeners();
      }else{
        print(response.reasonPhrase);
      }
    }catch (err) {
      print("Error: $err");
    }
    
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



}