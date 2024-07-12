import 'package:flutter/material.dart';

import '../../models/filters/meta_fields_model.dart';
class NewAdDetailsProvider with ChangeNotifier{
  TextEditingController adTitleController = TextEditingController();
  TextEditingController adPriceController = TextEditingController();
  TextEditingController adDescriptionController = TextEditingController();
  Map<String,dynamic> selected = {};
  List<MetaFieldsModel> categoryMetaFields = [];
}