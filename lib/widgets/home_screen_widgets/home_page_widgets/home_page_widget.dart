import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vivadoo/providers/home_providers/home_search_provider.dart';
import '../../../constants.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/home_providers/filters/filter_provider.dart';
import '../../../providers/home_providers/filters/location_filter.dart';
import '../../ad_cards/ad_card_for_home_page.dart';
import '../search_result_for_home_and_filtered-home.dart';
import '../../../providers/ads_provider/ads_provider.dart';

import '../../../models/ad_model.dart';
import '../../../providers/home_providers/home_page_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    bool firstAnimate = context.watch<HomePageProvider>().firstAnimated;
    return Consumer<HomePageProvider>(
      builder: (context, homeProv, _) {
        return Stack(
          children: [

            //home page ads
            SmartRefresher(
              onRefresh: ()async {
                await context.read<AdsProvider>().getAds(context);
                homeProv.refreshController.refreshCompleted();
              },
              header: WaterDropHeader(
                refresh: Container(
                  padding: const EdgeInsets.only(top: 110, bottom: 20),
                  alignment: Alignment.center,
                  child: const CupertinoActivityIndicator(),
                ),
              ),
              enablePullUp: false,
              controller: homeProv.refreshController,
              child: ListView(
                controller: homeProv.scrollController,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    height: homeProv.isScrollingUp ? 0 : 80,),
                  Selector<AdsProvider , List<AdModel>>(
                      selector: (context , prov) => prov.adsList,
                      builder: (context , ads , _) {
                        return AnimationLimiter(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ads.length,
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2 , mainAxisSpacing: 12 , childAspectRatio: 0.8),
                              itemBuilder: (context , index){
                                return AnimationConfiguration.synchronized(
                                  duration: const Duration(seconds: 500),
                                  child: SlideAnimation(
                                    duration: const Duration(milliseconds: 500),
                                    verticalOffset: firstAnimate ? 120 : 0,
                                    child: AdCardForHomePage(
                                      adModel: ads[index],
                                      index: index,
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                  ),
                  Visibility(
                      visible: homeProv.homePageLoading,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        height: 64,
                        alignment: Alignment.center,
                        child: const CupertinoActivityIndicator(
                        ),
                      )),
                ],
              ),
            ),

            //home page filter tabs
            Selector<HomePageProvider , bool>(
              selector: (context , prov) => prov.isScrollingUp,
              builder: (context , isScrollingUp , _){
                return AnimatedPositioned(
                  top: isScrollingUp ? -78 : 0,
                  left: 0,
                  right: 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic,
                  child:  AnimatedOpacity(
                    opacity: isScrollingUp ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12 , 8 , 12 , 6),
                      width: Constants.width(context),
                      height: 78,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          //property
                          HomePageFilterCard(
                              scrollController: homeProv.scrollController,
                              onTap: (){
                                context.read<LocationFilterProvider>().location = AppLocalizations.of(context)!.all_over_country;
                                context.read<FilterProvider>().categoryId = 0;
                                context.read<FilterProvider>().subCategoryId = 2;
                                context.read<FilterProvider>().setCategoryMetaFields(context);
                                context.read<FilterProvider>().setFilterParams(
                                    {
                                      "category": "property",
                                      "with_featured": "1"
                                    },
                                    "add");
                                context.read<FilterProvider>().setCategoryLabel("Real Estate");
                                context.read<FilterProvider>().getAdsCount(context, temp: true , extraParams: context.read<FilterProvider>().filterParams);
                                context.read<FilteredAdsProvider>().getFilteredAds(context );
                                context.push('/home/filteredHome');
                              },
                              imagePath: "assets/icons/filter_search/house.png",
                              title: AppLocalizations.of(context)!.property),

                          //cars
                          HomePageFilterCard(
                              scrollController: homeProv.scrollController,
                              onTap: (){
                                context.read<LocationFilterProvider>().location = AppLocalizations.of(context)!.all_over_country;
                                context.read<FilterProvider>().categoryId = 1;
                                context.read<FilterProvider>().subCategoryId = 10;
                                context.read<FilterProvider>().setCategoryMetaFields(context);
                                context.read<FilterProvider>().setFilterParams(
                                  {
                                    "category" : "motors",
                                    "subCategory" : "cars",
                                    "with_featured" : "1",
                                  },
                                  "add",
                                );
                                context.read<FilterProvider>().setCategoryLabel("Cars For Sale");
                                context.read<FilterProvider>().getAdsCount(context, temp: true , extraParams: context.read<FilterProvider>().filterParams);
                                context.read<FilteredAdsProvider>().getFilteredAds(context );
                                context.push('/home/filteredHome');
                              },
                              imagePath: "assets/icons/filter_search/car.png",
                              title: AppLocalizations.of(context)!.cars,
                          ),

                          //job
                          HomePageFilterCard(
                              scrollController: homeProv.scrollController,
                              onTap: (){
                                context.read<LocationFilterProvider>().location = AppLocalizations.of(context)!.all_over_country;
                                context.read<FilterProvider>().categoryId = 0;
                                context.read<FilterProvider>().subCategoryId = 4;
                                context.read<FilterProvider>().setCategoryMetaFields(context);
                                context.read<FilterProvider>().setFilterParams(
                                  {
                                    "category" : "jobs",
                                    "with_featured" : "1",
                                  },
                                  "add",
                                );
                                context.push('/home/filteredHome');
                                context.read<FilterProvider>().setCategoryLabel("Jobs");
                                context.read<FilterProvider>().getAdsCount(context, temp: true , extraParams: context.read<FilterProvider>().filterParams);
                                context.read<FilteredAdsProvider>().getFilteredAds(context );
                              },
                              imagePath: "assets/icons/filter_search/search.png",
                              title: AppLocalizations.of(context)!.jobs,
                          ),

                          //for sale
                          HomePageFilterCard(
                              scrollController: homeProv.scrollController,
                              onTap: (){
                                context.read<LocationFilterProvider>().location = AppLocalizations.of(context)!.all_over_country;
                                context.read<FilterProvider>().categoryId = 0;
                                context.read<FilterProvider>().subCategoryId = 3;
                                context.read<FilterProvider>().setCategoryMetaFields(context);
                                context.read<FilterProvider>().setFilterParams(
                                  {
                                    "category" : "for-sale",
                                    "with_featured" : "1",
                                  },
                                  "add",
                                );
                                context.push('/home/filteredHome');
                                context.read<FilterProvider>().setCategoryLabel("For Sale");
                                context.read<FilterProvider>().getAdsCount(context, temp: true , extraParams: context.read<FilterProvider>().filterParams);
                                context.read<FilteredAdsProvider>().getFilteredAds(context );
                              },
                              imagePath: "assets/icons/filter_search/check.png",
                              title: AppLocalizations.of(context)!.for_sales,
                          ),

                          //more
                          HomePageFilterCard(
                              scrollController: homeProv.scrollController,
                              onTap: (){
                                context.read<LocationFilterProvider>().location = AppLocalizations.of(context)!.all_over_country;
                                context.go('/home/filterFromHome', extra: {'showDialog': true});
                              },
                              imagePath: "assets/icons/filter_search/more.png",
                              title: AppLocalizations.of(context)!.more,
                          )
                        ],
                      ),
                    ),
                  ),

                );
              },
            ),

            Consumer<HomeSearchProvider>(
              builder: (context, search, _) {
                return Visibility(
                  visible: search.searchedResult.isNotEmpty || search.searchFocusNode.hasFocus,
                  child: GestureDetector(
                    onTap: (){
                      search.searchedResult.clear();
                      search.searchFocusNode.unfocus();

                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                );
              }
            ),
            searchResult(context),
          ],
        );
      }
    );
  }
}

class HomePageFilterCard extends StatelessWidget {
  const HomePageFilterCard({super.key, required this.scrollController, required this.onTap, required this.imagePath, required this.title});
  final ScrollController scrollController;
  final void Function() onTap;
  final String imagePath;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(10),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(229, 229, 229, 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(imagePath, width: 25,height: 25,color: Colors.black,),
          ),
           Text(title , style: const TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.black),),
        ],
      ),
    );
  }
}
