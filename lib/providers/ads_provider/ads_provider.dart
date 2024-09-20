import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';

import '../../models/ad_model.dart';
import '../../utils/pop-ups/pop_ups.dart';
import '../home_providers/filters/filter_provider.dart';
class AdsProvider with ChangeNotifier{
  List<AdModel> adsList = [];
  String  page = "1";
  bool loading = false;
  bool hasMore = false;
  setLoading (bool value){
    loading = value;
    notifyListeners();
  }


  Future<void> getMoreAds (BuildContext context) async {
    Map<String, dynamic> params = context.read<FilterProvider>().filterParams;
    params['page'] = (int.parse(page) + 1).toString() ;

    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        hasMore = extractedData['hasMore'] == 1;
        List<AdModel> temp = adsList;
        temp.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
        adsList = temp;
        page = (int.parse(page) + 1).toString();
        notifyListeners();
        if(context.mounted){
          context.read<AdDetailsProvider>().setListOfAdDetails(items.map((ad) => AdModel.fromJson(ad)).toList());
        }
      }
      else {
        if(context.mounted){
          PopUps.somethingWentWrong(context);
        }
      }
    } catch (e) {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
    notifyListeners();
  }

  Future<void> refreshAds (BuildContext context) async {
   Map<String, dynamic> params = context.read<FilterProvider>().filterParams;
    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List items = extractedData['items'];
        hasMore = extractedData['hasMore'] == 1;
        adsList = items.map((ad) => AdModel.fromJson(ad)).toList();
        if(context.mounted){
          context.read<AdDetailsProvider>().setListOfAdDetails(adsList, clearList: true);
        }
      } else {
        if(context.mounted){
          PopUps.somethingWentWrong(context);
        }
      }
    } catch (e) {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
    notifyListeners();
  }
}

