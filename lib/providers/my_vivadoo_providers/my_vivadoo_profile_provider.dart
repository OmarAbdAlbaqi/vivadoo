import 'package:flutter/material.dart';

class MyVivadooProfileProvider with ChangeNotifier{
  double languageTabHeight = 54;

  changeLanguageTabHeight(){
    languageTabHeight == 54 ? languageTabHeight = 200 : languageTabHeight = 54;
    print(languageTabHeight);
    notifyListeners();
  }
}