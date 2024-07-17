
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import '../../../models/filters/hive/local_area_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/filters/location_filter.dart';
import '../../../widgets/home_screen_widgets/location_widgets/location_search_bar.dart';

import '../../../models/filters/area_model.dart';
import '../../../models/filters/hive/recent_locations_box.dart';
import 'location_search_result_widget.dart';

class LocationFilterWidget extends StatelessWidget {
  const LocationFilterWidget({super.key});

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
            //search bar
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
                      GestureDetector(
                        onTap: () {
                          //TODO search near me
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          height: 60,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.my_location,
                                size: 25,
                                color: Color.fromRGBO(152, 152, 156, 1),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Near Me",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                        indent: 55,
                        color: Colors.grey.withOpacity(0.5),
                      ),

                      //all over country
                      GestureDetector(
                        onTap: () {
                          String route = HiveStorageManager.hiveBox.get('route');
                          final filteredProvider = context.read<LocationFilterProvider>();
                          if(route == "LocationFilterFromFilter"){
                            filteredProvider.setTempLocation("All Over Country");
                          }else{
                            filteredProvider.setCity("all-cities");
                            filteredProvider.setLocation("All Over Country");
                            context.read<FilterProvider>().showAds(context);
                          }
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          height: 60,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/filter_sorting/lebanon.png",
                                height: 25,
                                color: const Color.fromRGBO(133, 133, 133, 1),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "All Over Country",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider (
                        height: 0,
                        indent: 55,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 20,),

                      Visibility(
                        visible: RecentLocationBox.getLocalRecentLocations().listenable().value.isNotEmpty,
                        child: Selector<LocationFilterProvider , double>(
                            selector: (context , prov) => prov.recentValue,
                            builder: (context , value , _){
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: StickyHeader(
                                    callback: (value) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        value > -1 ?
                                        context.read<LocationFilterProvider>().setRecentLocationValue(value): null;
                                      });
                                    },
                                    header: Container(
                                      margin: const EdgeInsets.only( bottom: 6 ),
                                      padding: const EdgeInsets.only(left: 20),
                                      color: value <= 0 ? const Color.fromRGBO(237, 237, 237, 1) : Colors.transparent,
                                      width: double.infinity,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          const Text("Recent Location"),
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
                                    content: ValueListenableBuilder<Box<LocalAreaModel>>(
                                      valueListenable: RecentLocationBox.getLocalRecentLocations().listenable(),
                                      builder: (context , recentLocation , _){
                                        List<LocalAreaModel> items = recentLocation.values.toList().cast<LocalAreaModel>();
                                        return ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: items.length,
                                          itemBuilder: (context , index){
                                            return  InkWell(
                                              onTap: (){
                                                final locationFilterProvider = context.read<LocationFilterProvider>();
                                                String route = HiveStorageManager.hiveBox.get('route');
                                                if(route == "LocationFilterFromFilter"){
                                                  locationFilterProvider.setTempLocation("${items[index].label} - ${items[index].parentLabel}");
                                                  locationFilterProvider.tempCity = items[index].link;
                                                }else{
                                                  locationFilterProvider.setLocation(items[index].label);
                                                  locationFilterProvider.setCity(items[index].link);
                                                  context.read<FilterProvider>().showAds(context);
                                                }
                                                context.pop();
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 20),
                                                height: 40,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
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
                                                        Text(items[index].label , style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.w500),),
                                                        Text(items[index].parentLabel , style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w400),),
                                                      ],
                                                    ),
                                                    const Icon(Icons.keyboard_arrow_right , color: Color.fromRGBO(152, 152, 156, 1),)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                ),
                              );
                            }),
                      ),

                      //select region
                      Selector<LocationFilterProvider , double>(
                          selector: (context , prov) => prov.regionsValue,
                          builder: (context , value , _){
                            return StickyHeader(
                              callback: (value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.read<LocationFilterProvider>().setRegionsValue(value);
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

                              content: Selector<LocationFilterProvider , List<AreaModel>>(
                                  selector: (context , prov) => prov.areaList,
                                  builder: (context , areaList , _) {
                                    return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: areaList.length,
                                      itemBuilder: (context , index){
                                        return InkWell(
                                          onTap: (){
                                            String route = HiveStorageManager.hiveBox.get('route');
                                            if(route == "LocationFilterFromFilter"){
                                              context.push("/home/filteredHome/filter/locationFilterFromFilter/subLocationFilterFromFilter");
                                            }else if(route == "LocationFilterFromFilterHome") {
                                              context.push("/home/filterFromHome/locationFilterFromFilterHome/subLocationFilterFromFilterHome");
                                            } else {
                                              context.push("/home/filteredHome/locationFilterFromHome/subLocationFilterFromHome");
                                            }

                                            context.read<LocationFilterProvider>().getSubAreaList(areaList[index].code.toString());
                                            context.read<LocationFilterProvider>().setSelectedArea(index);
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
                                                    Text(areaList[index].label , style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.w500),),
                                                    Text(areaList[index].parentLabel , style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w400),),
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


