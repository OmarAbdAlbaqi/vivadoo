import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';

import 'package:http/http.dart' as http;
import 'package:vivadoo/providers/home_providers/filters/range_filter_provider.dart';

import '../../../constants.dart';
import '../../../models/filters/ads_count_model.dart';
import '../../../models/filters/category_model.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../models/filters/sub_category_model.dart';
import '../../../utils/hive_manager.dart';
import '../../../utils/pop-ups/pop_ups.dart';
import 'location_filter.dart';


enum Sorting { mostRecent, priceL2H, priceH2L }

class FilterProvider with ChangeNotifier {
  Sorting sorting = Sorting.mostRecent;
  int categoryId = 0;
  int subCategoryId = 0;

  AdsCount? adsCount;
  AdsCount? tempAdsCount;

  List<MetaFieldsModel> categoryMetaFields = [];

  List<dynamic> makesList = [];
  Map<String, dynamic> filterParams = {
    "maxResults": "20",
    "page": "1",
    "governorate": "buy-and-sell-in-lebanon",
  };
  int filterCounter = 1;
  String categoryLabel = "";
  String makeLabel = "All Makes";
  Map<String, dynamic> selectedMetaFields = {};
  List<String> oldMakesKeys = [];
  String? makeLink;
  bool searchOnlyInTitle = false;
  bool showOnlyAdsWithPhotos = false;
  bool showOnlyFeaturedAds = false;
  List<String> adType = ["Privates", "Professionals"];

  ////////////////////////////////////////////////////////////////////////////////////////

  setCategoryLabel(String value) {
    categoryLabel = value;
    notifyListeners();
  }

  setMakeLabel(String value) {
    makeLabel = value;
    notifyListeners();
  }

  setCategoryMetaFields(BuildContext context, {int? makeId, String? method}) {
    if (method == null) {
      selectedMetaFields.clear();
    }
    categoryMetaFields = [];
    List<MetaFieldsModel> temp = [];
    List<CategoryModel> categoryList =
        context.read<FilteredAdsProvider>().categoryList;
    List<MetaFieldsModel> allMetaFields =
        context.read<FilteredAdsProvider>().metaFields;
    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      subCategoryModel = categoryList
          .firstWhere((element) => element.id == categoryId)
          .subCategoryModel
          .firstWhere((element) => element.id == subCategoryId);
    }
    if (subCategoryModel != null) {
      categoryLabel = subCategoryModel.name;
      if (subCategoryModel.children!.isNotEmpty) {
        makesList = subCategoryModel.children!;
      } else {
        makesList = [];
      }
      MetaFieldsModel? metaFieldsModel;
      for (var field in allMetaFields) {
        for (var cat in field.categories) {
          if (cat['id'] == subCategoryId ||
              cat['id'] == categoryId ||
              cat['id'] == makeId) {
            metaFieldsModel = MetaFieldsModel(
                id: field.id,
                type: field.type,
                is_required: field.is_required,
                is_unique: field.is_unique,
                is_searchable: field.is_searchable,
                range: field.range,
                name: field.name,
                options: field.options,
                categories: [cat]);
            break;
          }
        }

        if (metaFieldsModel != null) {
          temp.add(metaFieldsModel);
          // selected.addIf(!selected.containsKey(metaFieldsModel.id.toString()),"${metaFieldsModel.id}",[]);
          metaFieldsModel = null;
        }
      }
      temp.sort((a, b) {
        int orderByA = a.categories.isNotEmpty ? a.categories[0]['orderBy'] : 0;
        int orderByB = b.categories.isNotEmpty ? b.categories[0]['orderBy'] : 0;
        return orderByA.compareTo(orderByB);
      });
    }
    categoryMetaFields = temp;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  addSelectedRangeToSelectedMetaFields(BuildContext context) {
    String? rangeMetaFieldId = context.read<RangeFilterProvider>().rangeMetaFieldId;
    RangeValues currentRangeValues = context.read<RangeFilterProvider>().currentRangeValues;
    if (rangeMetaFieldId != null) {
      filterParams.addAll({
        "mtfs[$rangeMetaFieldId][min]": currentRangeValues.start.toInt().toString(),
        "mtfs[$rangeMetaFieldId][max]": currentRangeValues.end.toInt().toString(),
      });
      rangeMetaFieldId = null;
    }
    print(filterParams);
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }

