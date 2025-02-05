import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomeSearchProvider with ChangeNotifier{
  List<String> searchedResult = [];
  TextEditingController textEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  HomeSearchProvider(){
    searchFocusNode.addListener((){
      if(searchFocusNode.hasFocus){
        textEditingController = TextEditingController();
        notifyListeners();
      }else{
        notifyListeners();
      }
    });
  }
  resetSearch(){
    searchedResult = [];
    notifyListeners();
  }

  autoCompleteSearch () async {
    Uri url = Uri.parse("https://www.vivadoo.com/autocomplete.php?query=${textEditingController.text}&lang=en");
    if(textEditingController.text.length > 2){
      try {
        http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
        if(response.statusCode == 200){
          var extractedData = jsonDecode(response.body);
          List items = extractedData['items'];
          searchedResult = items.map((e) => e['value'].toString()).toList();
          print(searchedResult);

        }else{
          print(response.reasonPhrase);
        }
      }catch (err) {
        print("Error: $err");
      }
    }else{
      resetSearch();
    }
    notifyListeners();
  }
}