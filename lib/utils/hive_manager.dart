import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';

import '../models/filters/hive/local_area_model.dart';

class HiveStorageManager {
  static Box hiveBox = Hive.box("vivadoo_hive_box");

  static final ValueNotifier<bool> signedInNotifier = ValueNotifier<bool>(hiveBox.get('signedIn', defaultValue: false) ?? false);

  static void setSignedIn(bool value) {
    hiveBox.put('signedIn', value);
    signedInNotifier.value = value;
  }

  static Future<void> openHiveBox() async {
    await Hive.initFlutter();
    await Hive.openBox("vivadoo_hive_box");
    Hive.registerAdapter(LocalAreaModelAdapter());
    Hive.registerAdapter(UserInfoModelAdapter());
    await Hive.openBox<LocalAreaModel>("recentLocations");
    await Hive.openBox<UserInfoModel>('userInfo');
  }
  static Future<void> closeHiveBox() async {
    if (Hive.isBoxOpen("vivadoo_hive_box")) {
      await Hive.close();
    }
    return;
  }
  static Box<UserInfoModel> getUserInfoModel() =>
      Hive.box<UserInfoModel>("userInfo");
}