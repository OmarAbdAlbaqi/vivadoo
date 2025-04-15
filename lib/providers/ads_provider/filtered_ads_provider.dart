import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vivadoo/models/filters/meta_fields_model.dart';

import '../../constants.dart';
import '../../models/ad_model.dart';
import '../../models/filters/category_model.dart';
import '../../utils/pop-ups/pop_ups.dart';
import '../home_providers/filters/filter_provider.dart';
import 'ad_details_provider.dart';
class FilteredAdsProvider with ChangeNotifier{
  List<AdModel> filteredAdsList = [];
  List<CategoryModel> categoryList = [];

  String radius = "5";
  bool radiusSliderVisible = false;
  bool loading = false;
  bool firstAnimation = false;
  RangeValues currentRangeValues = const RangeValues(0,0);
  String query = "";
  int page = 1;
  bool hasMore = false;

  setQuery (String value){
    query = value;
  }

  setRangeValue(RangeValues value){
    currentRangeValues = value;
    notifyListeners();
  }

  setRadius(String value){
    radius  = value;
    notifyListeners();
  }

  setFirstAnimation(bool value){
    firstAnimation = value;
  }

  setRadiusSliderVisible(){
    radiusSliderVisible =! radiusSliderVisible;
    notifyListeners();
  }

  setLoading (bool value){
    loading = value;
    notifyListeners();
  }

  late ScrollController scrollControllerFiltered;
  late RefreshController refreshControllerFilteredAds;
  FilteredAdsProvider(BuildContext context){
    scrollControllerFiltered = ScrollController();
    refreshControllerFilteredAds = RefreshController(initialRefresh: false);
    scrollControllerFiltered.addListener(() {
      if(scrollControllerFiltered.position.pixels == scrollControllerFiltered.position.maxScrollExtent) {
        if(hasMore){
          if(!loading){
            setLoading(true);
            scrollControllerFiltered.animateTo(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                scrollControllerFiltered.position.maxScrollExtent + 100);
            getMoreFilteredAds(context).then((_) => setLoading(false));
          }
        }
        notifyListeners();
      }
    });
  }

  Future<void> getFilteredAds (BuildContext context) async {
    setLoading(true);
    filteredAdsList = [];
    final params = context.read<FilterProvider>().filterParams;
    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        hasMore = extractedData['hasMore'] == 1;
        filteredAdsList = items.map((ad) => AdModel.fromJson(ad)).toList();
        if(context.mounted){
          context.read<AdDetailsProvider>().setListOfAdDetails(filteredAdsList, clearList: true);
        }
        setLoading(false);
        Future.delayed(const Duration(seconds: 2)).then((value) => setFirstAnimation(true));
      } else {
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase!);
        }
      }
    }catch (err) {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  
  Future<void> getMoreFilteredAds (BuildContext context, {Map<String, dynamic>? moreParams}) async {
    setLoading(true);
    final params = context.read<FilterProvider>().filterParams;
    params['page'] = (page + 1).toString();
    page++;
    if(moreParams != null){
      params.addAll(moreParams);
    }
    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        hasMore = extractedData['hasMore'] == 1;
        filteredAdsList.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
        if(context.mounted){
          context.read<AdDetailsProvider>().setListOfAdDetails(items.map((ad) => AdModel.fromJson(ad)).toList());
        }
        // Future.delayed(const Duration(seconds: 1)).then((value) => setLoading(false));
        // notifyListeners();
      }
      else {
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase!);
        }
      }
    } catch (err) {
      print("Error: $err");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }




  List<MetaFieldsModel> metaFields = [];
  List<MetaFieldsModel> categoryMetaFields = [];
  List<MetaFieldsModel> tempCategoryMetaFields = [];
  List<dynamic> ranges = [];

  
  getMetaFields () async {
    Uri url = Uri.parse("${Constants.baseUrl}api/extra");
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List metas = extractedData['metafields'];
      List rangesList = extractedData['range_values'];
      metaFields = metas.map((e) => MetaFieldsModel.fromJson(e)).toList();
      ranges = rangesList;
    }
  }


  
  getCategories() async {
    Uri url = Uri.parse("${Constants.baseUrl}api/categories");
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      categoryList = items.map((e) => CategoryModel.fromJson(e)).toList();
    }
  }

}