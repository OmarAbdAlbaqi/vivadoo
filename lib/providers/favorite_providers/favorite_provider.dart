import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../models/ad_model.dart';



class FavoriteProvider extends ChangeNotifier{
  List<AdModel> favoriteAds = [];

  setFavoriteAds (List<AdModel> values){
    favoriteAds = values;
    notifyListeners();
  }

  void favoriteButtonPressed(AdModel adModel){
    List<AdModel> temp = favoriteAds;
    if(temp.any((element) => element.id == adModel.id)){
      HiveStorageManager.getFavoriteAds().delete(adModel.id);
      temp.remove(adModel);
    }else{
      HiveStorageManager.getFavoriteAds().put(adModel.id,adModel);
      temp.add(adModel);
    }
    favoriteAds = temp;
    notifyListeners();
  }
  
  void onNavigateToFavoritePage(BuildContext context){
    print("lets see");
    HiveStorageManager.hiveBox.put('route', 'Saved');
    context.read<AdDetailsProvider>().setListOfAdDetails(favoriteAds, clearList: true);
  }
}