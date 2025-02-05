import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';

import '../../../models/filters/sub_area_model.dart';
import '../../../providers/home_providers/filters/filter_provider.dart';
import '../../../providers/home_providers/filters/location_filter.dart';
import '../../../utils/hive_manager.dart';
Widget locationSearchResult (BuildContext context ){
  return Selector<LocationFilterProvider , List<SubAreaModel>>(
      selector: (context , prov) => prov.searchedResult,
      builder: (context , searchResult , _){
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.only(top: 12 ),
          margin: const EdgeInsets.only(left: 12 , right: 60),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: searchResult.isNotEmpty ? searchResult.length  > 6 ? 380 : searchResult.length * 60 : 0,
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.separated(
            itemCount: searchResult.length,
            itemBuilder: (context , index){
              return GestureDetector(
                onTap: (){
                  String route = HiveStorageManager.getCurrentRoute();
                  final filterProvider = context.read<LocationFilterProvider>();
                  if(route == "LocationFilterFromFilter" || route == "SubLocationFilterFromFilter"){
                    filterProvider.setTempLocation("${searchResult[index].label} - ${searchResult[index].parentLabel}");
                    filterProvider.city = searchResult[index].link;
                    if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
                      context.read<FilterProvider>().showAdsCount(context);
                    }

                    if(route == "LocationFilterFromFilter"){
                      context.pop();
                    }
                    if(route == "SubLocationFilterFromFilter"){
                      context.pop();
                      Future.delayed(const Duration(milliseconds: 300),(){
                        if(context.mounted){
                          context.pop();
                        }
                      });
                    }
                  }
                  else if (route == "Category And Location"){
                    context.read<CategoryAndLocationProvider>().setLocationLabel("${searchResult[index].parentLabel}-${searchResult[index].label}");
                    context.read<CategoryAndLocationProvider>().locationLink = searchResult[index].link;
                    context.read<CategoryAndLocationProvider>().storeLocationInHive(context,searchResult[index].link);
                    context.read<CategoryAndLocationProvider>().bottomSheetController?.close();
                  }
                  else{
                    filterProvider.setCity(searchResult[index].link);
                    filterProvider.setLocation(searchResult[index].label);
                    context.read<FilteredAdsProvider>().getFilteredAds(context);
                  }
                  filterProvider.textEditingController.clear();
                  Future.delayed(const Duration(seconds: 1), (){
                    filterProvider.searchedResult.clear();
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Icon(Icons.location_on , color: Colors.grey.withOpacity(0.4), size: 18,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(searchResult[index].label),
                          Text(searchResult[index].parentLabel),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context , index) => const Divider(thickness: 0,indent: 40,),
          ),
        );
      });
}