    notifyListeners();
  }

  setAdType(BuildContext context,String value) {
    if (adType.contains(value) && adType.length == 1) {
      if (value == "Privates") {
        adType.clear();
        adType.add("Professionals");
        filterParams.remove("only_private");
        filterParams.addAll({"only_pro" : "1"});
      } else {
        adType.clear();
        adType.add("Privates");
        filterParams.remove("only_pro");
        filterParams.addAll({"only_private" : "1"});
      }
    } else if (!adType.contains(value)) {
      filterParams.remove("only_private");
      filterParams.remove("only_pro");
      adType.add(value);
    } else {
      if(value == "Privates"){
        filterParams.remove("only_private");
        filterParams.addAll({"only_pro" : "1"});
      }else{
        filterParams.remove("only_pro");
        filterParams.addAll({"only_private" : "1"});
      }
      adType.remove(value);
    }
    print(filterParams);
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  setSearchOnlyInTitle(BuildContext context) {
    searchOnlyInTitle = !searchOnlyInTitle;
    if(searchOnlyInTitle){
      filterParams.addAll({"ot" : "1"});
    }else{
      filterParams.remove("ot");
    }
    print(filterParams);
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  setShowOnlyAdsWithPhotos(BuildContext context) {
    showOnlyAdsWithPhotos = !showOnlyAdsWithPhotos;
    if(showOnlyAdsWithPhotos){
      filterParams.addAll({"op" : "1"});
    }else{
      filterParams.remove("op");
    }
    print(filterParams);
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  setShowOnlyFeaturedAds() {
    showOnlyFeaturedAds = !showOnlyFeaturedAds;
    notifyListeners();
  }

  multiCheckSelection(BuildContext context,String key, String value, int index) {
    Map<String, dynamic> temp = filterParams;
    if (temp.containsKey("mtfs$key")) {
      temp.remove("mtfs$key");
    } else {
      temp.addAll({"mtfs$key": value});
    }
    filterParams = temp;
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    print(filterParams);
    notifyListeners();
  }

  uniqueSelection(BuildContext context,String key, Map<String, dynamic> value) {

    //new selected
    if (selectedMetaFields.isEmpty) {
      selectedMetaFields.addAll({key: value});
      value.forEach((key2, value2) {
        filterParams.addAll({"mtfs$key2": value2});
      });

      //there is an selected
    } else {

      //the new selected from the same category
      if(selectedMetaFields.containsKey(key)){

        //the new selected is the same old selected from the selected list and in the same category
        if(mapEquals(value, selectedMetaFields[key])){
          value.forEach((key2, value2) {
            filterParams.remove("mtfs$key2");
          });
          selectedMetaFields.remove(key);

          //the new selected is from the same category but different selected
        }else{
          selectedMetaFields.forEach((key2, value2){
            if(key2 == key){
              print("found the category");
              value2.forEach((key3, value3){
                filterParams.remove("mtfs$key3");
                value.forEach((key4, value4){
                  filterParams.addAll({"mtfs$key4" : value4});
                });
              });
            }
          });
          selectedMetaFields.remove(key);
          selectedMetaFields.addAll({key:value});
        }
        //adding a new selection from different category
      }else{
        selectedMetaFields.addAll({key: value});
        value.forEach((key2, value2) {
          filterParams.addAll({"mtfs$key2": value2});
        });
      }
      // if (mapEquals(value, selectedMetaFields[key])) {
      //   selectedMetaFields.remove(key);
      //   value.forEach((key2, value2) {
      //     filterParams.remove("mtfs$key2");
      //   });
      // } else {
      //   selectedMetaFields.forEach((key2, value2){
      //     value2.forEach((key3, value3){
      //       filterParams.remove("mtfs$key3");
      //     });
      //   });
      //   value.forEach((key2, value2) {
      //     filterParams.addAll({"mtfs$key2" : value2});
      //   });
      //   selectedMetaFields.remove(key);
      //   selectedMetaFields.addAll({key: value});
      // }
    }
    print(filterParams);
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  showAdsCount(BuildContext context) async {
    //set the current sub category
    List<CategoryModel> categoryList = context.read<FilteredAdsProvider>().categoryList;
    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCategoryId);
    }


    //set the default params
    Map<String, dynamic> tempFilterParams = {};

    //set city
    tempFilterParams.addAllIf(
        context.read<LocationFilterProvider>().city != "all-cities",
        {"city": context.read<LocationFilterProvider>().city});

    //set meta fields data
    tempFilterParams.addAll(filterParams);

    //add category and sub category to params
    tempFilterParams.addAll({
      "category": subCategoryModel?.cat_link_parent,
      "subCategory": subCategoryModel?.cat_link,
    });

    //edit the sub category in case the user set make
    if (makeLink != "" && makeLink != null) {
      tempFilterParams.removeWhere((key, value) => key == "subCategory");
      tempFilterParams.addAll({"subCategory": makeLink});
    }

    getAdsCount(context, temp: true, extraParams: tempFilterParams);
  }

  Future<void> getAdsCount(BuildContext context, {bool? temp, Map<String, dynamic>? extraParams}) async {
    print("getting the ads counts ");
    Map<String , dynamic> params = {
      "ads_count" : "1"
    };

    if(extraParams != null){
      params.addAll(extraParams);
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
        print(extractedData);
        adsCount = AdsCount.fromJson(extractedData);

      } else {
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase!);
        }
      }
    } catch (e){
      print("Error: $e");
    }
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////


  //need to check
  cleanSelected() {
    Map<String, dynamic> temp = {};
    filterParams.forEach((key, value) {
      temp.addIf(!oldMakesKeys.contains(key), key, value);
    });
    filterParams = temp;
    oldMakesKeys = [];
  }

  setFilterParams(Map<String, dynamic> value, String method, {String? keyToRemove}) {
    switch (method) {
      case "add":
        {
          filterParams.addAll(value);
        }
      case "delete":
        {
          filterParams.removeWhere((key, value) => key == keyToRemove);
        }
      case "clear":
        {
          filterParams = {
            "maxResults": "20",
            "page": "1",
            "governorate": "buy-and-sell-in-lebanon",
            "with_featured": "1"
          };
        }
    }
  }

  setSorting(Sorting newSorting) {
    sorting = newSorting;
    notifyListeners();
  }

  showAds(BuildContext context) async {
    String route = HiveStorageManager.hiveBox.get('route');
    if(route != "FilterFromHome"){
      context.read<FilteredAdsProvider>().page = 1;
      context.read<FilteredAdsProvider>().scrollControllerFiltered.jumpTo(0);
    }


    //set the current sub category
    List<CategoryModel> categoryList = context.read<FilteredAdsProvider>().categoryList;
    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCategoryId);
    }

    //set city
    filterParams.addAll(
        {"city": context.read<LocationFilterProvider>().city});
    filterParams.addAll({
      "category": subCategoryModel?.cat_link_parent,
      "subCategory": subCategoryModel?.cat_link,
    });

    //edit the sub category in case the user set make
    if (makeLink != "" && makeLink != null) {
      filterParams.removeWhere((key, value) => key == "subCategory");
      filterParams.addAll({"subCategory": makeLink});
    }

    await context.read<FilteredAdsProvider>().getFilteredAds(context);

  }

  resetFilter(BuildContext context) {
    context.read<RangeFilterProvider>().resetRangeValue();
    makeLabel = "All Makes";
    categoryId = 0;
    subCategoryId = 0;
    categoryLabel = "";
    categoryMetaFields = [];
    makesList = [];
    selectedMetaFields = {};
    context.read<LocationFilterProvider>().city = "all-cities";
    context.read<LocationFilterProvider>().location = "All Over Country";
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
    };

  }

  clearFilter(BuildContext context) {
    makeLink = null;
    context.read<RangeFilterProvider>().resetRangeValue();
    makeLabel = "All Makes";
    setCategoryMetaFields(context);
    adType = ["Privates", "Professionals"];
    searchOnlyInTitle = false;
    showOnlyAdsWithPhotos = false;
    showOnlyFeaturedAds = false;
    selectedMetaFields = {};
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
    };
    context.read<LocationFilterProvider>().tempCity = "all-cities";
    notifyListeners();
  }
}
