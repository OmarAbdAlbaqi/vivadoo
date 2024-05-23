import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivadoo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/models/filters/hive/local_area_model.dart';
import 'package:vivadoo/models/filters/sub_area_model.dart';

import '../../models/filters/area_model.dart';
import '../../models/filters/hive/recent_locations_box.dart';
class LocationFilterProvider with ChangeNotifier{
  List<AreaModel> areaList = [];
  List<SubAreaModel> subAreaList = [];
  List<SubAreaModel> searchedResult = [];
  double recentValue = 1;
  double regionsValue = 1;
  double subAreaValue = 1;
  int selectedArea = 0;
  String toSearchText = "";
  bool fromFilter = false;
  TextEditingController textEditingController = TextEditingController();


  setFromFilter (bool value){
    fromFilter = value;
    notifyListeners();
  }

  clearText () {
    textEditingController.clear();
  }

  resetSearch(){
    searchedResult = [];
    notifyListeners();
  }

  setToSearchText (String value){
    toSearchText = value;
  }

  setSubAreaValue(double value){
    subAreaValue = value;
    notifyListeners();
  }

  setSelectedArea(int value){
    selectedArea = value;
    notifyListeners();
  }

  setRecentLocationValue(double value){
    recentValue = value;
    notifyListeners();
  }

  setRegionsValue(double value){
    regionsValue = value;
    notifyListeners();
  }
  
  getAreaList() async {
    Uri url = Uri.parse("${Constants.baseUrl}api/location?area_type=2");
    http.Response res = await http.get(url);
    if(res.statusCode == 200){
      var extractedData = jsonDecode(res.body);
      List items = extractedData['items'];
      areaList = items.map((e) => AreaModel.fromJson(e)).toList();
    }
    notifyListeners();
  }

  getSubAreaList(String code) async {
    Uri url = Uri.parse("${Constants.baseUrl}api/location?code=$code");
    http.Response res = await http.get(url);
    if(res.statusCode == 200){
      var extractedData = jsonDecode(res.body);
      List items = extractedData['items'];
      subAreaList = items.map((e) => SubAreaModel.fromJson(e)).toList();
    }
    notifyListeners();
  }

   searchArea () async {
    Uri url = Uri.parse("${Constants.baseUrl}api/location?code=0&query=${toSearchText.toLowerCase()}");
    if(toSearchText.isNotEmpty && toSearchText.length >= 2){
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        print(items.map((e) => SubAreaModel.fromJson(e)).toList());
        searchedResult =  items.map((e) => SubAreaModel.fromJson(e)).toList();

      }else{
        return [];
      }
    }

  }

  cleanSubArea(){
    subAreaList.clear();
  }

  addToLocalRecent(SubAreaModel subAreaModel) async {
    Map<String , dynamic> item = subAreaModel.toJson();
    LocalAreaModel localAreaModel = LocalAreaModel.fromJson(item);
    final areaList = RecentLocationBox.getLocalRecentLocations();
    if(!areaList.containsKey(localAreaModel)){
      if(areaList.length < 5){
        areaList.add(localAreaModel);
      }else{
        areaList.deleteAt(4).then((value) {
          areaList.add(localAreaModel);
        });
      }
    }
  }
}