import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vivadoo/services/firebase_service.dart';
import 'package:vivadoo/utils/api_manager.dart';
import '../../../models/auth/user_info_model.dart';
import '../../../providers/my_vivadoo_providers/auth/user_info_provider.dart';

import '../../../constants.dart';
import '../../../utils/hive_manager.dart';
import '../../../utils/pop-ups/pop_ups.dart';
enum SocialLoginProvider {facebook,google,apple}
class SignInProvider with ChangeNotifier{
  bool visible = true;

  bool signInLoading = false;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formStateS = GlobalKey<FormState>();


  ApiManager apiManager = ApiManager();

  toggleVisible(){
    visible =! visible;
    notifyListeners();
  }

  setSignInLoading(bool value){
    signInLoading = value;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context)async{
    setSignInLoading(true);
    var box = HiveStorageManager.hiveBox;
    Uri url = Uri.https(
      Constants.authority,
      Constants.signInPath,
    );

    String? deviceId = await apiManager.getDeviceId();
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
          HiveStorageManager.setSignedIn(true);
          final userInfoBox = HiveStorageManager.getUserInfoModel();
          UserInfoModel userInfoModel = UserInfoModel(firstName: extractedData['firstname'], lastName: extractedData['lastname'], emailAddress: extractedData['username'], phoneNumber: extractedData['phone'], token: extractedData['token'], key: extractedData['key']);
          userInfoBox.add(userInfoModel);
          if(context.mounted){
            context.read<UserInfoProvider>().setUserInfo(userInfoModel.firstName, userInfoModel.lastName, userInfoModel.emailAddress, userInfoModel.phoneNumber, userInfoModel.token, userInfoModel.key);
            FirebaseService().addUser(userInfoModel.key, "${userInfoModel.firstName} ${userInfoModel.lastName}");
            context.go('/myVivadoo/myVivadooProfile');
          }
        }else{
          if(context.mounted){
            PopUps.apiError(context, extractedData.toString());
          }
        }
      }else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
      print("the error in the catch is $e");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setSignInLoading(false);
    }
  }

  Future<void> loginWithSocial(BuildContext context,SocialLoginProvider provider) async {
    setSignInLoading(true);
    UserInfoModel? userInfoModel;
    switch(provider){
      case SocialLoginProvider.google : {
            String? accessToken = await apiManager.signInWithGoogle();
          if(accessToken != null){
            userInfoModel = await apiManager.socialSignIn(accessToken, provider, true);
          }
      }
      case SocialLoginProvider.facebook : {
        bool appTrackingTransparency = await apiManager.checkAppTransparency();
        if(appTrackingTransparency){
          String? accessToken = await apiManager.signInWithFacebook();
          if(accessToken != null){
            userInfoModel = await apiManager.socialSignIn(accessToken, provider, true);
          }
        }
        }

      case SocialLoginProvider.apple : {
        PopUps.somethingWentWrong(context);
      }
    }
    if(userInfoModel != null){
      HiveStorageManager.setSignedIn(true);
      final userInfoBox = HiveStorageManager.getUserInfoModel();
      userInfoBox.add(userInfoModel);
      FirebaseService().addUser(userInfoModel.key, "${userInfoModel.firstName} ${userInfoModel.lastName}");
      if(context.mounted){
        context.go('/myVivadoo/myVivadooProfile');
      }
    }else{
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    }
    setSignInLoading(false);

  }


}