import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/providers/my_vivadoo_providers/auth/sign_in_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:vivadoo/utils/pop-ups/general_functions.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  final String authority = Constants.authority;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Get The Device Id
  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  /// Sign in with Google and get the Google access token
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);

        // Return the Google access token to send to backend
        return googleSignInAuthentication.idToken;
        return googleSignInAuthentication.idToken;
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
    try {
      final LoginResult loginResult = await facebookAuth
          .login(loginTracking: LoginTracking.enabled);
      String? accessToken = loginResult.accessToken?.tokenString;
      return accessToken;
    } catch (e) {
      print("Error Signing in with Facebook $e");
      return "Error Signing in with google";
    }
  }

  /// API for social login will return User Info
  Future<UserInfoModel?> socialSignIn(
      String accessToken, SocialLoginProvider provider, bool isToken) async
  {
    String deviceId = await getDeviceId() ?? "";
    String deviceToken = HiveStorageManager.hiveBox.get('firebaseToken');
    Map<String, dynamic> params = {
      "provider": provider.name,
      "code": accessToken,
      "code_is_token": isToken ? "1" : "0",
      "device_id": deviceId,
      "device_token": deviceToken
    };
    print(params);
    Uri url = Uri.https(Constants.authority, Constants.loginSocialPath, params);
    print(url.toString());
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        print("got here");
        final extractedData = jsonDecode(response.body);
        bool success = extractedData['success'] == 1;
        if (success) {
          UserInfoModel userInfoModel = UserInfoModel.fromJson(extractedData);
          return userInfoModel;
        } else {
          print(extractedData);
        }
      }
    } catch (e) {
      print("Error Signing in with ${provider.toString()}: $e");
    }
    return null;
  }

  Future<void> socialSignOut(SocialLoginProvider provider) async {
    switch(provider){
      case SocialLoginProvider.google : {
        await googleSignIn.signOut();
      }
      case SocialLoginProvider.facebook : {
        await facebookAuth.logOut();
      }

      case SocialLoginProvider.apple : {
        // PopUps.somethingWentWrong(context);
      }
    }
  }

  Future<Map<String, dynamic>?> getAdsCount(Map<String, dynamic> params) async {
    const String adsPath = Constants.adsPath;
    try {
      params["ads_count"] = "1";
      Uri url = Uri.https(authority, adsPath, params);
      print(url.toString());
      debugPrint("Fetching ads count: $url");

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint(
            "API Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching ads count: $e");
      return null;
    }
  }

  ///Chatting

  static Future<http.Response> listOfDialogs({String page = '0', String type = 'inbox'}) async {
    Map<String, dynamic> params = {'page': page, 'type': type};
    Uri url =
        Uri.https(Constants.authority, Constants.listOfDialogsPath, params);
    Map<String, String> headers = GeneralFunctions.getHeader(url, "GET");
      return await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> startNewDialog(String postId, String message) async {
    print('start new dialog API');
    Map<String, String> body = {
      'id': postId, //post id
      'message': message //the message
    };
    Uri url = Uri.https(
      Constants.authority,
      Constants.listOfDialogsPath,
    );
    Map<String, String> headers = GeneralFunctions.getHeader(url, "POST");
    return await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 10));
  }

  Future<void> archiveDialog(String chatId) async {
    Map<String, String> body = {
      'chat_id': chatId,
    };
    Uri url = Uri.https(
      Constants.authority,
      Constants.archiveDialogPath,
    );
    Map<String, String> headers = GeneralFunctions.getHeader(url, "POST");
    print(headers);
    try {
      http.Response response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
      var extractedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("extracted Data when status is 200 is $extractedData");
      } else {
        print("statuc code is not 200 ${response.statusCode}");
        print(response.reasonPhrase);
      }
    } catch (e) {}
  }

  static Future<http.Response> postNewMessage(String chatId, String message) async
  {
    print('post new message api');
    Map<String, String> body = {
      'chat_id': chatId, //post id
      'message': message //the message
    };
    Uri url = Uri.https(
      Constants.authority,
      Constants.postNewMessagePath,
    );
    Map<String, String> headers = GeneralFunctions.getHeader(url, "POST");
    return await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 10));
  }

  static Future<http.Response> postNewImageMessage(
    String chatId,
    String messageId,
    String imageBytes,
  ) async
  {
    Uri url = Uri.https(
      Constants.authority,
      Constants.postNewImageMessagePath,
    );

    Map<String, String> headers = GeneralFunctions.getHeader(url, "POST");

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields.addAll({
        'chat_id' : chatId,
        'message_id' : messageId,
        'photo' : imageBytes,
      });

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> messagesByDialog(String chatId, String page) async {
    print('messages by dialog');
    Map<String, dynamic> params = {'chat_id': chatId, 'page': page};
    Uri url =
        Uri.https(Constants.authority, Constants.messagesByDialogPath, params);
    Map<String, String> headers = GeneralFunctions.getHeader(url, "GET");
    return await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 10));
  }
}
