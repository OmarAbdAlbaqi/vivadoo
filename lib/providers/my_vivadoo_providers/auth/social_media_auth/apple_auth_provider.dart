import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyAppleAuthProvider with ChangeNotifier{
  Future<void> signInWithApple (BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();


    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    String? firstName = appleCredential.givenName;
    String? lastName = appleCredential.familyName;


    // Uri url = Uri.parse("https://admin.remaxtripoli.com/en/admin/api/provider-auth/?provider=apple&firstname=$firstName&lastname=$lastName&token=${appleCredential.authorizationCode}");
    try {
      // http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
      // if(response.statusCode == 200){
      //
      //   print(response.body);
      //   var jsonResponse = jsonDecode(response.body);
      //   bool success = false;
      //   if(jsonResponse['success'] is int){
      //     jsonResponse['success'] == 1 ? success = true : success = false;
      //   }else{success = jsonResponse['success'];}
      //   print(success);
      //   if(success){} else{}
      // }else{
      //
      // }
    }catch (err){
      print("Error: $err");
    }
  }
}