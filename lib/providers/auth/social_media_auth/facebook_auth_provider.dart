import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
class MyFacebookAuthProvider with ChangeNotifier{


  Future<void> checkAppTrackingTransparency(BuildContext context) async {

    if (Platform.isIOS) {
      TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      } else {
        if (status != TrackingStatus.authorized) {
          await openAppSettings();
        }
      }
      if (status != TrackingStatus.authorized) {
        var snackBar = const SnackBar(content: Text('Login cancelled, to continue please allow this app to track your activity.'));
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        return;
      }
    }

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
          (_) async {
        await signInWithFacebook(context);
      },
    );
  }

  Future<void> signInWithFacebook (BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(loginTracking: LoginTracking.enabled);
      String? accessToken = loginResult.accessToken?.tokenString ?? "";
      Map<String , dynamic> params = {
        'provider' : 'facebook',
        'token' : accessToken,
        'code_is_token' : '1'
      };
      print(params);
      Uri url = Uri.https(
        Constants.authority,
        Constants.facebookAuthPath,
        params
      );
      var response = await http.get(url).timeout(const Duration(seconds: 5));
      if(response.statusCode == 200){
        prefs.setString('signInType', 'facebook');
        var extractedData = jsonDecode(response.body);
        print(extractedData);
      }else{
        print(response.reasonPhrase);
      }
    } catch (err) {
      print("Error $err");
    }
  }
}