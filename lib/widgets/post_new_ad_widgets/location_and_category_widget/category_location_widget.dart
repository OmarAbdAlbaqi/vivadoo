import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';

import '../../../constants.dart';
import '../../../models/filters/area_model.dart';
import '../../../models/filters/category_model.dart';
import '../../../models/filters/hive/local_area_model.dart';
import '../../../models/filters/hive/recent_locations_box.dart';
import '../../../models/filters/sub_area_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/home_providers/filters/location_filter.dart';
import '../../../providers/post_new_ad_provider/steps_bar_widget_provider.dart';
import '../../home_screen_widgets/general_filter_widgets/category_and_sub-category/category_card.dart';
import '../../home_screen_widgets/location_widgets/location_search_bar.dart';
import '../../home_screen_widgets/location_widgets/location_search_result_widget.dart';
final GlobalKey<ScaffoldState> scaffoldKeyCateAndLocation = GlobalKey<ScaffoldState>();
class CategoryAndLocationWidget extends StatefulWidget {
   const CategoryAndLocationWidget({super.key});

  @override
  State<CategoryAndLocationWidget> createState() => _CategoryAndLocationWidgetState();
}

class _CategoryAndLocationWidgetState extends State<CategoryAndLocationWidget> with SingleTickerProviderStateMixin{

  late ScrollController scrollController;


  // PersistentBottomSheetController? _bottomSheetController;
  @override
  void initState() {
    // _bottomSheetController = context.watch<CategoryAndLocationProvider>().bottomSheetController;
    scrollController = ScrollController()..addListener(() {
      if(scrollController.position.pixels < -60){
        context.read<CategoryAndLocationProvider>().bottomSheetController?.close();
      }
    });
    final newTabController = TabController(length: 2, vsync: this);
    context.read<CategoryAndLocationProvider>().initTabController(context, newTabController);
    super.initState();
  }


  void _showBottomSheetLocation() {
    context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(true);
    context.read<CategoryAndLocationProvider>().bottomSheetController = scaffoldKeyCateAndLocation.currentState?.showBottomSheet(
          (context) => bottomSheetContentLocation(context)
    );

    context.read<CategoryAndLocationProvider>().bottomSheetController?.closed.whenComplete(() {
      context.read<CategoryAndLocationProvider>().tabController.index = 0;
      context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(false);
    });
  }

