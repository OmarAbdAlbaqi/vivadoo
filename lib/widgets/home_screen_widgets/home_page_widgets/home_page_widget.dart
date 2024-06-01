import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../providers/ads_provider/filtered_ads_provideer.dart';
import '../../../providers/filters/filter_provider.dart';
import '../../../widgets/home_screen_widgets/filtered_home_page.dart';
import '../../../widgets/home_screen_widgets/home_page_widgets/post_card.dart';
import '../../../widgets/home_screen_widgets/home_page_widgets/search_result.dart';
import '../../../main.dart';
import '../../../providers/ads_provider/ads_provider.dart';

import '../../../models/ad_model.dart';
import '../../../providers/general/home_page_provider.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key, required this.width, required this.scrollController, required this.refreshController});
    final double width ;
    final ScrollController scrollController ;
    final RefreshController refreshController;
  @override
  Widget build(BuildContext context) {
    bool firstAnimate = context.watch<HomePageProvider>().firstAnimated;
    return Stack(
      children: [

        //home page ads
        SmartRefresher(
          header: CustomHeader(
            builder: (BuildContext context, RefreshStatus? mode) {
              return Container(
                width: double.infinity,
                height: 30,
                padding: const EdgeInsets.only(top: 60),
                alignment: Alignment.center,
                child: const CupertinoActivityIndicator(),
              );
            },
          ),
          onRefresh: () async {
            await context.read<AdsProvider>().refreshAds(context);
            refreshController.refreshCompleted();
          },
          controller: refreshController,
          semanticChildCount: 2,
          child: ListView(
            controller: scrollController,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                height: context.watch<HomePageProvider>().isScrollingUp ? 0 : 80,),
              Selector<AdsProvider , List<AdModel>>(
                  selector: (context , prov) => prov.adsList,
                  builder: (context , ads , _) {
                    return AnimationLimiter(
                      child: GridView.builder(
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
                                child: PostCard(
                                  imageUrl: ads[index].thumb,
                                  title: ads[index].title,
                                  isFavorite: false,
                                  price: ads[index].price,
                                  favorite: (){},
                                  adId: ads[index].id.toString(),
                                  index:  index,
                                ),
                              ),
                            );
                          }),
                    );
                  }
              ),
              Selector<AdsProvider , bool>(
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
                  width: width,
                  height: 78,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      //property
                      HomePageFilterCard(
                          scrollController: scrollController,
                          onTap: (){
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
                            context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                            Get.to(
                                  ()=> FilteredHomePage( scrollController: scrollController),
                              transition: Transition.rightToLeft,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 250),
                            );
                            context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                          },
                          imagePath: "assets/icons/filter_search/house.png",
                          title: "Property"),

                      //cars
                      HomePageFilterCard(
                          scrollController: scrollController,
                          onTap: (){
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
                            context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                            context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                            Get.to(
                                  ()=> FilteredHomePage( scrollController: scrollController),
                              transition: Transition.rightToLeft,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 250),
                            );
                          },
                          imagePath: "assets/icons/filter_search/car.png",
                          title: "Cars",
                      ),

                      //job
                      HomePageFilterCard(
                          scrollController: scrollController,
                          onTap: (){
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
                            Get.to(
                                  ()=> FilteredHomePage( scrollController: scrollController),
                              transition: Transition.rightToLeft,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 250),
                            );
                            context.read<FilterProvider>().setCategoryLabel("Jobs");
                            context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                            context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                          },
                          imagePath: "assets/icons/filter_search/search.png",
                          title: "Jobs",
                      ),

                      //for sale
                      HomePageFilterCard(
                          scrollController: scrollController,
                          onTap: (){
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
                            Get.to(
                                  ()=> FilteredHomePage( scrollController: scrollController),
                              transition: Transition.rightToLeft,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 250),
                            );
                            context.read<FilterProvider>().setCategoryLabel("For Sale");
                            context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                            context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                          },
                          imagePath: "assets/icons/filter_search/check.png",
                          title: "For Sales",
                      ),

                      //more
                      HomePageFilterCard(
                          scrollController: scrollController,
                          onTap: (){},
                          imagePath: "assets/icons/filter_search/more.png",
                          title: "More",
                      )

                      // GestureDetector(
                      //   onTap:(){
                      //     context.read<FilterProvider>().categoryId = 0;
                      //     context.read<FilterProvider>().subCategoryId = 2;
                      //     context.read<FilterProvider>().setCategoryMetaFields(context);
                      //     context.read<FilterProvider>().setFilterParams(
                      //         {
                      //           "category": "property",
                      //           "with_featured": "1"
                      //         },
                      //         "add");
                      //     context.read<FilterProvider>().setCategoryLabel("Real Estate");
                      //     context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                      //     Get.to(
                      //         ()=> FilteredHomePage( scrollController: scrollController),
                      //         transition: Transition.rightToLeft,
                      //         curve: Curves.linear,
                      //       duration: const Duration(milliseconds: 250),
                      //     );
                      //     context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         margin: const EdgeInsets.only(bottom: 2),
                      //         padding: const EdgeInsets.all(10),
                      //         height: 45,
                      //         width: 45,
                      //         decoration: BoxDecoration(
                      //           color: const Color.fromRGBO(229, 229, 229, 1),
                      //           borderRadius: BorderRadius.circular(16),
                      //         ),
                      //         child: Image.asset("assets/icons/filter_search/house.png", width: 25,height: 25,color: Colors.black,),
                      //       ),
                      //       const Text("Property" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.black),),
                      //     ],
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     context.read<FilterProvider>().categoryId = 1;
                      //     context.read<FilterProvider>().subCategoryId = 10;
                      //     context.read<FilterProvider>().setCategoryMetaFields(context);
                      //     context.read<FilterProvider>().setFilterParams(
                      //       {
                      //         "category" : "motors",
                      //         "subCategory" : "cars",
                      //         "with_featured" : "1",
                      //       },
                      //       "add",
                      //     );
                      //     context.read<FilterProvider>().setCategoryLabel("Cars For Sale");
                      //     context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                      //     context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                      //     Get.to(
                      //           ()=> FilteredHomePage( scrollController: scrollController),
                      //       transition: Transition.rightToLeft,
                      //       curve: Curves.linear,
                      //       duration: const Duration(milliseconds: 250),
                      //     );
                      //   },
                      //   child: Container(
                      //     height: 55,
                      //     width: 65,
                      //     color: Colors.transparent,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Image.asset("assets/icons/filter_search/car.png", width: 25,height: 25,color: Colors.white,),
                      //         const Text("Cars" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.white),),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     context.read<FilterProvider>().categoryId = 0;
                      //     context.read<FilterProvider>().subCategoryId = 4;
                      //     context.read<FilterProvider>().setCategoryMetaFields(context);
                      //     context.read<FilterProvider>().setFilterParams(
                      //       {
                      //         "category" : "jobs",
                      //         "with_featured" : "1",
                      //       },
                      //       "add",
                      //     );
                      //     Get.to(
                      //           ()=> FilteredHomePage( scrollController: scrollController),
                      //       transition: Transition.rightToLeft,
                      //       curve: Curves.linear,
                      //       duration: const Duration(milliseconds: 250),
                      //     );
                      //     context.read<FilterProvider>().setCategoryLabel("Jobs");
                      //     context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                      //     context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                      //   },
                      //   child: Container(
                      //     height: 55,
                      //     width: 65,
                      //     color: Colors.transparent,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Image.asset("assets/icons/filter_search/search.png", width: 25,height: 25,color: Colors.white,),
                      //         const Text("Jobs" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.white),),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     context.read<FilterProvider>().categoryId = 0;
                      //     context.read<FilterProvider>().subCategoryId = 3;
                      //     context.read<FilterProvider>().setCategoryMetaFields(context);
                      //     context.read<FilterProvider>().setFilterParams(
                      //       {
                      //         "category" : "for-sale",
                      //         "with_featured" : "1",
                      //       },
                      //       "add",
                      //     );
                      //     Get.to(
                      //           ()=> FilteredHomePage( scrollController: scrollController),
                      //       transition: Transition.rightToLeft,
                      //       curve: Curves.linear,
                      //       duration: const Duration(milliseconds: 250),
                      //     );
                      //     context.read<FilterProvider>().setCategoryLabel("For Sale");
                      //     context.read<FilteredAdsProvider>().getFilteredAds(context , true);
                      //     context.read<HomePageProvider>().setHomeType(HomeType.filteredHome);
                      //   },
                      //   child: Container(
                      //     height: 55,
                      //     width: 65,
                      //     color: Colors.transparent,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Image.asset("assets/icons/filter_search/check.png", width: 25,height: 25,color: Colors.white,),
                      //         const Text("For Sales" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.white),),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   height: 55,
                      //   width: 65,
                      //   color: Colors.transparent,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Image.asset("assets/icons/filter_search/more.png", width: 25,height: 25,color: Colors.white,),
                      //       const Text("More" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: Colors.white),),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

            );
          },
        ),
        searchResult(context),
      ],
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
