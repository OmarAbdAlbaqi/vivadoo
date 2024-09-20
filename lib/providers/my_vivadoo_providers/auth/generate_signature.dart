import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';

import '../../../utils/hive_manager.dart';

class AppSignature {
   static String hmac(List<int> key, List<int> message) {
    final mac = crypto.Hmac(crypto.sha512, key);
    final digest = mac.convert(message).toString();
    return digest;
  }

 static void generateAuthorization(Map<String, dynamic> jsonApi, String method, String uri) {
    final userInfoBox = HiveStorageManager.getUserInfoModel();
    UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
    print("key = ${user.key}");
    final username = user.emailAddress;
    final token = user.token;
    final secretKey = user.key;
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final signature = getSignature(method, uri, username, token, secretKey, timestamp.toString());

    jsonApi['Authorization'] = 'AUTHORIZATION $token:$signature';
    jsonApi['X-Once'] = timestamp.toString();
  }

  static String getSignature(String method, String uri, String username, String token, String secretKey, String timestamp) {

    final stringToSign = StringBuffer();
    stringToSign.write(Uri.encodeQueryComponent('username') + '=' + Uri.encodeQueryComponent(username) + '&');
    stringToSign.write(Uri.encodeQueryComponent('token') + '=' + Uri.encodeQueryComponent(token) + '&');
    stringToSign.write(Uri.encodeQueryComponent('timestamp') + '=' + Uri.encodeQueryComponent(timestamp));

    final baseSignatureString = '$method&${Uri.encodeQueryComponent(uri)}&${stringToSign.toString()}';
     Clipboard.setData(ClipboardData(text: baseSignatureString));
    // print(baseSignatureString );
    final signature = generateHashWithHmac(baseSignatureString, secretKey);

    return signature;
  }

 static  String generateHashWithHmac(String message, String key) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);
    return hmac(keyBytes, messageBytes);
  }
}