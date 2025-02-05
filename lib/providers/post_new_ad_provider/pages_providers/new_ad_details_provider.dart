import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';

class NewAdDetailsProvider with ChangeNotifier{
  TextEditingController adTitleController = TextEditingController();
  TextEditingController adPriceController = TextEditingController();
  TextEditingController adDescriptionController = TextEditingController();
  bool currencyIsLbp = true;
  changeCurrency(){
    currencyIsLbp =! currencyIsLbp;
    notifyListeners();
  }

  storeTitleInHive(BuildContext context, String value){
    context.read<PostNewAdProvider>().updateAdField('title', value);
  }

  storePriceInHive(BuildContext context, String value){
    context.read<PostNewAdProvider>().updateAdField('price', value);
  }

  storeDescriptionInHive(BuildContext context ,String value){
    context.read<PostNewAdProvider>().updateAdField('description', value);
  }
}