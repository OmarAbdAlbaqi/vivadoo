import 'package:flutter/material.dart';
class RouteProvider with ChangeNotifier{
  String? currentRoute;

   updateRoute(String? routeName) {
    currentRoute = routeName;
    print("routeName $routeName");
    notifyListeners();
  }
}