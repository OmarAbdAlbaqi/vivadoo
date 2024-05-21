import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../providers/ads_provider/filtered_ads_provideer.dart';
import '../../../providers/general/home_page_provider.dart';

Widget searchResult (BuildContext context){
  return Selector<HomePageProvider , List<String>>(
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
              height: searchResult.length  > 6 ? 240 : searchResult.length * 30,
              decoration: BoxDecoration(
                color: const Color(0xFFffffff),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.separated(
                itemCount: searchResult.length,
                itemBuilder: (context , index){
                  return GestureDetector(
                    onTap: (){
                      final filterProvider = context.read<FilteredAdsProvider>();
                      filterProvider.resetFilter();
                      filterProvider.setQuery(searchResult[index]);
                        filterProvider.getFilteredAds(context, false);
                        context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                        // tabController.animateTo(1);
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
                          Text(searchResult[index]),
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