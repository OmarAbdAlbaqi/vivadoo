import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivadoo/app_navigation.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/providers/auth/social_media_auth/apple_auth_provider.dart';
import 'package:vivadoo/providers/auth/social_media_auth/facebook_auth_provider.dart';
import 'package:vivadoo/providers/auth/social_media_auth/google_auth_provider.dart';
import 'package:vivadoo/providers/auth/user_info_provider.dart';

import '../../constants.dart';
import '../../utils/hive_manager.dart';
import '../../utils/pop-ups/pop-ups.dart';
class SignInProvider with ChangeNotifier{
  bool visible = true;

  bool signInLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formStateS = GlobalKey<FormState>();

  toggleVisible(){
    visible =! visible;
    notifyListeners();
  }

  setSignInLoading(bool value){
    signInLoading = value;
    notifyListeners();
  }
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }


  Future<void> signIn(BuildContext context)async{
    setSignInLoading(true);
    var box = HiveStorageManager.hiveBox;
    Uri url = Uri.https(
      Constants.authority,
      Constants.signInPath,
    );
    String? deviceId = await _getId();

    String firebaseToken = box.get('firebaseToken');
    Map<String, dynamic> userInfo = {
      'username' : emailController.text,
      'password' : passwordController.text,
      'device_id' : deviceId,
      'device_token' : firebaseToken
    };


    try {
      http.Response response = await http.post(url, body: userInfo).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        bool success = extractedData['success'] == 1;
        if(success){
          print("success");
          HiveStorageManager.setSignedIn(true);
          final userInfoBox = HiveStorageManager.getUserInfoModel();
          UserInfoModel userInfoModel = UserInfoModel(firstName: extractedData['firstname'], lastName: extractedData['lastname'], emailAddress: extractedData['username'], phoneNumber: extractedData['phone'], token: extractedData['key']);
          userInfoBox.add(userInfoModel);
          if(context.mounted){
            context.read<UserInfoProvider>().setUserInfo(userInfoModel.firstName, userInfoModel.lastName, userInfoModel.emailAddress, userInfoModel.phoneNumber, userInfoModel.token);
            context.go('/myVivadoo/myVivadooProfile');
          }
        }else{
          print("not success");
          if(context.mounted){
            PopUps.apiError(context, extractedData);
          }
        }
      }else{
        print("status code not 200");
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
      print("catched $e");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setSignInLoading(false);
    }
  }

  Future<void> continueWithGoogle(BuildContext context) async {
    if(!signInLoading){
      setSignInLoading(true);
      await context.read<MyGoogleAuthProvider>().signInWithGoogle(context);
      setSignInLoading(false);
    }
  }

  Future<void> continueWithFacebook(BuildContext context) async {
    if(!signInLoading){
      setSignInLoading(true);
      await context.read<MyFacebookAuthProvider>().checkAppTrackingTransparency(context);
      setSignInLoading(false);
    }
  }

  Future<void> continueWithApple(BuildContext context) async {
    if(!signInLoading){
      setSignInLoading(true);
      await context.read<MyAppleAuthProvider>().signInWithApple(context);
      setSignInLoading(false);
    }
  }


}