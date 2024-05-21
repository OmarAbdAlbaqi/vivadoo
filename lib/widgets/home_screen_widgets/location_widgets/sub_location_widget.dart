import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/models/filters/sub_area_model.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';
import 'package:vivadoo/providers/filters/location_filter.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/widgets/home_screen_widgets/location_widgets/location_search_bar.dart';

import '../../../models/filters/area_model.dart';
import 'location_search_result_widget.dart';



class SubLocationWidget extends StatelessWidget {
  const SubLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          context.read<LocationFilterProvider>().resetSearch();
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(6),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0.0, 0.5),
                    blurRadius: 2,
                    spreadRadius: -1,
                  )
                ],
              ),
              child: locationSearchBar(context),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Selector<LocationFilterProvider , List<AreaModel>>(
                          selector: (context , prov) => prov.areaList,
                          builder: (context , areaList , _) {
                            return GestureDetector(
                              onTap: () {
                                if(context.read<LocationFilterProvider>().fromFilter){
                                  context.read<FilteredAdsProvider>().setTempLocation("All Over ${areaList[context.read<LocationFilterProvider>().selectedArea].label}");
                                  context.read<HomePageProvider>().setHomeType(HomeType.filter);
                                  Get.back();
                                  context.read<FilteredAdsProvider>().setFilterCounter();
                                  context.read<LocationFilterProvider>().setFromFilter(false);
                                }else{
                                  int index = context.read<LocationFilterProvider>().selectedArea;
                                  String link = areaList[index].link;
                                  context.read<FilteredAdsProvider>().setLocation("All Over ${areaList[context.read<LocationFilterProvider>().selectedArea].label}");
                                  context.read<FilteredAdsProvider>().setCity(link);
                                  context.read<FilteredAdsProvider>().getFilteredAds(context, false);
                                  context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                                  Get.back();
                                  context.read<FilteredAdsProvider>().setFilterCounter();
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All Over ${areaList[context.watch<LocationFilterProvider>().selectedArea].label}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),

                              ),
                            );
                          }
                      ),
                      const SizedBox(height: 25),
                      Selector<LocationFilterProvider , double>(
                          selector: (context , prov) => prov.subAreaValue,
                          builder: (context , value , _){
                            return StickyHeader(
                              callback: (value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.read<LocationFilterProvider>().setSubAreaValue(value);
                                });
                              },
                              header: Container(
                                padding: const EdgeInsets.only(left: 20),
                                color: value <= 0 ? const Color.fromRGBO(237, 237, 237, 1) : Colors.transparent,
                                width: double.infinity,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    const Text("Select Region"),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Divider(
                                        height: 0,
                                        color: value > 0 ? Colors.grey.withOpacity(0.5) : Colors.transparent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              content: Selector<LocationFilterProvider , List<SubAreaModel>>(
                                  selector: (context , prov) => prov.subAreaList,
                                  builder: (context , subAreaList , _) {
                                    return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: subAreaList.length,
                                      itemBuilder: (context , index){
                                        return InkWell(
                                          onTap: (){
                                            final filterProvider = context.read<FilteredAdsProvider>();
                                            if(context.read<LocationFilterProvider>().fromFilter){
                                              context.read<LocationFilterProvider>().addToLocalRecent(subAreaList[index]);
                                              context.read<HomePageProvider>().setHomeType(HomeType.filter);
                                              filterProvider.setTempLocation(subAreaList[index].label);
                                              String link = subAreaList[index].link;
                                              context.read<FilteredAdsProvider>().setCity(link);
                                              Get.back();
                                              Get.back();
                                              context.read<FilteredAdsProvider>().setFilterCounter();
                                              context.read<LocationFilterProvider>().cleanSubArea();
                                              context.read<LocationFilterProvider>().setFromFilter(false);
                                            }else{
                                              context.read<LocationFilterProvider>().addToLocalRecent(subAreaList[index]);
                                              context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                                              filterProvider.setLocation(subAreaList[index].label);
                                              filterProvider.setCity(subAreaList[index].link);
                                              filterProvider.getFilteredAds(context, false);
                                              Get.back();
                                              context.read<FilteredAdsProvider>().setFilterCounter();
                                              context.read<LocationFilterProvider>().cleanSubArea();
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 20),
                                            padding: const EdgeInsets.only(right: 10),
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                                              ),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(subAreaList[index].label , style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.w500),),
                                                    Text(subAreaList[index].parentLabel , style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w400),),
                                                  ],
                                                ),
                                                const Icon(Icons.keyboard_arrow_right , color: Color.fromRGBO(152, 152, 156, 1),)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              ),
                            );
                          }),
                      const SizedBox(height: 25),
                    ],
                  ),
                  locationSearchResult(context),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
