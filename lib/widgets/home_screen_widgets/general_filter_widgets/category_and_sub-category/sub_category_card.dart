import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/filters/sub_category_model.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../../../providers/home_providers/filters/filter_provider.dart';
Widget subCategoryCard (BuildContext context , SubCategoryModel subCategoryModel , int categoryId){
  return GestureDetector(
    onTap: (){
      if(HiveStorageManager.getCurrentRoute() == "Category And Location"){
        context.read<CategoryAndLocationProvider>().setCategoryLabel(subCategoryModel.name);
        context.read<CategoryAndLocationProvider>().categoryLink = subCategoryModel.cat_link;
        context.read<CategoryAndLocationProvider>().storeCategoryInHive(context,subCategoryModel.cat_link);
        context.read<CategoryAndLocationProvider>().bottomSheetController?.close();
      }else{
        context.read<FilterProvider>().makeLink = "";
        context.read<FilterProvider>().resetFilter(context);
        context.read<FilterProvider>().categoryId = subCategoryModel.parent;
        context.read<FilterProvider>().subCategoryId = subCategoryModel.id;
        context.read<FilterProvider>().setCategoryMetaFields(context);
        context.read<FilterProvider>().showAdsCount(context);
        Navigator.pop(context);
      }

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
          Text(context.read<FilterProvider>().adsCount!.categories[subCategoryModel.cat_link].toString(), style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Color(0xFF000000)),),
        ],
      ),
    ),
  );
}