import 'package:flutter/material.dart';
class NavBarProvider with ChangeNotifier{
  int currentPage = 0;
  bool firstRun = true;

  setFirstRun(){
    firstRun = false;
    notifyListeners();
  }
  setCurrentPage(int newPage){
    currentPage = newPage;
    notifyListeners();
  }
}