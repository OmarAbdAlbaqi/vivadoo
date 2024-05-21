
import 'package:hive_flutter/adapters.dart';

import 'local_area_model.dart';

class RecentLocationBox {
  static Box<LocalAreaModel> getLocalRecentLocations() =>
      Hive.box<LocalAreaModel>("recentLocations");
}