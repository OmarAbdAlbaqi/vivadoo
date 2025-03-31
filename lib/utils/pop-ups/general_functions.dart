import 'package:url_launcher/url_launcher.dart';

import '../../models/auth/user_info_model.dart';
import '../../tsting.dart';
import '../hive_manager.dart';

class GeneralFunctions {
  static Future<void> contactByPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  static Future<void> contactByEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  static Future<void> contactByChat(String message , String receiverId) async {}

  static Map<String, String> getHeader(Uri url , String method ) {
    final userInfoBox = HiveStorageManager.getUserInfoModel();
    UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
    return AppSignature2.generateHeaders(
      method: method,
      fullUrl: url.toString(),
      secretKey: user.key,
      publicKey: user.token,
      username: user.emailAddress,
    );
  }
}
