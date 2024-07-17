import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';

import '../../../models/filters/sub_area_model.dart';
import '../../../providers/filters/location_filter.dart';
import '../../../utils/hive_manager.dart';
Widget locationSearchResult (BuildContext context ){
  return Selector<LocationFilterProvider , List<SubAreaModel>>(
      selector: (context , prov) => prov.searchedResult,
      builder: (context , searchResult , _){
        return Visibility(
            visible: searchResult.isNotEmpty,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(top: 12 ),
              margin: const EdgeInsets.only(left: 12 , right: 60),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: searchResult.length  > 6 ? 380 : searchResult.length * 60,
              decoration: BoxDecoration(
                color: const Color(0xFFffffff),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.separated(
                itemCount: searchResult.length,
                itemBuilder: (context , index){
                  return GestureDetector(
                    onTap: (){
                      String route = HiveStorageManager.hiveBox.get('route');
                      final filterProvider = context.read<LocationFilterProvider>();
                      if(route == "LocationFilterFromFilter" || route == "SubLocationFilterFromFilter"){
                        filterProvider.setTempLocation("${searchResult[index].label} - ${searchResult[index].parentLabel}");
                      }else{
                        filterProvider.setCity(searchResult[index].link);
                        filterProvider.setLocation(searchResult[index].label);
                        context.read<FilteredAdsProvider>().getFilteredAds(context);
                      }
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
            )
        );
      });
}