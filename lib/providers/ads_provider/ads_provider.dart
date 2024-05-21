import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';

import '../../models/ad_model.dart';
class AdsProvider with ChangeNotifier{
  List<AdModel> adsList = [];
  String perPage = "20";
  String  page = "1";
  String governorate = "buy-and-sell-in-lebanon";
  String city = "all-cities";
  String category = "all-categories";
  String subCategory = "all-sub-categories";
  String sort = "date-sort-desc";


  bool loading = false;

  setLoading (bool value){
    loading = value;
    notifyListeners();
  }

  setPerPage (String value){
    perPage = value;
  }

  setPage (String value){
    page = value;
  }

  setGovernorate (String value){
    governorate = value;
  }

  setCity (String value){
    city = value;
  }

  setCategory (String value){
    category = value;
  }

  setSubCategory (String value){
    subCategory = value;
  }

  setSort (String value){
    sort = value;
  }


  setAdIndex(BuildContext context , String adId){
    List<AdModel> filteredAdsList = context.read<FilteredAdsProvider>().filteredAdsList;
    int? index;
    if(filteredAdsList.isEmpty){
      index =  adsList.indexWhere((element) => element.id == int.parse(adId));
    }else{
       index =  filteredAdsList.indexWhere((element) => element.id == int.parse(adId));
    }
    context.read<AdDetailsProvider>().setCurrentAdIndex(index);
  }



  Future<void> getAds (BuildContext context) async {
    Uri url = Uri.parse("${Constants.baseUrl}api/list?maxResults=$perPage&page=$page&governorate=$governorate&city=$city&category=$category&subCategory=$subCategory&sort=$sort&keywords=&ads_count=0&request_extra=0");
    print(url);
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      print(response.statusCode);
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      adsList.addAll(items.map((ad) => AdModel.fromJson(ad)).toList());
        print(adsList);
    } else {
      print(response.reasonPhrase);
      if(context.mounted){
        showDialog(
            context: context,
            builder: (BuildContext ctx){
              return Dialog(
                backgroundColor: Colors.transparent,
               child: Container(
                  width: 200,
                  height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF000000),
                        ),
                        alignment: Alignment.center,
                        child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                      ),
                    ),
                  ],
                ),
                ),
              );
            });
      }
    }
  }

  Future<void> refreshAds (BuildContext context) async {
    Uri url = Uri.parse("${Constants.baseUrl}api/list?maxResults=20&page=1&governorate=$governorate&city=$city&category=$category&subCategory=$subCategory&sort=$sort&keywords=&ads_count=0&request_extra=0");
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      List items = extractedData['items'];
      adsList = items.map((ad) => AdModel.fromJson(ad)).toList();
    } else {
      if(context.mounted){
        showDialog(
            context: context,
            builder: (BuildContext ctx){
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFffffff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF000000),
                          ),
                          alignment: Alignment.center,
                          child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    }
  }
}

