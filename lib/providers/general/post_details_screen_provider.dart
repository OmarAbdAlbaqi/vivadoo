import 'package:flutter/material.dart';
class PostDetailsProvider with ChangeNotifier{
  double titleOpacity = 0;
  bool isSummary = true;
  setTitleOpacity(double newOpacity) {
    titleOpacity = newOpacity;
    notifyListeners();
  }
  setIsSummary(bool value){
    isSummary = value;
    notifyListeners();
  }
  }