import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/home_providers/home_search_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import '../../providers/ads_provider/filtered_ads_provider.dart';
import '../../providers/home_providers/filters/filter_provider.dart';

Widget searchResult (BuildContext context ){
  return Consumer<HomeSearchProvider>(
      builder: (_ , searchResult , child){
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.only(top: 12 ),
          margin: const EdgeInsets.only(left: 12 , right: 12),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: searchResult.searchedResult.isNotEmpty? searchResult.searchedResult.length  > 6 ? 240 : searchResult.searchedResult.length * 45 : 0,
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.separated(
            itemCount: searchResult.searchedResult.length,
            itemBuilder: (context , index){
              return GestureDetector(
                onTap: () async {
                  context.read<HomeSearchProvider>().searchFocusNode.unfocus();
                  context.read<FilterProvider>().clearFilter(context);
                  searchResult.textEditingController.text = searchResult.searchedResult[index];
                  context.read<FilterProvider>().setFilterParams({"keywords" : searchResult.searchedResult[index]}, "add");
                  context.read<FilteredAdsProvider>().getFilteredAds(context);
                  searchResult.resetSearch();
                  if(HiveStorageManager.hiveBox.get('route') != "FilteredHome"){
                    context.push('/home/filteredHome');
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 25,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Icon(Icons.search , color: Colors.grey.withOpacity(0.4), size: 18,),
                      ),
                      Text(searchResult.searchedResult[index]),
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