import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/widgets/ad_cards/native_ad_card.dart';
import 'package:vivadoo/widgets/home_screen_widgets/general_filter_widgets/filter_widget.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../models/ad_model.dart';
import '../ad_cards/full_width_card_standard.dart';

class FilteredHomePage extends StatelessWidget {
   FilteredHomePage({super.key,  required this.scrollController});
      final ScrollController scrollController;
      final RefreshController refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: PopScope(
        canPop: true,
        onPopInvoked: (value) async {
          context.read<FilterProvider>().resetFilter();
          context.read<HomePageProvider>().setHomeType(HomeType.home);
        },
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: true,
          child:
          SmartRefresher(
            header: CustomHeader(
              builder: (BuildContext context, RefreshStatus? mode) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: const CupertinoActivityIndicator(),
                );
              },
            ),
            onRefresh: () async {
              await context.read<FilteredAdsProvider>().getFilteredAds(context , false);
              refreshController.refreshCompleted();
            },
            controller: refreshController,
            semanticChildCount: 2,
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  height: 55,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              ()=> const FilterWidget(),
                            transition: Transition.rightToLeft,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 250),
                          );
                          context.read<HomePageProvider>().setHomeType(HomeType.filter);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          width: 115,
                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromRGBO(240, 240, 240, 0.5),
                                width: 1),
                            boxShadow: const [
                              BoxShadow(
                                  blurStyle: BlurStyle.solid,
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0.1, 0)),
                              BoxShadow(
                                  blurStyle: BlurStyle.solid,
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(-0.1, 0)),
                              BoxShadow(
                                  blurStyle: BlurStyle.solid,
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 0.1)),
                              BoxShadow(
                                  blurStyle: BlurStyle.solid,
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, -0.1)),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/filter_sorting/filter.png",
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text("Filters"),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.orange,
                                child: Text(
                                  context.watch<FilteredAdsProvider>().filterCounter.toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFffffff),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // tabController.animateTo(3);
                          context.read<HomePageProvider>().setHomeType(HomeType.locationFilter);
                        },
                        child: Selector<FilteredAdsProvider , String>(
                            selector: (context , prov) => prov.location,
                            builder: (context , location , _) {
                              bool locationExist = location != "All Over Country";
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(locationExist ? 0: 20),
                                    bottomRight: Radius.circular(locationExist ? 0: 20),
                                    topLeft: const Radius.circular(20),
                                    bottomLeft: const Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromRGBO(240, 240, 240, 0.5),
                                      width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurStyle: BlurStyle.solid,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0.1, 0)),
                                    BoxShadow(
                                        blurStyle: BlurStyle.solid,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(-0.1, 0)),
                                    BoxShadow(
                                        blurStyle: BlurStyle.solid,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 0.1)),
                                    BoxShadow(
                                        blurStyle: BlurStyle.solid,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, -0.1)),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image.asset("assets/icons/filter_sorting/filter.png" , height: 20,),
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(location),
                                    // const SizedBox(width: 8),
                                  ],
                                ),
                              );
                            }
                        ),
                      ),
                      const SizedBox(width: 4),
                      Visibility(
                        visible: context.watch<FilteredAdsProvider>().location != "All Over Country",
                        child:  GestureDetector(
                          onTap: () {
                            context.read<FilteredAdsProvider>().setRadiusSliderVisible();
                          },
                          child: Selector<FilteredAdsProvider , String>(
                              selector: (context , prov) => prov.location,
                              builder: (context , location , _) {
                                bool locationExist = location != "All Over Country";
                                return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        topLeft:  Radius.circular(locationExist ? 0: 20),
                                        bottomLeft:  Radius.circular(locationExist ? 0: 20),
                                      ),
                                      color: Constants.orange,
                                      boxShadow: const [
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Constants.orange,
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0.1, 0)),
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Colors.white,
                                            spreadRadius: -3,
                                            blurRadius: 1,
                                            offset: Offset(-0.1, 0)),
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Constants.orange,
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0, 0.1)),
                                        BoxShadow(
                                          blurStyle: BlurStyle.solid,
                                          color: Constants.orange,
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, -0.1),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Selector<FilteredAdsProvider , String>(
                                      selector: (context , prov) => prov.radius,
                                      builder: (context , radius , _){
                                        return Text("$radius KM" , style: const TextStyle(color: Color(0xFFffffff) , fontWeight: FontWeight.w500),);
                                      },
                                    )
                                );
                              }
                          ),
                        ),),
                      const SizedBox(width: 8),
                      Selector<FilterProvider , Sorting>(
                          selector: (context , prov) => prov.sorting,
                          builder: (context , sorting , _) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 3 , bottom: 3 , right: 3),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/filter_sorting/up_down_arrow.png",
                                        height: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text("Sort"),
                                    ],
                                  ),

                                  items: [
                                    DropdownMenuItem(
                                      onTap: (){
                                        context.read<FilterProvider>().setSorting(Sorting.mostRecent);
                                        //TODO sorting
                                      },
                                      value: "most recent",
                                      child: Container(
                                          alignment: AlignmentDirectional.center,
                                          height: 45,
                                          child: Stack(
                                            children: [
                                              Center(child: Text("Most Recent", style: TextStyle(fontSize: 14 , color: sorting == Sorting.mostRecent ? Colors.red : Colors.black , fontWeight: FontWeight.w300),)),
                                              const Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Divider(
                                                  thickness: 2,
                                                  color: Color.fromRGBO(240, 240, 240, 1),
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    DropdownMenuItem(
                                      onTap: () => context.read<FilterProvider>().setSorting(Sorting.priceL2H),
                                      value: "pricel2h",
                                      child: Container(
                                          alignment: AlignmentDirectional.center,
                                          height: 45,
                                          child: Stack(
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets.only(bottom: 4),
                                                  alignment: Alignment.center,
                                                  child: Text("Price(Low to High)", style: TextStyle(fontSize: 14 , color: sorting == Sorting.priceL2H ? Colors.red : Colors.black , fontWeight: FontWeight.w300),)),
                                              const Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Divider(
                                                  thickness: 2,
                                                  color: Color.fromRGBO(240, 240, 240, 1),
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    DropdownMenuItem(
                                      onTap: () => context.read<FilterProvider>().setSorting(Sorting.priceH2L),
                                      value: "priceh2l",
                                      child: Container(
                                          alignment: AlignmentDirectional.center,
                                          child: Text("Price(High to Low)" , style: TextStyle(fontSize: 14 , color: sorting == Sorting.priceH2L ? Colors.red : Colors.black,  fontWeight: FontWeight.w300),)),
                                    ),
                                  ],
                                  onChanged: (String? value) {
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color.fromRGBO(240, 240, 240, 0.5),
                                          width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0.1, 0)),
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(-0.1, 0)),
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0, 0.1)),
                                        BoxShadow(
                                            blurStyle: BlurStyle.solid,
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0, -0.1)),
                                      ],
                                    ),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.indigoAccent,
                                      size: 20,
                                    ),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    padding: EdgeInsets.zero,
                                    maxHeight: 200,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(0, -11),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                      padding: EdgeInsets.zero
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
                Selector<FilteredAdsProvider , List<AdModel>>(
                    selector: (context , prov) => prov.filteredAdsList,
                    builder: (context , ads , _) {
                      return Column(
                        children: [
                          Selector<FilteredAdsProvider , bool>(
                              selector: (context , prov) => prov.radiusSliderVisible,
                              builder: (context , visible , _) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  height: visible && context.watch<FilteredAdsProvider>().location != "All Over Country" ? 120 : 0,
                                  color: const Color(0xFFffffff),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Choose distance" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
                                            Text("${context.watch<FilteredAdsProvider>().radius} KM" , style: const TextStyle(color: Constants.orange , fontSize: 16 , fontWeight: FontWeight.w500),)
                                          ],
                                        ),
                                      ),
                                      Slider(
                                        activeColor: Constants.orange,
                                        thumbColor: Colors.white,
                                        divisions: 950,
                                        min: 5,
                                        max: 100,
                                        value: double.parse(context.watch<FilteredAdsProvider>().radius),
                                        onChanged: (value){
                                          double myDouble = value;
                                          String myString = myDouble.toStringAsFixed(0); // Convert double to string with 0 decimal places
                                          String result = myString.split('.')[0];
                                          context.read<FilteredAdsProvider>().setRadius(result);
                                        },
                                        onChangeEnd: (value){
                                          context.read<FilteredAdsProvider>().getFilteredAds(context, false);
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 6),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("5 KM" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
                                            Text("100 KM" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ads.length,
                              itemBuilder: (context , index){
                                return ads.isEmpty ? const Center() : AnimationLimiter(
                                  child: AnimationConfiguration.synchronized(
                                      duration: const Duration(milliseconds: 300),
                                      child: SlideAnimation(
                                          duration: const Duration(milliseconds: 300),
                                          verticalOffset: context.watch<FilteredAdsProvider>().firstAnimation ? 0 : 120,
                                          child:
                                          ads[index].typeAd == "native"  && index == 0?
                                          NativeAdCard(adModel: ads[index]):
                                          FullWidthStandardAdCard(adModel: ads[index]))),
                                );
                              }),
                        ],
                      );
                    }
                ),
                Selector<FilteredAdsProvider , bool>(
                  selector: (context , prov) => prov.loading,
                  builder: (context , loading , _){
                    return Visibility(
                        visible: loading,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          child: const CupertinoActivityIndicator(
                          ),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
