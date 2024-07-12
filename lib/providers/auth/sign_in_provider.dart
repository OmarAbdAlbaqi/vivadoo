import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/auth/social_media_auth/apple_auth_provider.dart';
import 'package:vivadoo/providers/auth/social_media_auth/facebook_auth_provider.dart';
import 'package:vivadoo/providers/auth/social_media_auth/google_auth_provider.dart';

import '../../constants.dart';
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

  Future<void> signIn(BuildContext context)async{
    setSignInLoading(true);
    Uri url = Uri.https(
      Constants.authority,
      Constants.signInPath,
    );
    Map<String, dynamic> userInfo = {
      'username' : emailController.text,
      'password' : passwordController.text
    };
    print(userInfo);

    try {
      http.Response response = await http.post(url, body: userInfo).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        print(extractedData);
        bool success = extractedData['success'] == 1;
        if(success){

        }else{
          if(context.mounted){
            PopUps.apiError(context, extractedData);
          }
        }
      }else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
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