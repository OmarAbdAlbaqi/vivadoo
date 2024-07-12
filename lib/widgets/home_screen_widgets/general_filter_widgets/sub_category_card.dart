import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/filters/sub_category_model.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
Widget subCategoryCard (BuildContext context , SubCategoryModel subCategoryModel , int categoryId){
  return GestureDetector(
    onTap: (){
      context.read<FilterProvider>().makeLink = "";
      context.read<FilterProvider>().resetFilter();
      context.read<FilterProvider>().categoryId = subCategoryModel.parent;
      context.read<FilterProvider>().subCategoryId = subCategoryModel.id;
      context.read<FilterProvider>().setCategoryMetaFields(context);
      Navigator.pop(context);
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width - 24,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subCategoryModel.name , style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.w500 , color: Color(0xFF000000)),),
          Text(subCategoryModel.id.toString(), style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Color(0xFF000000)),),
        ],
      ),
    ),
  );
}