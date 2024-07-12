import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserInfoProvider with ChangeNotifier{
  bool signedIn = true;

  getPrefs () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    signedIn = prefs.getBool('signedIn') ?? false;
    notifyListeners();
  }
}