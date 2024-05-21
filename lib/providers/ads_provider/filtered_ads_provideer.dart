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
class FilteredAdsProvider with ChangeNotifier{
  List<AdModel> filteredAdsList = [];
  List<CategoryModel> categoryList = [];

  String perPage = "20";
  String  page = "1";
  String governorate = "buy-and-sell-in-lebanon";
  String location = "All Over Country";
  String city = "all-cities";
  String category = "all-categories";
  String subCategory = "all-sub-categories";
  String sort = "date-sort-desc";
  String withFeatured = "0";
  String radius = "5";



  String tempLocation = "";
  String categoryLabel = "";
  String tempCatLabel = "";
  bool radiusSliderVisible = false;
  int filterCounter = 1;
  bool loading = false;
  bool firstAnimation = false;
  RangeValues currentRangeValues = const RangeValues(0,0);
  String? group;
  List<String> selected= [];
  String query = "";
  String make = "All Makes";
  String tempMake = "All Makes";
  bool hasMakes = false;
  List<dynamic> makesList = [];

  setHasMakes (bool value){
    hasMakes = value;
    notifyListeners();
  }

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
    // final List<String> temp = selected;
    if(selected.contains(value)){
      selected.remove(value);
    }else{
      selected.add(value);
    }
    // selected = temp;
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

  resetFilter(){
    perPage = "20";
    page = "1";
    location = "All Over Country";
    radius = "5";
    governorate = "buy-and-sell-in-lebanon";
    city = "all-cities";
    category = "all-categories";
    subCategory = "all-sub-categories";
    sort = "date-sort-desc";
    withFeatured = "0";
    query = "";
  }



  setTempLocation(String value){
    tempLocation = value;
    notifyListeners();
  }




