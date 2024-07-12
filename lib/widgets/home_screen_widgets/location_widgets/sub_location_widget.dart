import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:vivadoo/app_navigation.dart';
import 'package:vivadoo/models/filters/sub_area_model.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
import 'package:vivadoo/providers/filters/location_filter.dart';
import 'package:vivadoo/widgets/home_screen_widgets/location_widgets/location_search_bar.dart';

import '../../../models/filters/area_model.dart';
import '../../../utils/hive_manager.dart';
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
                                final locationFilterProvider = context.read<LocationFilterProvider>();
                                String route = HiveStorageManager.hiveBox.get('route');
                                int index = context.read<LocationFilterProvider>().selectedArea;
                                if(route == "SubLocationFilterFromFilter"){
                                  locationFilterProvider.tempCity = areaList[index].link;
                                  context.read<LocationFilterProvider>().setTempLocation("All Over ${areaList[context.read<LocationFilterProvider>().selectedArea].label}");
                                }else{
                                  locationFilterProvider.setCity(areaList[index].link);
                                  context.read<LocationFilterProvider>().setLocation("All Over ${areaList[context.read<LocationFilterProvider>().selectedArea].label}");
                                  context.read<FilterProvider>().showAds(context);
                                }
                                context.read<LocationFilterProvider>().cleanSubArea();
                                context.pop();
                                Future.delayed(const Duration(milliseconds: 300)).then((value) => context.pop());
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
                                            final locationFilterProvider = context.read<LocationFilterProvider>();
                                            String route = HiveStorageManager.hiveBox.get('route');
                                            context.read<LocationFilterProvider>().addToLocalRecent(subAreaList[index]);
                                            if(route == "SubLocationFilterFromFilter"){
                                              locationFilterProvider.setTempLocation(subAreaList[index].label);
                                              context.read<LocationFilterProvider>().tempCity = subAreaList[index].link;
                                            }else{
                                              locationFilterProvider.setLocation(subAreaList[index].label);
                                              locationFilterProvider.setCity(subAreaList[index].link);
                                              context.read<FilterProvider>().showAds(context);
                                            }
                                            context.read<LocationFilterProvider>().cleanSubArea();
                                            context.pop();
                                            Future.delayed(const Duration(milliseconds: 300)).then((value) => context.pop());
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
