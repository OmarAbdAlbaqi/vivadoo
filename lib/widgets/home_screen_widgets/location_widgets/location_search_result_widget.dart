import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';

import '../../../models/filters/sub_area_model.dart';
import '../../../providers/filters/location_filter.dart';
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
                      final filterProvider = context.read<LocationFilterProvider>();
                      if(context.read<LocationFilterProvider>().fromFilter){
                        filterProvider.setTempLocation(searchResult[index].label);
                        context.read<HomePageProvider>().setHomeType(HomeType.filter);
                        // tabController.animateTo(2);
                        context.read<LocationFilterProvider>().setFromFilter(false);
                      }else{
                        filterProvider.setCity(searchResult[index].link);
                        filterProvider.setLocation(searchResult[index].label);
                        context.read<FilteredAdsProvider>().getFilteredAds(context, false);
                        context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                        // tabController.animateTo(1);
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