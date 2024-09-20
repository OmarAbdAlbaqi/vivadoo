import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../../constants.dart';
import 'generate_signature.dart';
class UserInfoProvider with ChangeNotifier{
  UserInfoModel? userInfo;
  List<AdModel> userAds = [];
  String test = "";

  setUserInfo(String firstName, String lastName, String email, String phone, String token, String key){
    userInfo = UserInfoModel(
        firstName: firstName,
        lastName: lastName,
        emailAddress: email,
        phoneNumber: phone,
        token: token,
        key: key
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
    var headers = {
      'User-Agent' : 'vivadoo app',
    };
    AppSignature.generateAuthorization(headers, 'GET', url.toString());
    try{
      http.Response response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        List tempAds = extractedData['items'];
         userAds = tempAds.map((e) => AdModel.fromJson(e)).toList();
      }else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
  }
}