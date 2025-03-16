import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBarProvider with ChangeNotifier{
  int currentPage = 0;

  List<Map<String , String>> navBarItems = [];



  setCurrentPage(int newPage){
    currentPage = newPage;
    notifyListeners();
  }

  setNavBarData(BuildContext context){
    navBarItems = [
      {
        "title" : AppLocalizations.of(context)!.home,
        "imageUrl" : "assets/icons/nav_bar_icons/home.png",
      },
      {
        "title" : AppLocalizations.of(context)!.vivadoo_profile,
        "imageUrl" : "assets/icons/nav_bar_icons/user.png",
      },
      {
        "title" : "Post",
        "imageUrl" : "assets/icons/nav_bar_icons/camera.png",
      },
      {
        "title" : AppLocalizations.of(context)!.favorite,
        "imageUrl" : "assets/icons/nav_bar_icons/heart.png",
      },
      {
        "title" : AppLocalizations.of(context)!.messages,
        "imageUrl" : "assets/icons/nav_bar_icons/dialog.png",
      },
    ];
    notifyListeners();
  }
}