import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vivadoo/models/filters/meta_fields_model.dart';
import 'package:vivadoo/models/filters/sub_category_model.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';

import '../../constants.dart';
import '../../models/ad_model.dart';
import '../../models/filters/category_model.dart';
import '../../utils/pop-ups/pop-ups.dart';
import 'ad_details_provider.dart';
class FilteredAdsProvider with ChangeNotifier{
  List<AdModel> filteredAdsList = [];
  List<CategoryModel> categoryList = [];
  String  page = "1";

  String category = "all-categories";
  String subCategory = "all-sub-categories";
  String sort = "date-sort-desc";
  String withFeatured = "0";
  String radius = "5";

  String categoryLabel = "";
  String tempCatLabel = "";
  bool radiusSliderVisible = false;

  bool loading = false;
  bool firstAnimation = false;
  RangeValues currentRangeValues = const RangeValues(0,0);
  String? group;
  List<String> selected= [];
  String query = "";
  String make = "All Makes";
  String tempMake = "All Makes";
  List<dynamic> makesList = [];

  setMake(String value){
    make = value;
    notifyListeners();
  }

  setTempMake(String value){
    tempMake = value;
    notifyListeners();
  }

  setQuery (String value){
    query = value;
  }

  setSelected(String value){
    if(selected.contains(value)){
      selected.remove(value);
    }else{
      selected.add(value);
    }
    notifyListeners();
  }

  setGroup (String value){
    group = value;
    notifyListeners();
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

  setCategoryLabel (String value){
    categoryLabel = value;
    notifyListeners();
  }

  setTempCatLabel (String value){
    tempCatLabel = value;
    notifyListeners();
  }

  setLoading (bool value){
    loading = value;
    notifyListeners();
  }

  setPage (String value){
    page = value;
  }

  setCategory (String value){
    category = value;
  }

  setSubCategory (String value){
    subCategory = value;
  }

  setSort (String value){
    sort = value;
  }

  setWithFeatured(String value){
    withFeatured = value;
  }

  Future<void> getMoreFilteredAds (BuildContext context, {Map<String, dynamic>? moreParams}) async {
    setLoading(true);
    final params = context.read<FilterProvider>().filterParams;
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
        filteredAdsList.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
        if(context.mounted){
          context.read<AdDetailsProvider>().setListOfAdDetails(filteredAdsList);
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