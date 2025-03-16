import 'package:flutter/material.dart';
class RangeFilterProvider with ChangeNotifier{
  RangeValues currentRangeValues = const RangeValues(0, 1);
  String? rangeMetaFieldId;

  setRangeValue(RangeValues value) {
    currentRangeValues = value;
    notifyListeners();
  }

  resetRangeValue(){
    currentRangeValues = const RangeValues(0, 1);
    rangeMetaFieldId = null;
  }

  clearRangeMetaField(){
    rangeMetaFieldId = null;
  }
}