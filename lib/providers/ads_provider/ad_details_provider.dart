import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';

import '../../constants.dart';
import '../../models/ad_details_model.dart';

class AdDetailsProvider with ChangeNotifier{
  int imageIndex = 1;
  int originalImageIndex = 1;
  bool loading = false;
  int currentAdIndex = 0;
  int maxLine = 0;
  setMaxLine (int value){
    maxLine = value;
    notifyListeners();
  }

  setCurrentAdIndex(int value){
    currentAdIndex = value;
    print(currentAdIndex);
  }

  int? setNewAdId(BuildContext context){
    List<AdModel> adsList =context.read<AdsProvider>().adsList;
    List<AdModel> filteredAdsList = context.read<FilteredAdsProvider>().filteredAdsList;
    if(filteredAdsList.isEmpty){
      return adsList[currentAdIndex +1].id;
    }else{
      filteredAdsList[currentAdIndex +1].id;
    }
    return null;
  }


  setLoading(bool value){
    loading = value;
    notifyListeners();
  }


  setOriginalImageIndex(int value){
    originalImageIndex = value + 1;
    print(originalImageIndex);
    notifyListeners();
  }


  setImageIndex(int value){
    imageIndex = value + 1;
    originalImageIndex = value +1;
    notifyListeners();
  }

  Future<AdDetailsModel?> getAdDetails (BuildContext context,String adId) async {
    Uri url = Uri.https(
      Constants.authority,
      Constants.adDetailsPath,
      {"id": adId}
    );
    print(url);
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        print(AdDetailsModel.fromJson(extractedData));
        return AdDetailsModel.fromJson(extractedData);
      }else{
        print(response.reasonPhrase);
        Navigator.pop(context.mounted ? navigatorKey.currentState!.overlay!.context : context);
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
    } catch (err) {
      print("Error: $err");
    }
    return null;
  }
}