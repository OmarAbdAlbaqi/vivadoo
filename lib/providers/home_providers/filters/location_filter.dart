import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivadoo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/models/filters/hive/local_area_model.dart';
import 'package:vivadoo/models/filters/sub_area_model.dart';

import '../../../models/filters/area_model.dart';
import '../../../models/filters/hive/recent_locations_box.dart';
class LocationFilterProvider with ChangeNotifier{
  List<AreaModel> areaList = [];
  List<SubAreaModel> subAreaList = [];
  List<SubAreaModel> searchedResult = [];
  String location = "All Over Country";
  String tempLocation = "";
  String city = "all-cities";
  String tempCity = "all-cities";



  double subAreaValue = 1;
  int selectedArea = 0;
  String toSearchText = "";
  TextEditingController textEditingController = TextEditingController();

  bool loading = false;

  setLoading(bool newLoading){
    loading = newLoading;
    notifyListeners();
  }

  setTempLocation(String value){
    tempLocation = value;
    notifyListeners();
  }


  setCity(String value){
    if(value == ""){
      city = tempCity;
    }else{
      city = value;
    }
    notifyListeners();
  }

  setLocation(String value){
    location = value;
    notifyListeners();
  }

  clearText () {
    textEditingController.clear();
  }

  resetSearch(){
    searchedResult = [];
    notifyListeners();
  }

  // setToSearchText (String value){
  //   toSearchText = value;
  // }

  setSubAreaValue(double value){
    subAreaValue = value;
    notifyListeners();
  }

  setSelectedArea(int value){
    selectedArea = value;
    notifyListeners();
  }


  bool stickRecentLocation = false;
  setRecentLocationValue(double value){
    if (!stickRecentLocation && value < 0) {
      recentLocationStick();
    }
    else if (stickRecentLocation && value >= 0) {
      recentLocationNonStick();
    }
  }

  void recentLocationStick() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      stickRecentLocation = true;
      notifyListeners();
    });

  }

  void recentLocationNonStick() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      stickRecentLocation = false;
      notifyListeners();
    });
  }


  bool stickSelectRegion = false;
  setRegionsValue(double value){
    if (!stickSelectRegion && value < 0) {
      selectRegionStick();
    }
    else if (stickSelectRegion && value >= 0) {
      selectRegionNonStick();
    }
  }

  
  void selectRegionStick() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      stickSelectRegion = true;
      notifyListeners();
    });

  }

  void selectRegionNonStick() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      stickSelectRegion = false;
      notifyListeners();
    });
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
    setLoading(true);
    Uri url = Uri.parse("${Constants.baseUrl}api/location?code=$code");
    http.Response res = await http.get(url);
    if(res.statusCode == 200){
      var extractedData = jsonDecode(res.body);
      List items = extractedData['items'];
      subAreaList = items.map((e) => SubAreaModel.fromJson(e)).toList();
    }
    setLoading(false);
    notifyListeners();
  }

   searchArea () async {
    Uri url = Uri.parse("${Constants.baseUrl}api/location?code=0&query=${textEditingController.text.toLowerCase()}");
    if(textEditingController.text.isNotEmpty && textEditingController.text.length >= 3){
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        print(items.map((e) => SubAreaModel.fromJson(e)).toList());
        searchedResult =  items.map((e) => SubAreaModel.fromJson(e)).toList();
        notifyListeners();
      }else{
        print(response.reasonPhrase);
      }
    }else{
      searchedResult = [];
      notifyListeners();
    }

  }

  cleanSubArea(){
    subAreaList.clear();
  }

  addToLocalRecent(SubAreaModel subAreaModel) async {
    Map<String , dynamic> item = subAreaModel.toJson();
    LocalAreaModel localAreaModel = LocalAreaModel.fromJson(item);
    final areaList = RecentLocationBox.getLocalRecentLocations();
    if(!areaList.containsKey(localAreaModel.key)){
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