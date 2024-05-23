import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';

import '../../models/ad_model.dart';
import '../../utils/pop-ups/pop-ups.dart';
class AdsProvider with ChangeNotifier{
  List<AdModel> adsList = [];
  String  page = "1";
  bool loading = false;

  setLoading (bool value){
    loading = value;
    notifyListeners();
  }

  setPage (String value){
    page = value;
  }

  Future<void> getMoreAds (BuildContext context) async {
    Map<String, dynamic> params = context.read<FilterProvider>().filterParams;
    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      adsList.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
      if(context.mounted){
        context.read<AdDetailsProvider>().setListOfAdDetails(adsList);
      }
    }
    else {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
  }

  Future<void> refreshAds (BuildContext context) async {
   Map<String, dynamic> params = context.read<FilterProvider>().filterParams;
    Uri url = Uri.https(
        Constants.authority,
        Constants.adsPath,
        params
    );
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      adsList = items.map((ad) => AdModel.fromJson(ad)).toList();
      if(context.mounted){
        context.read<AdDetailsProvider>().setListOfAdDetails(adsList, clearList: true);
      }
    } else {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
  }
}

