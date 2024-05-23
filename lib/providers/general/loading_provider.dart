import 'package:flutter/material.dart';
class LoadingProvider with ChangeNotifier{
  bool loading = false;

  setLoading(bool newLoading){
    loading = newLoading;
    notifyListeners();
  }
}