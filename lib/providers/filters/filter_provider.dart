import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/filters/location_filter.dart';

import '../../models/filters/category_model.dart';
import '../../models/filters/meta_fields_model.dart';
import '../../models/filters/sub_category_model.dart';

enum Sorting { mostRecent, priceL2H, priceH2L }

class FilterProvider with ChangeNotifier {
  Sorting sorting = Sorting.mostRecent;
  int categoryId = 0;
  int subCategoryId = 0;

  List<MetaFieldsModel> categoryMetaFields = [];
  RangeValues currentRangeValues = const RangeValues(0, 1);
  List<dynamic> makesList = [];
  Map<String, dynamic> filterParams = {
    "maxResults": "20",
    "page": "1",
    "governorate": "buy-and-sell-in-lebanon",
  };
  int filterCounter = 1;
  String categoryLabel = "";
  String makeLabel = "All Makes";
  Map<String, dynamic> selected = {};
  List<String> oldMakesKeys = [];
  String? makeLink;
  bool searchOnlyInTitle = false;
  bool showOnlyAdsWithPhotos = false;
  bool showOnlyFeaturedAds = false;
  List<String> adType = ["Privates", "Professionals"];
  String? rangeMetaFieldId;

  setAdType(String value) {
    if (adType.contains(value) && adType.length == 1) {
      if (value == "Privates") {
        adType.clear();
        adType.add("Professionals");
        notifyListeners();
      } else {
        adType.clear();
        adType.add("Privates");
        notifyListeners();
      }
    } else if (!adType.contains(value)) {
      adType.add(value);
      notifyListeners();
    } else {
      adType.remove(value);
      notifyListeners();
    }
  }

  setSearchOnlyInTitle() {
    searchOnlyInTitle = !searchOnlyInTitle;
    notifyListeners();
  }

  setShowOnlyAdsWithPhotos() {
    showOnlyAdsWithPhotos = !showOnlyAdsWithPhotos;
    notifyListeners();
  }

  setShowOnlyFeaturedAds() {
    showOnlyFeaturedAds = !showOnlyFeaturedAds;
    notifyListeners();
  }

  cleanSelected() {
    Map<String, dynamic> temp = {};
    selected.forEach((key, value) {
      temp.addIf(!oldMakesKeys.contains(key), key, value);
    });
    selected = temp;
    oldMakesKeys = [];
  }

  setCategoryLabel(String value) {
    categoryLabel = value;
    notifyListeners();
  }

  setMakeLabel(String value) {
    makeLabel = value;
    notifyListeners();
  }

  setRangeValue(RangeValues value) {
    currentRangeValues = value;
    notifyListeners();
  }

  setCategoryMetaFields(BuildContext context, {int? makeId, String? method}) {
    if (method == null) {
      selected.clear();
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

  setFilterParams(Map<String, dynamic> value, String method,
      {String? keyToRemove}) {
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

  rangeSelection() {
    if (rangeMetaFieldId != null) {
      selected.addAll({
        "[$rangeMetaFieldId][min]": currentRangeValues.start.toInt().toString(),
        "[$rangeMetaFieldId][max]": currentRangeValues.end.toInt().toString(),
      });
      rangeMetaFieldId = null;
    }
  }

  multiCheckSelection(String key, String value, int index) {
    Map<String, dynamic> temp = selected;
    if (temp.containsKey(key)) {
      temp.remove(key);
    } else {
      temp.addAll({key: value});
    }
    selected = temp;
    notifyListeners();
  }

  uniqueSelection(String key, Map<String, dynamic> value) {
    if (selected.isEmpty) {
      selected.addAll({key: value});
    } else {
      if (mapEquals(value, selected[key])) {
        selected.remove(key);
      } else {
        selected.remove(key);
        selected.addAll({key: value});
      }
    }
    notifyListeners();
  }

  setSorting(Sorting newSorting) {
    sorting = newSorting;
    notifyListeners();
  }


  showAdsCount(BuildContext context) async {
    //set the current sub category
    List<CategoryModel> categoryList = context.read<FilteredAdsProvider>().categoryList;
    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCategoryId);
    }

    Map<String, dynamic> tempSelected = selected;


    //set the default params
    Map<String, dynamic> tempFilterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
      "with_featured": "1"
    };

    //set city
    tempFilterParams.addAllIf(
        context.read<LocationFilterProvider>().city != "all-cities",
        {"city": context.read<LocationFilterProvider>().city});

    //set range value
    if (rangeMetaFieldId != null) {
      tempSelected.addAll({
        "[$rangeMetaFieldId][min]": currentRangeValues.start.toInt().toString(),
        "[$rangeMetaFieldId][max]": currentRangeValues.end.toInt().toString(),
      });
    }

    //set meta fields data
    tempSelected.forEach((key, value) {
      if (value is Map) {
        value.forEach((key, value2) {
          if (!key.toString().contains("mtfs")) {
            tempFilterParams.addAll({"mtfs$key": value2});
          }
        });
      } else {
        if (!key.contains("mtfs")) {
          tempFilterParams.addAll({"mtfs$key": value});
        }
      }
    });

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
    context.read<FilteredAdsProvider>().getAsCount(context, temp: true, extraParams: tempFilterParams);

  }

  showAds(BuildContext context) async {
    context.read<FilteredAdsProvider>().page = 1;
    context.read<FilteredAdsProvider>().scrollControllerFiltered.jumpTo(0);

    //set the current sub category
    List<CategoryModel> categoryList = context.read<FilteredAdsProvider>().categoryList;
    SubCategoryModel? subCategoryModel;
    if (categoryId != 0) {
      subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCategoryId);
    }

    //set the default params
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
      "with_featured": "1"
    };

    //set city
      filterParams.addAllIf(
          context.read<LocationFilterProvider>().city != "all-cities",
          {"city": context.read<LocationFilterProvider>().city});

      //set range value
    rangeSelection();

    //set meta fields data
    selected.forEach((key, value) {
      if (value is Map) {
        value.forEach((key, value2) {
          if (!key.toString().contains("mtfs")) {
            setFilterParams({"mtfs$key": value2}, "add");
          }
        });
      } else {
        if (!key.contains("mtfs")) {
          setFilterParams({"mtfs$key": value}, "add");
        }
      }
    });

    //add category and sub category to params
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

  resetFilter() {
    currentRangeValues = const RangeValues(0, 1);
    rangeMetaFieldId = null;
    makeLabel = "All Makes";
    categoryId = 0;
    subCategoryId = 0;
    categoryLabel = "";
    categoryMetaFields = [];
    makesList = [];
    selected = {};
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
    };
  }

  clearFilter(BuildContext context) {
    makeLink = null;
    currentRangeValues = const RangeValues(0, 1);
    rangeMetaFieldId = null;
    makeLabel = "All Makes";
    setCategoryMetaFields(context);
    adType = ["Privates", "Professionals"];
    searchOnlyInTitle = false;
    showOnlyAdsWithPhotos = false;
    showOnlyFeaturedAds = false;
    selected = {};
    filterParams = {
      "maxResults": "20",
      "page": "1",
      "governorate": "buy-and-sell-in-lebanon",
    };
    context.read<LocationFilterProvider>().setTempLocation("");
    context.read<LocationFilterProvider>().tempCity = "all-cities";
    notifyListeners();
  }
}
