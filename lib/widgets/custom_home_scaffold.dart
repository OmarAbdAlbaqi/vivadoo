import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';

import '../main.dart';
import '../models/ad_model.dart';
import '../providers/ads_provider/ad_details_provider.dart';
import '../providers/ads_provider/filtered_ads_provider.dart';
import '../providers/filters/filter_provider.dart';
import '../providers/filters/location_filter.dart';
import '../providers/general/home_page_provider.dart';
import '../utils/hive_manager.dart';
class CustomHomeScaffold extends StatelessWidget {
  const CustomHomeScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HiveStorageManager.hiveBox.listenable(),
      builder: (context, hiveBox, widget) {
          String page = hiveBox.get('route');
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: page == "Home" || page == "FilteredHome"
              ?
          AppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: context.watch<HomePageProvider>().height,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            titleSpacing: 12,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      context.read<FilteredAdsProvider>().page = 1;
                      List<AdModel> adsList = context.read<AdsProvider>().adsList;
                      context.read<AdDetailsProvider>().setListOfAdDetails(adsList, clearList: true);
                      context.read<FilterProvider>().resetFilter();
                      context.read<FilteredAdsProvider>().setFirstAnimation(false);
                      context.pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: page == "Home" ? 0 : 40,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded, color: Colors.black,),
                    )),
                AnimatedContainer(
                  width: page == "Home" ? MediaQuery.of(context).size.width - 24:
                  MediaQuery.of(context).size.width - 71,
                  height: 45,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          blurStyle: BlurStyle.solid,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          spreadRadius: -1,
                          blurRadius: 4,
                          offset: Offset(0.1, 0)),
                      BoxShadow(
                          blurStyle: BlurStyle.solid,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          spreadRadius: -1,
                          blurRadius: 4,
                          offset: Offset(-0.1, 0)),
                      BoxShadow(
                          blurStyle: BlurStyle.solid,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          spreadRadius: -1,
                          blurRadius: 4,
                          offset: Offset(0, 0.1)),
                      BoxShadow(
                          blurStyle: BlurStyle.solid,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          spreadRadius: -1,
                          blurRadius: 4,
                          offset: Offset(0, -0.1)),
                    ],
                    color: const Color.fromRGBO(229, 229, 229, 1),
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: TextFormField(
                    controller: context.watch<HomePageProvider>().textEditingController,
                    onChanged: (value) {
                      if (value.length >= 2) {
                        context.read<HomePageProvider>().autoCompleteSearch(value);
                      } else {
                        context.read<HomePageProvider>().resetSearch();
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.transparent,
                                width: 0),
                            borderRadius: BorderRadius.circular(8)),
                        hintText: "Search Vivadoo",
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300, color: Color.fromRGBO(
                            88, 89, 91, 0.6)),
                        contentPadding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 0,
                            bottom: 0),
                        prefixIcon: const Icon(
                            Icons.search, size: 35, color: Color.fromRGBO(88,
                            89, 91, 0.6)),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic_rounded, size: 30,
                              color: Color.fromRGBO(88, 89, 91, 0.7)),
                        )
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ):
          AppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 55,
            backgroundColor: Colors.white,
            leadingWidth: 65,
            bottom: const PreferredSize(
              preferredSize: Size(0, 0),
              child: Divider(
                height: 0,
                thickness: 0.5,
              ),
            ),
            title: Text(
              switch(page){
              "Filter" || "FilterFromHome" => "Refine",
              "LocationFilterFromFilter" || "LocationFilterFromHome" || "SubLocationFilterFromFilter" || "SubLocationFilterFromHome" || "LocationFilterFromFilterHome" || "SubLocationFilterFromFilterHome" => "Where are you looking?",
              _ => ""
            },
              style: const TextStyle(color: Color(0xFF000000),fontWeight: FontWeight.w600 , fontSize: 16),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {

                context.read<LocationFilterProvider>().tempLocation = "";
                context.pop();
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded, color: Colors.black,),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: (){
                  context.read<FilterProvider>().clearFilter(context);
                },
                child: Container(
                  width: 120,
                  height: 50,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: const Text("Reset Filter" , style: TextStyle(color: Colors.indigoAccent, fontSize: 14 , fontWeight: FontWeight.w500),),
                ),
              ),
            ],
          ),
          body: child,
        );
      }
    );
  }
}
