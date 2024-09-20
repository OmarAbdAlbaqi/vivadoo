import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utils/pop-ups/pop_ups.dart';
import 'generate_signature.dart';
class ChangePasswordProvider with ChangeNotifier{
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formStateChangePassword = GlobalKey<FormState>();


  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  togglePasswordVisible(){
    passwordVisible =! passwordVisible;
    notifyListeners();
  }
  toggleConfirmPasswordVisible(){
    confirmPasswordVisible =! confirmPasswordVisible;
    notifyListeners();
  }

  Future<void> changePassword(BuildContext context) async {
    Uri url = Uri.https(
      Constants.authority,
      Constants.changePasswordPath,
    );
    Map<String, dynamic> body = {
      'password' : passwordController.text,
    };
    var headers = {
      'User-Agent' : 'vivadoo app',
    };
    AppSignature.generateAuthorization(headers, 'POST', url.toString());
    http.Response response = await  http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 10));
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      bool success = extractedData['success'] == 1;
      if(success){
        String message = 'Your password has been updated successfully!';
        passwordController.clear();
        confirmPasswordController.clear();
        if(context.mounted){
          PopUps.apiConfirmation(context, message, type: "changePassword");
        }
      }else{
        if(context.mounted){
          PopUps.somethingWentWrong(context);
        }
      }
    }else{
      if(context.mounted){
        PopUps.apiError(context, response.reasonPhrase.toString());
      }
    }
  }
}