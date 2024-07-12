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
  static const String facebookAuthPath = "en/classifieds/api-secure/authexternal";

}