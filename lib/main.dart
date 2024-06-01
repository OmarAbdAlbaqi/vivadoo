import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provideer.dart';
import 'package:vivadoo/providers/ads_provider/user_ads_screen_provider.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
import 'package:vivadoo/providers/filters/location_filter.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/providers/general/loading_provider.dart';
import 'package:vivadoo/providers/general/nav_bar_provider.dart';
import 'package:vivadoo/screens/app_init/splash_screen.dart';

import 'constants.dart';
import 'models/filters/hive/local_area_model.dart';

enum HomeType {home,filteredHome,filter,locationFilter,splash}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocalAreaModelAdapter());
  await Hive.openBox<LocalAreaModel>("recentLocations");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (context) => NavBarProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => LocationFilterProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
        ChangeNotifierProvider(create: (context) => FilteredAdsProvider()),
        ChangeNotifierProvider(create: (context) => AdDetailsProvider()),
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
        ChangeNotifierProvider(create: (context) => UserAdsScreenProvider()),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (context , child) {
          return Selector<HomePageProvider , HomeType>(
              selector: (context , prov) => prov.homeType,
            builder: (context ,homeType, _ ) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: homeType == HomeType.splash? null :homeType == HomeType.home || homeType == HomeType.filteredHome
                    ?
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  titleSpacing: 12,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            context.read<FilterProvider>().resetFilter();
                            context.read<FilteredAdsProvider>().setFirstAnimation(false);
                            Get.back();
                            context.read<HomePageProvider>().setHomeType(HomeType.home);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: homeType == HomeType.home ? 0 : 40,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded, color: Colors.black,),
                          )),
                      AnimatedContainer(
                        width: homeType == HomeType.home ? MediaQuery
                            .of(context)
                            .size
                            .width - 24 : MediaQuery
                            .of(context)
                            .size
                            .width - 71,
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
                ) :
                AppBar(
                  backgroundColor: Constants.appBarBackgroundColor,
                  leadingWidth: 65,
                  title: Text(switch(homeType){
                    HomeType.filter => "Refine",
                    HomeType.locationFilter => "Where are you looking?",
                    HomeType.home => "",
                    HomeType.filteredHome => "",
                    HomeType.splash => "",
                  },
                    style: const TextStyle(color: Color(0xFFffffff),fontWeight: FontWeight.w600 , fontSize: 16),
                  ),
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () {
                      // context.read<FilterProvider>().categoryMetaFields = [];
                      // context.read<FilterProvider>().makesList = [];
                      if(context.read<LocationFilterProvider>().fromFilter){
                       Get.back();
                        context.read<HomePageProvider>().setHomeType(HomeType.filter);
                        context.read<LocationFilterProvider>().setFromFilter(false);
                      } else {
                        Get.back();
                        context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                      }
                    },
                    child: Container(
                      height: 40,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded, color: Colors.white,),
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
                        child: const Text("Reset Filter" , style: TextStyle(color: Colors.white, fontSize: 14 , fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ],
                ),
                body: child,
              );
            }
          );
        },
        home: const SplashScreen(),
        theme: ThemeData(
          sliderTheme:  SliderThemeData(
            activeTrackColor: Constants.orange,
            inactiveTrackColor: Colors.grey,
            thumbColor: Constants.orange,
            overlayColor: Constants.orange.withOpacity(0.2),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            trackHeight: 1,
            rangeValueIndicatorShape: const RectangularRangeSliderValueIndicatorShape(
            ),

            valueIndicatorColor: Constants.orange,
            rangeThumbShape: const RoundRangeSliderThumbShape(
            )
          )
        ),
      ),
    );
  }
}