import 'package:flutter/material.dart';
class AdPosterInformationProvider with ChangeNotifier{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool hideMyPhoneNumber = false;
  bool enableChatForThisAd = false;

  toggleHidePhoneNumber(){
    hideMyPhoneNumber =! hideMyPhoneNumber;
    notifyListeners();
  }

  toggleEnableChatForThisAd(){
    enableChatForThisAd =! enableChatForThisAd;
    notifyListeners();
  }


}