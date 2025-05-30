import 'package:flutter/material.dart';
class Constants{
  static double width(context) => MediaQuery.of(context).size.width;
  static const Color appBarBackgroundColor =  Color.fromRGBO(88, 89, 91, 1);
  static const Color orange = Color.fromRGBO(254, 153, 51, 1);
  static const String baseUrl = "https://www.vivadoo.com/en/classifieds/";
  static const String authority = "www.vivadoo.com";
  static const String adsPath = "/en/classifieds/api/list";
  static const String adDetailsPath = "/en/classifieds/api/get";
  static const String signInPath = "en/classifieds/api-secure/auth";
  static const String signUpPath = "en/classifieds/api-secure/signup";
  static const String forgotPasswordPath = "en/classifieds/api-secure/forgot";
  static const String userAdsListPath = "en/classifieds/api-secure/list";
  static const String editAccountDetailsPath = "en/classifieds/api-secure/save-account";
  static const String changePasswordPath = "en/classifieds/api-secure/save-password";
  static const String uploadPhotoPath = "en/classifieds/api-secure/upload-image";
  static const String postNewAdPath = "en/classifieds/api-secure/postad";
  static const String checkEmailActivePath = "en/classifieds/api-secure/username";
  static const String sendCodePath = "en/classifieds/api-secure/send-code";
  static const String loginSocialPath = "en/classifieds/api-secure/authexternal";
  static const String listOfDialogsPath = "en/classifieds/api-secure/dialogs";
  static const String startNewDialogPath = "en/classifieds/api-secure/start-dialog";
  static const String archiveDialogPath = "en/classifieds/api-secure/message-archive";
  static const String postNewMessagePath = "en/classifieds/api-secure/message-post";
  static const String postNewImageMessagePath = "en/classifieds/api-secure/message-post-image";
  static const String messagesByDialogPath = "en/classifieds/api-secure/messages-list";


}
const String CATEGORY_KEY = "category";
const String SUBCATEGORY_KEY = "subCategory";
const String CITY_KEY = "city";
const String MAKEKEY = "make";