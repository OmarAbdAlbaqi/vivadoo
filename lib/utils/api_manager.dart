import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/providers/my_vivadoo_providers/auth/sign_in_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  static const String authority = Constants.authority;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// Get The Device Id
  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  /// Sign in with google and get the access token
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        // final AuthCredential credential = GoogleAuthProvider.credential(
        //   accessToken: googleSignInAuthentication.accessToken,
        //   idToken: googleSignInAuthentication.idToken,
        // );
        // UserCredential userCredential =  await _firebaseAuth.signInWithCredential(credential);
        // String? accessToken = userCredential.credential?.accessToken;
        String? accessToken = googleSignInAuthentication.accessToken;
        return accessToken;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
      return "Error Signing in with google";
    }
    return null;
  }

  /// Check App Transparency for IOS Devices
  Future<bool> checkAppTransparency() async {
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
        // var snackBar = const SnackBar(content: Text('Login cancelled, to continue please allow this app to track your activity.'));
        // if(context.mounted){
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
        return false;
      }
      return true;
    }
    return false;
  }

  /// Sign in with facebook and get the access token
  Future<String?> signInWithFacebook() async {
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login(loginTracking: LoginTracking.enabled);
      String? accessToken = loginResult.accessToken?.tokenString;
      return accessToken;
    } catch (e){
      print("Error Signing in with Facebook $e");
      return "Error Signing in with google";
    }
  }

  /// API for social login will return User Info
  Future<UserInfoModel?> socialSignIn(String accessToken , SocialLoginProvider provider , bool isToken) async {
    String deviceId = await getDeviceId() ?? "";
    String deviceToken = HiveStorageManager.hiveBox.get('firebaseToken');
    Map<String , dynamic> params = {
      "provider" : provider.name,
      "code" : accessToken,
      "code_is_token" : isToken ? "1" : "0",
      "device_id" : deviceId,
      "device_token" : deviceToken
    };
    print(params);
    Uri url = Uri.https(
        Constants.authority,
        Constants.loginSocialPath,
        params
    );
    print(url.toString());
    try{
      http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        print("got here");
        final extractedData = jsonDecode(response.body);
        bool success = extractedData['success'] == 1;
        if(success){
          UserInfoModel userInfoModel = UserInfoModel.fromJson(extractedData);
          return userInfoModel;
        }else{
          print(extractedData);
        }
      }
    } catch (e) {
      print("Error Signing in with ${provider.toString()}: $e");
    }
    return null;
  }



  static Future<Map<String, dynamic>?> getAdsCount(Map<String, dynamic> params) async {
    const String adsPath = Constants.adsPath;
    try {
      params["ads_count"] = "1"; // Ensure ads_count is always included
      Uri url = Uri.https(authority, adsPath, params);

      debugPrint("Fetching ads count: $url");

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint("API Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching ads count: $e");
      return null;
    }
  }

}
