import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
class UserInfoProvider with ChangeNotifier{
  UserInfoModel? userInfo;
  List<AdModel> userAds = [];

  setUserInfo(String firstName, String lastName, String email, String phone, String token){
    userInfo = UserInfoModel(
        firstName: firstName,
        lastName: lastName,
        emailAddress: email,
        phoneNumber: phone,
        token: token
    );
  }

  getUserInfo(){
    userInfo = HiveStorageManager.hiveBox.get('userInfo');
  }

  Future<void> getUserAds(BuildContext context) async {
    Uri url = Uri.https(
      Constants.authority,
      Constants.userAdsListPath,
    );
    String key = HiveStorageManager.getUserInfoModel().values.toList().cast<UserInfoModel>()[0].token;
    print(HiveStorageManager.getUserInfoModel().values.toList().cast<UserInfoModel>()[0]);
    var headers = {
      'Authorization' : "AUTH$key",
    };
    print(headers);
    try{
      http.Response response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        print(extractedData);
      }else{
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}