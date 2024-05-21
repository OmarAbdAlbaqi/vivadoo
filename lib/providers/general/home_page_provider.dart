import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
class HomePageProvider with ChangeNotifier{
  bool isScrollingUp = false;
  double offset = 0.0;
  HomeType homeType = HomeType.splash;
  int homeValue = 0;
  int previousHomeValue = 0;
  List<String> searchedResult = [];
  TextEditingController textEditingController = TextEditingController();
  ScrollPhysics physics = const BouncingScrollPhysics();


  resetSearch(){
    searchedResult = [];
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
  setOffset(double newOffset){
    offset = newOffset;
    notifyListeners();
  }
  setIsScrollingUp(bool value){
    isScrollingUp = value;
    notifyListeners();
  }

  setPreviousHomeValue(int newValue){
    previousHomeValue = newValue;
    notifyListeners();
  }

  setHomeValue(int newValue){
    homeValue = newValue;
  }

  setHomeType(HomeType newHomeType){
    homeType = newHomeType;
    notifyListeners();
  }
}