  void _showBottomSheetCategories() {
    context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(true);
    context.read<CategoryAndLocationProvider>().bottomSheetController = scaffoldKeyCateAndLocation.currentState?.showBottomSheet(
            (context) => bottomSheetContentCategories(context)
    );

    context.read<CategoryAndLocationProvider>().bottomSheetController?.closed.whenComplete(() {
      context.read<CategoryAndLocationProvider>().tabController.index = 0;
      context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.info, color: Color.fromRGBO(150, 150, 150, 0.8),size: 30,),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: const Text("Select the location of your item, people using search by city will find your ad more easily")),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showBottomSheetLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(245, 246, 247, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(-3, 3),
                          blurRadius: 4,
                          spreadRadius: -2,
                          color: Colors.black12
                      ),
                    ]
                ),
                alignment: Alignment.centerLeft,
                child: Selector<CategoryAndLocationProvider, String>(
                    selector: (context, prov) => prov.locationLabel,
                    builder: (context, locationLabel, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          locationLabel.isNotEmpty ? Text(locationLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),) :const Text("Select Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 , color: Color.fromRGBO(150, 150, 150, 1)),),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.orange.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Constants.orange.withOpacity(0.2),
                                      spreadRadius: -3,
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 6
                                  ),
                                ]
                            ),
                            child: const Icon(Icons.arrow_forward),
                          ),

                        ],
                      );
                    }
                ),
              ),
            ),

            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.info, color: Color.fromRGBO(150, 150, 150, 0.8),size: 30,),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: const Text("You will have a 50% more chance of being contacted if your ad is in the right category.")),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showBottomSheetCategories,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(245, 246, 247, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(-3, 3),
                          blurRadius: 4,
                          spreadRadius: -2,
                          color: Colors.black12
                      ),
                    ]
                ),
                alignment: Alignment.centerLeft,
                child: Selector<CategoryAndLocationProvider , String>(
                    selector: (context , prov) => prov.categoryLabel,
                    builder: (context , categoryLabel , _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          categoryLabel.isNotEmpty ?
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Text(categoryLabel, overflow: TextOverflow.ellipsis ,style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w500),)) :
                          const Text("Select Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 , color: Color.fromRGBO(150, 150, 150, 1)),),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.orange.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Constants.orange.withOpacity(0.2),
                                      spreadRadius: -3,
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 6
                                  ),
                                ]
                            ),
                            child: const Icon(Icons.arrow_forward),
                          ),

                        ],
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetContentLocation(BuildContext context){
    return Consumer<CategoryAndLocationProvider>(
      builder: (context, prov, child) {
        return Container(
          width: double.infinity,
          height: (MediaQuery.of(context).size.height * 0.8) - 17,
          color: Colors.white,
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
              context.read<LocationFilterProvider>().resetSearch();
            },
            child: Column(
              children: [

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  width: 80,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(4), right: Radius.circular(4)),
                  ),
                ),

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
                      ),
                    ],
                  ),
                  child: locationSearchBar(context),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      TabBarView(
                          controller: prov.tabController,
                          physics: prov.tabController.index == 1 ? const BouncingScrollPhysics(): const NeverScrollableScrollPhysics(),
                          children: [
                            ListView(
                              controller: prov.tabController.index == 1 ? null:scrollController,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                //near me
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
                                    prov.setLocationLabel("All Over Country");
                                    prov.locationLink = "all-cities";
                                    prov.bottomSheetController?.close();
                                    prov.storeLocationInHive(context,"all-cities");
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

                                //recent location
                                Visibility(
                                  visible: RecentLocationBox.getLocalRecentLocations().listenable().value.isNotEmpty,
                                  child: Selector<LocationFilterProvider , bool>(
                                      selector: (context , prov) => prov.stickRecentLocation,
                                      builder: (context , value , _){
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 25),
                                          child: StickyHeader(
                                              callback: (value) {
                                                context.read<LocationFilterProvider>().setRecentLocationValue(value);
                                              },
                                              header: Container(
                                                margin: const EdgeInsets.only( bottom: 6 ),
                                                padding: const EdgeInsets.only(left: 20),
                                                color: value  ? const Color.fromRGBO(237, 237, 237, 1) : Colors.transparent,
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
                                                        color: value ? Colors.grey.withOpacity(0.5) : Colors.transparent,
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
                                                          prov.setLocationLabel("${items[index].label} - ${items[index].parentLabel}");
                                                          prov.locationLink = items[index].link;
                                                          prov.storeLocationInHive(context,items[index].link);
                                                          prov.bottomSheetController?.close();
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
                                Selector<LocationFilterProvider , bool>(
                                    selector: (context , prov) => prov.stickSelectRegion,
                                    builder: (context , value , _){
                                      return StickyHeader(
                                        callback: (value) {
                                          context.read<LocationFilterProvider>().setRegionsValue(value);
                                        },
                                        header: Container(
                                          padding: const EdgeInsets.only(left: 20),
                                          color: value ? const Color.fromRGBO(237, 237, 237, 1) : Colors.transparent,
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
                                                  color: value? Colors.grey.withOpacity(0.5) : Colors.transparent,
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
                                                      context.read<LocationFilterProvider>().getSubAreaList(areaList[index].code.toString());
                                                      context.read<LocationFilterProvider>().setSelectedArea(index);
                                                      context.read<CategoryAndLocationProvider>().tabController.animateTo(1);
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
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Selector<LocationFilterProvider, bool>(
                                        selector: (context, prov) => prov.loading,
                                        builder: (context, loading, _){
                                          if(loading){
                                            return const Center(
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                          return GestureDetector(
                                            onTap: (){
                                              FocusScope.of(context).unfocus();
                                              context.read<LocationFilterProvider>().resetSearch();
                                            },
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      ListView(
                                                        controller: scrollController,
                                                        children: [
                                                          //all over area
                                                          Selector<LocationFilterProvider , List<AreaModel>>(
                                                              selector: (context , prov) => prov.areaList,
                                                              builder: (context , areaList , _) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    prov.setLocationLabel("All Over ${areaList[context.read<LocationFilterProvider>().selectedArea].label}");
                                                                    int index = context.read<LocationFilterProvider>().selectedArea;
                                                                    prov.locationLink = areaList[index].link;
                                                                    prov.storeLocationInHive(context,areaList[index].link);
                                                                    context.read<CategoryAndLocationProvider>().tabController.animateTo(0);
                                                                    Future.delayed(const Duration(milliseconds: 300)).then((value) =>  context.read<CategoryAndLocationProvider>().bottomSheetController?.close());
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
                                                                                prov.setLocationLabel("${subAreaList[index].label} - ${subAreaList[index].parentLabel}");
                                                                                prov.locationLink = subAreaList[index].link;
                                                                                prov.storeLocationInHive(context,subAreaList[index].link);
                                                                                context.read<LocationFilterProvider>().cleanSubArea();
                                                                                context.read<CategoryAndLocationProvider>().tabController.animateTo(0);
                                                                                Future.delayed(const Duration(milliseconds: 300)).then((value) =>  Navigator.pop(context));
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
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          );
                                          },
                              )

                            ),
                          ]
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
    );
  }

  Widget bottomSheetContentCategories(BuildContext context){
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height * 0.8) - 17,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 13),
            width: 80,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(4), right: Radius.circular(4)),
            ),
          ),
          Selector<FilteredAdsProvider , List<CategoryModel>>(
              selector: (ctx , prov) => prov.categoryList,
              builder: (ctx , categoryList , _) {
                return SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.8) - 57,
                  child: ListView.builder(
                    physics: context.watch<CategoryAndLocationProvider>().bottomSheetOnTop ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount:  categoryList.length ,
                    itemBuilder: (ctx, int index) {
                      return categoryCard(ctx , categoryList[index] ,  index);
                    },
                  ),
                );
              }
          ),
        ],
      ),
    );
  }

}

