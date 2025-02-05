import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utils/pop-ups/pop_ups.dart';


class SignUpProvider with ChangeNotifier{
  bool visible = true;
  bool confirmVisible = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formStateSignUp = GlobalKey<FormState>();


  bool signUpLoading = false;
  setSignUpLoading(bool value){
    signUpLoading = value;
    notifyListeners();
  }

  toggleVisible(){
    visible = !visible;
    notifyListeners();
  }
  toggleConfirmVisible(){
    confirmVisible = !confirmVisible;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    setSignUpLoading(true);
    Uri url = Uri.https(
      Constants.authority,
      Constants.signUpPath,
    );
    Map<String, dynamic> userInfo = {
      'firstname' : firstNameController.text,
      'lastname' : lastNameController.text,
      'email' : emailController.text,
      'phone' : phoneNumberController.text,
      'password' : passwordController.text,
    };
    // var headers = {
    //   'Content-Type': 'application/json'
    // };
    print(userInfo);
    try {
      http.Response response = await http.post(url, body: userInfo).timeout(const Duration(seconds: 10));
      var extractedData = jsonDecode(response.body);
      print(extractedData);
      if(response.statusCode == 200){
        var extractedData = jsonDecode(response.body);
        bool success = extractedData['success'] == 1;
        if(success){
          print(extractedData.toString());
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
      print("catch $e");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setSignUpLoading(false);
    }
  }
}