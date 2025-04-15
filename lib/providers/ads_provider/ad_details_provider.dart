import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/main.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../constants.dart';
import '../../models/ad_details_model.dart';

class AdDetailsProvider with ChangeNotifier{
  int imageIndex = 1;
  int originalImageIndex = 1;
  int maxLine = 0;
  bool readMore = false;
  List<AdDetailsModel> listOfAdDetails = [];
  double titleOpacity = 0;
  bool isSummary = true;
  int initialPage = 0;
  bool isScrollingUp = false;


  ////////////////////////////////////////////////////////////////////////////////



  setIsScrollingUp(bool value){
    isScrollingUp = value;
    notifyListeners();
  }

  toggleReadMore(){
    readMore =! readMore;
    notifyListeners();
  }
  setTitleOpacity(double newOpacity) {
    titleOpacity = newOpacity;
    notifyListeners();
  }

  setIsSummary(bool value){
    isSummary = value;
    notifyListeners();
  }



  setOriginalImageIndex(int value){
    originalImageIndex = value + 1;
    notifyListeners();
  }

  setImageIndex(int value){
    imageIndex = value + 1;
    originalImageIndex = value +1;
    notifyListeners();
  }

  setListOfAdDetails(List<AdModel> ads,{bool clearList = false}){
    // print("set list of ad details has been called");
    if(clearList == true){
      listOfAdDetails = [];
    }
    for(int i = 0 ; i < ads.length ; i++){
      var element = ads[i];

      listOfAdDetails.add(AdDetailsModel(images: [{"main":element.thumb}], id: element.id, title: element.title, priceFormatted: element.price, location: element.location));
    }
  }


  Future<void> getAdDetails (BuildContext context,String adId) async {
    Uri url = Uri.https(
        Constants.authority,
        Constants.adDetailsPath,
        {"id": adId}
    );
    try {
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        AdDetailsModel adDetailsModel = AdDetailsModel.fromJson(extractedData);
        int index = listOfAdDetails.indexWhere((element) => element.id == int.parse(adId));
        AdDetailsModel temp = listOfAdDetails.firstWhere((element) => element.id == int.parse(adId));
        temp.images = adDetailsModel.images;
        temp.publicLink = adDetailsModel.publicLink;
        temp.longLink = adDetailsModel.longLink;
        temp.postBy = adDetailsModel.postBy;
        temp.postViews = adDetailsModel.postViews;
        temp.currency = adDetailsModel.currency;
        temp.contactByMail = adDetailsModel.contactByMail;
        temp.hasChat = adDetailsModel.hasChat;
        temp.contactByPhone = adDetailsModel.contactByPhone;
        temp.contactPhone = adDetailsModel.contactPhone;
        temp.description = adDetailsModel.description;
        temp.dirDescription = adDetailsModel.dirDescription;
        temp.category = adDetailsModel.category;
        temp.date = adDetailsModel.date;
        temp.metafields = adDetailsModel.metafields;
        temp.userIsPro = adDetailsModel.userIsPro;
        temp.count = adDetailsModel.count;
        temp.since = adDetailsModel.since;
        listOfAdDetails[index] = temp;
        print(temp);
        notifyListeners();
      }else{
        Navigator.pop(context.mounted ? navigatorKey.currentState!.overlay!.context : context);
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase!);
        }
      }
    } catch (err) {
      print("Error: $err");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
    // notifyListeners();
  }


  setImage(int index , List<Map<String, dynamic>> images){
    images.removeAt(0);
    listOfAdDetails[index].images.addAll(images);
    notifyListeners();
  }
}