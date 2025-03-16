import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';

import 'package:http/http.dart' as http;
import 'package:vivadoo/providers/home_providers/filters/range_filter_provider.dart';
import 'package:vivadoo/utils/api_manager.dart';

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

  List<MetaFieldsModel> categoryMetaFields = [];
  List<dynamic> makesList = [];
  Map<String, dynamic> filterParams = {
    "maxResults": "20",
    "page": "1",
    "governorate": "buy-and-sell-in-lebanon",
    "sort": "date-sort-desc"
  };
  Map<String, dynamic> selectedParams = {}; // To store the previous filter state
  String categoryLabel = "";
  String makeLabel = "All Makes";
  Map<String, dynamic> selectedMetaFields = {};
  List<String> oldMakesKeys = [];
  String? makeLink;
  bool searchOnlyInTitle = false;
  bool showOnlyAdsWithPhotos = false;
  bool showOnlyFeaturedAds = false;
  List<String> adType = ["Privates", "Professionals"];

  // Reset to previous filter state
  void resetFilter(BuildContext context) {
    // Reset selected parameters from selectedParams (previous state)
    filterParams = Map.from(selectedParams);

    // Reset category, sub-category, makes, and other necessary properties
    makeLabel = "All Makes";
    categoryId = 0;
    subCategoryId = 0;
    categoryLabel = "";
    categoryMetaFields = [];
    makesList = [];
    selectedMetaFields = {};
    context.read<LocationFilterProvider>().city = "all-cities";
    context.read<LocationFilterProvider>().location = "All Over Country";

    notifyListeners();
  }

  // Clear everything and reset to default values
  void clearFilter(BuildContext context) {
    // Clear all filters and reset to default state
    makeLink = null;
    context.read<RangeFilterProvider>().resetRangeValue();
    makeLabel = "All Makes";
    setCategoryMetaFields(context);
    adType = ["Privates", "Professionals"];
    searchOnlyInTitle = false;
    showOnlyAdsWithPhotos = false;
    showOnlyFeaturedAds = false;
    selectedMetaFields = {};

    // Reset filterParams to default values
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
    };
    context.read<LocationFilterProvider>().tempCity = "all-cities";

    // notifyListeners();
  }

  // Function to save the current state of the filters (for reset)
  void saveCurrentState() {
    selectedParams = Map.from(filterParams); // Save the current state to restore later
  }

  ////////////////////////////////////////////////////////////////////////////////////////
  /// Set the necessary data to be displayed

  void setCategoryLabel(String value) {
    categoryLabel = value;
    notifyListeners();
  }

  void setMakeLabel(String value) {
    makeLabel = value;
    notifyListeners();
  }

  void setCategoryMetaFields(BuildContext context, {int? makeId, bool clear = true}) {
    if (clear) selectedMetaFields.clear();
    categoryMetaFields = [];

    List<MetaFieldsModel> temp = [];
    final provider = context.read<FilteredAdsProvider>();

    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      final category = provider.categoryList.firstWhere(
            (element) => element.id == categoryId,
        orElse: () => CategoryModel(id: 0, name: "", subCategoryModel: [], cat_link: '', icon: '', label: '', cat_type: ''),
      );

      subCategoryModel = category.subCategoryModel.firstWhere(
            (element) => element.id == subCategoryId,
        orElse: () => SubCategoryModel(id: 0, name: "", children: [], cat_link: '', cat_link_parent: '', parent: 0, color: '', label: ''),
      );
    }

    if (subCategoryModel == null || subCategoryModel.id == 0) return;

    categoryLabel = subCategoryModel.name;
    makesList = subCategoryModel.children?.isNotEmpty == true ? subCategoryModel.children! : [];

    for (var field in provider.metaFields) {
      bool isMatchingCategory = field.categories.any((cat) =>
      cat['id'] == subCategoryId || cat['id'] == categoryId || cat['id'] == makeId);

      if (isMatchingCategory) {
        temp.add(MetaFieldsModel(
          id: field.id,
          type: field.type,
          is_required: field.is_required,
          is_unique: field.is_unique,
          is_searchable: field.is_searchable,
          range: field.range,
          name: field.name,
          options: field.options,
          categories: field.categories.where((cat) =>
          cat['id'] == subCategoryId || cat['id'] == categoryId || cat['id'] == makeId).toList(),
        ));
      }
    }

    temp.sort((a, b) {
      int orderA = a.categories.isNotEmpty ? (a.categories[0]['orderBy'] ?? 0) : 0;
      int orderB = b.categories.isNotEmpty ? (b.categories[0]['orderBy'] ?? 0) : 0;
      return orderA.compareTo(orderB);
    });

    categoryMetaFields = temp;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////
  /// Set the data that you get from the user interactions

  void addSelectedRangeToSelectedMetaFields(BuildContext context) {
    final rangeProvider = context.read<RangeFilterProvider>();
    String? rangeMetaFieldId = rangeProvider.rangeMetaFieldId;
    RangeValues currentRangeValues = rangeProvider.currentRangeValues;

    if (rangeMetaFieldId == null) return; // Exit early if there's no rangeMetaFieldId

    filterParams.addAll({
      "mtfs[$rangeMetaFieldId][min]": currentRangeValues.start.round().toString(),
      "mtfs[$rangeMetaFieldId][max]": currentRangeValues.end.round().toString(),
    });

    // Optionally reset the range filter ID inside the provider
    rangeProvider.clearRangeMetaField();

    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  void setAdType(BuildContext context, String value) {
    bool isPrivate = value == "Privates";
    bool isProfessional = value == "Professionals";

    if (adType.contains(value) && adType.length == 1) {
      // Toggle between "Privates" and "Professionals"
      adType
        ..clear()
        ..add(isPrivate ? "Professionals" : "Privates");

      filterParams
        ..remove(isPrivate ? "only_private" : "only_pro")
        ..addAll({isPrivate ? "only_pro" : "only_private": "1"});
    }
    else if (!adType.contains(value)) {
      // Add new ad type and remove filters
      adType.add(value);
      filterParams
        ..remove("only_private")
        ..remove("only_pro");
    }
    else {
      // Remove existing type and update filters accordingly
      adType.remove(value);
      filterParams
        ..remove(isPrivate ? "only_private" : "only_pro")
        ..addAll({isPrivate ? "only_pro" : "only_private": "1"});
    }

    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  void setSearchOnlyInTitle(BuildContext context) {
    searchOnlyInTitle = !searchOnlyInTitle;

    // Update filterParams efficiently
    searchOnlyInTitle ? filterParams["ot"] = "1" : filterParams.remove("ot");

    // Check route before updating ads count
    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  void setShowOnlyAdsWithPhotos(BuildContext context) {
    showOnlyAdsWithPhotos = !showOnlyAdsWithPhotos;

    // Update filterParams efficiently
    showOnlyAdsWithPhotos ? filterParams["op"] = "1" : filterParams.remove("op");

    // Debugging (Optional: Remove in production)
    debugPrint(filterParams.toString());

    // Check route before updating ads count
    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  void setShowOnlyFeaturedAds() {
    showOnlyFeaturedAds = !showOnlyFeaturedAds;
    notifyListeners();
  }

  void multiCheckSelection(BuildContext context, String key, String value, int index) {
    String formattedKey = "mtfs[$key]";

    // Toggle selection
    filterParams.containsKey(formattedKey)
        ? filterParams.remove(formattedKey)
        : filterParams[formattedKey] = value;

    // Check route before updating ads count
    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  void uniqueSelection(BuildContext context, String key, Map<String, dynamic> value) {
    bool isSameSelection = selectedMetaFields.containsKey(key) && mapEquals(value, selectedMetaFields[key]);

    if (isSameSelection) {
      // Remove existing selection if it's the same
      value.forEach((key2, _) => filterParams.remove("mtfs$key2"));
      selectedMetaFields.remove(key);
    } else {
      // Remove old selection (if exists) before adding new one
      selectedMetaFields[key]?.forEach((key2, _) => filterParams.remove("mtfs$key2"));
      selectedMetaFields[key] = value;

      // Add new selection to filterParams
      value.forEach((key2, value2) => filterParams["mtfs$key2"] = value2);
    }

    // Debugging (optional, remove in production)
    debugPrint(filterParams.toString());

    // Update ads count if not in "Category And Location" route
    if (HiveStorageManager.getCurrentRoute() != "Category And Location") {
      showAdsCount(context);
    }

    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  Future<void> showAdsCount(BuildContext context) async {
    final filteredAdsProvider = context.read<FilteredAdsProvider>();
    final locationFilterProvider = context.read<LocationFilterProvider>();

    List<CategoryModel> categoryList = filteredAdsProvider.categoryList;
    SubCategoryModel? subCategoryModel;

    if (categoryId != 0) {
      subCategoryModel = categoryList.firstWhere(
            (element) => element.id == categoryId,
      ).subCategoryModel.firstWhere(
            (element) => element.id == subCategoryId,
      );
    }

    // Build filter parameters
    Map<String, dynamic> tempFilterParams = {};

    // Add city filter if it's not "all-cities"
    if (locationFilterProvider.city != "all-cities") {
      tempFilterParams["city"] = locationFilterProvider.city;
    }

    // Merge other filters
    tempFilterParams.addAll(filterParams);

    // Add category and subcategory
    tempFilterParams["category"] = subCategoryModel?.cat_link_parent;
    tempFilterParams["subCategory"] = subCategoryModel?.cat_link;

    // Override subcategory if `makeLink` is set
    if (makeLink != null && makeLink!.isNotEmpty) {
      tempFilterParams["subCategory"] = makeLink;
    }

    // Fetch ads count
    final response = await ApiManager.getAdsCount(tempFilterParams);

    if (response != null) {
      adsCount = AdsCount.fromJson(response);
      notifyListeners();
    } else {
      if (context.mounted) {
        PopUps.apiError(context, "Failed to fetch ad count");
      }
    }
  }

  //okay hal shi ma b3ref shu bdi fih hon
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
    saveCurrentState();
    await context.read<FilteredAdsProvider>().getFilteredAds(context);

  }

  // resetFilter(BuildContext context) {
  //   context.read<RangeFilterProvider>().resetRangeValue();
  //   makeLabel = "All Makes";
  //   categoryId = 0;
  //   subCategoryId = 0;
  //   categoryLabel = "";
  //   categoryMetaFields = [];
  //   makesList = [];
  //   selectedMetaFields = {};
  //   context.read<LocationFilterProvider>().city = "all-cities";
  //   context.read<LocationFilterProvider>().location = "All Over Country";
  //   filterParams = {
  //     "maxResults": "20",
  //     "page": "1",
  //     "governorate": "buy-and-sell-in-lebanon",
  //   };
  //
  // }
  //
  // clearFilter(BuildContext context) {
  //   makeLink = null;
  //   context.read<RangeFilterProvider>().resetRangeValue();
  //   makeLabel = "All Makes";
  //   setCategoryMetaFields(context);
  //   adType = ["Privates", "Professionals"];
  //   searchOnlyInTitle = false;
  //   showOnlyAdsWithPhotos = false;
  //   showOnlyFeaturedAds = false;
  //   selectedMetaFields = {};
  //   filterParams = {
  //     "maxResults": "20",
  //     "page": "1",
  //     "governorate": "buy-and-sell-in-lebanon",
  //   };
  //   context.read<LocationFilterProvider>().tempCity = "all-cities";
  //   notifyListeners();
  // }

  /// Old Functions need to be deleted once the new ones been checked
  ////////////////////////////////////////////////////////////////////////////////////////
  oldSetCategoryMetaFields(BuildContext context, {int? makeId, bool clear = true}) {
    if (clear) {
      selectedMetaFields.clear();
    }
    categoryMetaFields = [];
    List<MetaFieldsModel> temp = [];
    List<CategoryModel> categoryList = context.read<FilteredAdsProvider>().categoryList;
    List<MetaFieldsModel> allMetaFields = context.read<FilteredAdsProvider>().metaFields;
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

  oldSetAdType(BuildContext context,String value) {
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
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  oldAddSelectedRangeToSelectedMetaFields(BuildContext context) {
    String? rangeMetaFieldId = context.read<RangeFilterProvider>().rangeMetaFieldId;
    RangeValues currentRangeValues = context.read<RangeFilterProvider>().currentRangeValues;
    if (rangeMetaFieldId != null) {
      filterParams.addAll({
        "mtfs[$rangeMetaFieldId][min]": currentRangeValues.start.toInt().toString(),
        "mtfs[$rangeMetaFieldId][max]": currentRangeValues.end.toInt().toString(),
      });
      rangeMetaFieldId = null;
    }
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }

    notifyListeners();
  }

  oldSetSearchOnlyInTitle(BuildContext context) {
    searchOnlyInTitle = !searchOnlyInTitle;
    if(searchOnlyInTitle){
      filterParams.addAll({"ot" : "1"});
    }else{
      filterParams.remove("ot");
    }
    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
      showAdsCount(context);
    }
    notifyListeners();
  }

  oldSetShowOnlyAdsWithPhotos(BuildContext context) {
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

  oldMultiCheckSelection(BuildContext context,String key, String value, int index) {
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
    notifyListeners();
  }

  oldUniqueSelection(BuildContext context,String key, Map<String, dynamic> value) {

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

  oldShowAdsCount(BuildContext context) async {
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
}
