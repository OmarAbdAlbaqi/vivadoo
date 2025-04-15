import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utils/hive_manager.dart';
import '../../../utils/pop-ups/pop_ups.dart';
import '../../general/nav_bar_provider.dart';
import '../../general/navigation_shell_provider.dart';
import '../my_vivadoo_general_provider.dart';
import 'package:provider/provider.dart';


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


  void navigateToSignInPage(BuildContext context){
    HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
    context.read<NavBarProvider>().setCurrentPage(1);
    NavigationManager().goBranch(1);
    context.read<MyVivadooProvider>().changeValue(false);
    context.go('/myVivadoo/signIn');
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