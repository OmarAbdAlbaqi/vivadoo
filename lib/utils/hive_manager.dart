import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/filters/hive/local_area_model.dart';

class HiveStorageManager {
  static Box hiveBox = Hive.box("vivadoo_hive_box");

  static Future<void> openHiveBox() async {
    await Hive.initFlutter();
    await Hive.openBox("vivadoo_hive_box");
    Hive.registerAdapter(LocalAreaModelAdapter());
    await Hive.openBox<LocalAreaModel>("recentLocations");
  }
  static Future<void> closeHiveBox() async {
    if (Hive.isBoxOpen("vivadoo_hive_box")) {
      await Hive.close();
    }
    return;
  }
}