  setFilterCounter() {
    filterCounter = 1;
    if(location != "All Over Country"){
      filterCounter++;
    }

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

  setLocation (String value){
    location = value;
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

  setPerPage (String value){
    perPage = value;
  }

  setPage (String value){
    page = value;
  }

  setGovernorate (String value){
    governorate = value;
  }

  setCity (String value){
    city = value;
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

  Future<void> getTheNextPageOfFilteredAds (BuildContext context, {Map<String, dynamic>? moreParams}) async {
    setLoading(true);
    final params = context.read<FilterProvider>().filterParams;
    if(moreParams != null){
      params.addAll(moreParams);
    }
    Uri url = Uri.parse("${Constants.baseUrl}api/list?maxResults=$perPage&page=$page&governorate=$governorate&city=$city&category=$category&subCategory=$subCategory&sort=$sort&keywords=&ads_count=0&request_extra=0&with_featured=$withFeatured&radius=$radius");
    Uri url2 = Uri.https(
        "www.vivadoo.com",
        '/en/classifieds/api/list',
        {
          "maxResults": perPage,
          "page": page,
          "governorate": governorate,
          "city": city,
          "category": category,
          "subCategory" : subCategory,
          "sort" : sort
        }
    );
    print("url2 $url2");
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      filteredAdsList.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
      Future.delayed(const Duration(seconds: 1)).then((value) => setLoading(false));
      notifyListeners();
    } else {
      if(context.mounted){
        showDialog(
            context: context,
            builder: (BuildContext ctx){
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFffffff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF000000),
                          ),
                          alignment: Alignment.center,
                          child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    }
  }

  Future<void> getFilteredAds (BuildContext context , bool firstLaunch, {Map<String, dynamic>? moreParams}) async {
    setLoading(true);
    final params = context.read<FilterProvider>().filterParams;
    if(moreParams != null){
      params.addAll(moreParams);
    }
    filteredAdsList = [];
    Uri url = Uri.https(
      "www.vivadoo.com",
      "/en/classifieds/api/list",
      params
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        firstLaunch ? Future.delayed(const Duration(milliseconds: 200)).then((value){
          filteredAdsList = items.map((ad) => AdModel.fromJson(ad)).toList();
          notifyListeners();
        }): filteredAdsList = items.map((ad) => AdModel.fromJson(ad)).toList();
        setLoading(false);
        Future.delayed(const Duration(seconds: 1)).then((value) => setFirstAnimation(true));
      } else {
        if(context.mounted){
          showDialog(
              context: context,
              builder: (BuildContext ctx){
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFffffff),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 70,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF000000),
                            ),
                            alignment: Alignment.center,
                            child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }
    }catch (err) {
      print("Error $err");
      if(context.mounted){
        showDialog(
            context: context,
            builder: (BuildContext ctx){
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFffffff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF000000),
                          ),
                          alignment: Alignment.center,
                          child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
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

  // getCategoryFields (int subCatId , int categoryId) {
  //  if(categoryId != 0){
  //    SubCategoryModel subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCatId);
  //    if(subCategoryModel.children!.isNotEmpty){
  //      hasMakes = true;
  //      makesList = subCategoryModel.children!;
  //    }else{
  //      hasMakes = false;
  //      makesList = [];
  //    }
  //  }else{
  //    hasMakes = false;
  //    makesList = [];
  //  }
  //   categoryMetaFields = [];
  //   MetaFieldsModel? metaFieldsModel;
  //   for (var field in metaFields){
  //     if(field.categories.isNotEmpty){
  //       for(var cat in field.categories){
  //         if(cat['id'] == subCatId){
  //           metaFieldsModel = MetaFieldsModel(
  //               id: field.id,
  //               type: field.type,
  //               is_required: field.is_required,
  //               is_unique: field.is_unique,
  //               is_searchable: field.is_searchable,
  //               range: field.range,
  //               name: field.name,
  //               options: field.options,
  //               categories: [
  //                 cat,
  //               ]
  //           );
  //           break;
  //         }
  //       }
  //     }
  //
  //     if(metaFieldsModel != null){
  //       categoryMetaFields.add(metaFieldsModel);
  //     }
  //     metaFieldsModel = null;
  //     notifyListeners();
  //   }
  //   categoryMetaFields.sort((a, b) {
  //     int orderByA = a.categories.isNotEmpty ? a.categories[0]['orderBy'] : 0;
  //     int orderByB = b.categories.isNotEmpty ? b.categories[0]['orderBy'] : 0;
  //     return orderByA.compareTo(orderByB);
  //   });
  //   tempCategoryMetaFields = categoryMetaFields;
  //   print(categoryMetaFields);
  // }
  //
  // getTempCategoryFields (int subCatId , int categoryId) {
  //   if(categoryId != 0){
  //     SubCategoryModel subCategoryModel = categoryList.firstWhere((element) => element.id == categoryId).subCategoryModel.firstWhere((element) => element.id == subCatId);
  //     if(subCategoryModel.children!.isNotEmpty){
  //       hasMakes = true;
  //       makesList = subCategoryModel.children!;
  //     }else{
  //       hasMakes = false;
  //       makesList = [];
  //     }
  //   }else{
  //     hasMakes = false;
  //     makesList = [];
  //   }
  //   tempCategoryMetaFields = [];
  //   MetaFieldsModel? metaFieldsModel;
  //   for (var field in metaFields){
  //     if(field.categories.isNotEmpty){
  //       for(var cat in field.categories){
  //         if(cat['id'] == subCatId){
  //           metaFieldsModel = MetaFieldsModel(
  //               id: field.id,
  //               type: field.type,
  //               is_required: field.is_required,
  //               is_unique: field.is_unique,
  //               is_searchable: field.is_searchable,
  //               range: field.range,
  //               name: field.name,
  //               options: field.options,
  //               categories: [
  //                 cat,
  //               ]
  //           );
  //
  //           break;
  //         }
  //       }
  //     }
  //     if(metaFieldsModel != null){
  //       tempCategoryMetaFields.add(metaFieldsModel);
  //     }
  //     metaFieldsModel = null;
  //     notifyListeners();
  //   }
  //   tempCategoryMetaFields.sort((a, b) {
  //     int orderByA = a.categories.isNotEmpty ? a.categories[0]['orderBy'] : 0;
  //     int orderByB = b.categories.isNotEmpty ? b.categories[0]['orderBy'] : 0;
  //     return orderByA.compareTo(orderByB);
  //   });
  //   print(tempCategoryMetaFields);
  // }
}