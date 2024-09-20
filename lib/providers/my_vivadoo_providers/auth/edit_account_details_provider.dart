import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../../constants.dart';
import '../../../models/auth/user_info_model.dart';
import '../../../utils/hive_manager.dart';
import 'generate_signature.dart';

class EditAccountDetailsProvider with ChangeNotifier{



  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  final GlobalKey<FormState> formStateEditAccountDetails = GlobalKey<FormState>();


  late Box<UserInfoModel> userInfoBox;
  late UserInfoModel user;
  EditAccountDetailsProvider(){
    userInfoBox = HiveStorageManager.getUserInfoModel();
    user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phoneNumber);
  }


  Future<void> updateUerInfo(BuildContext context) async {
    Uri url = Uri.https(
      Constants.authority,
      Constants.editAccountDetailsPath,
    );

    Map<String, dynamic> accountDetails ={
      'firstname' : firstNameController.text,
      'lastname' : lastNameController.text,
      'phone' : phoneController.text
    };
    var headers = {
      'User-Agent' : 'vivadoo app',
    };
    AppSignature.generateAuthorization(headers, 'POST', url.toString());
    http.Response response = await  http.post(url, headers: headers, body: accountDetails).timeout(const Duration(seconds: 10));
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      bool success = extractedData['success'] == 1;
      if(success){
        userInfoBox.putAt(
            0,
            UserInfoModel(
                firstName: extractedData['firstname'],
                lastName: extractedData['lastname'],
                emailAddress: user.emailAddress,
                phoneNumber: extractedData['phone'],
                token: user.token,
                key: user.key));
        String message = 'Your account details updated successfully!';
        if(context.mounted){
          PopUps.apiConfirmation(context, message);
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
    notifyListeners();
  }
}