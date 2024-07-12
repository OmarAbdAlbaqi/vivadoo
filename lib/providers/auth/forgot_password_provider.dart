import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../utils/pop-ups/pop-ups.dart';
class ForgotPasswordProvider with ChangeNotifier{
  bool forgotPasswordLoading = false;
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formStateForgotPassword = GlobalKey<FormState>();

  setForgotPasswordLoading(bool value){
    forgotPasswordLoading = value;
    notifyListeners();
  }
  Future<void> forgotPassword(BuildContext context) async {
    setForgotPasswordLoading(true);
    Uri url = Uri.https(
      Constants.authority,
      Constants.forgotPasswordPath,
    );
    Map<String, dynamic> userInfo = {
      'email' : emailController.text,
    };
    print(userInfo);
    try{
      http.Response response = await http.post(url, body: userInfo).timeout(const Duration(seconds: 10));
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        print(extractedData);
        bool success = extractedData['success'] == 1;
        if(success){
          if(context.mounted){
            PopUps.forgotPasswordEmailSent(context);
          }
        }else{
          if(context.mounted){
            PopUps.apiError(context, extractedData);
          }
        }
      }
      else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setForgotPasswordLoading(false);
    }
    }
  }


