
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import '../../../models/filters/ads_count_model.dart';
import '../../../models/filters/category_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';

import '../../../constants.dart';
import '../../../providers/home_providers/filters/filter_provider.dart';
import '../../../providers/home_providers/filters/location_filter.dart';
import 'category_and_sub-category/category_card.dart';
import 'meta_fields/meta_fields_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key, this.showCategoryDialog});
  final bool? showCategoryDialog;

void showCatDialog (BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12 , vertical: 100),
          decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Selector<FilteredAdsProvider , List<CategoryModel>>(
              selector: (ctx , prov) => prov.categoryList,
              builder: (ctx , categoryList , _) {
                return ListView.builder(
                  itemCount:  categoryList.length ,
                  itemBuilder: (ctx, int index) {
                    return index == 0 ? const SizedBox(height: 25):categoryCard(ctx , categoryList[index] ,  index);
                  },
                );
              }
          ),
        );
      });
}

  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if(showCategoryDialog!= null && showCategoryDialog == true){
      Future.delayed(const Duration(milliseconds: 400)).then((value) => showCatDialog(context));
    }
  });
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                //category
                Selector<FilterProvider , String>(
                  selector: (context , prov) => prov.categoryLabel,
                  builder: (context , categoryLabel , _){
                    return filterSelector(
                        AppLocalizations.of(context)!.category,
                        categoryLabel,
                            (){
                          showCatDialog(context);
                    });
                  },
                ),
                const SizedBox(height: 6,),

                //location
                Selector<LocationFilterProvider , String>(
                  selector: (context , prov) => prov.tempLocation,
                  builder: (context , location , _){
                    return filterSelector(
                        AppLocalizations.of(context)!.location_title,
                        location.isEmpty ? context.watch<LocationFilterProvider>().location : location ,
                            (){
                      HiveStorageManager.hiveBox.get('route') == 'FilterFromHome' ?
                      context.go('/home/filterFromHome/locationFilterFromFilterHome'):
                      context.go('/home/filteredHome/filter/locationFilterFromFilter');
                        });
                  },
                ),
                const SizedBox(height: 6),

                //makes
                Selector<FilterProvider , bool>(
                  selector: (context , prov) => prov.makesList.isNotEmpty,
                  builder: (context , hasMakes , _){
                    return Visibility(
                      visible: hasMakes,
                      child: filterSelector(
                          AppLocalizations.of(context)!.make,
                          context.watch<FilterProvider>().makeLabel, (){
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12 , vertical: 100),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFffffff),
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Selector<FilterProvider , List<dynamic>>(
                                    selector: (ctx , prov) => prov.makesList,
                                    builder: (ctx , makesList , _) {
                                      return ListView.separated(
                                        itemCount:  makesList.length ,
                                        itemBuilder: (ctx, int index) {
                                          return index == 0 ? const SizedBox(height: 10,):makeCard(ctx,makesList[index]);
                                        },
                                        separatorBuilder: (context , index) => index == 0 ?  const Center(): const Divider(endIndent: 12,indent: 12,thickness: 0,),
                                      );
                                    }
                                ),
                              );
                            });
                      }),
                    );
                  },
                ),

                metaFieldsWidget(),
                adType(context),
                const Divider(height: 20,),
                searchOnlyInTitle(),
                showOnlyAdsWithPhotos(),
                showOnlyFeaturedAds(),
                const SizedBox(height: 90),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color.fromRGBO(245, 246, 247, 1),
              height: 70,
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () async {
                  String route = HiveStorageManager.hiveBox.get('route');
                  await context.read<FilterProvider>().showAds(context);
                  if(route == "FilterFromHome"){
                    if(context.mounted){
                      context.pop();
                      HiveStorageManager.hiveBox.put('route', 'FilteredHome');
                    }
                  }
                  else{
                    if(context.mounted){
                      context.pop();
                    }
                  }

                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size?>(
                      const Size(double.infinity, 45)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  animationDuration: const Duration(milliseconds: 500),
                  backgroundColor: getColor(Colors.orange, Colors.white),
                  foregroundColor: getColor(Colors.white, Colors.orange),
                ),
                child: Selector<FilterProvider, AdsCount>(
                  selector: (context, prov) => prov.adsCount ?? AdsCount(count: 0, countCat: 0, categories: {}),
                  builder: (context, prov, _) {
                    return Text(
                      "${AppLocalizations.of(context)!.search} (${prov.count.toString()})",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return WidgetStateProperty.resolveWith(getColor);
  }
}

Widget filterSelector(String title , String category , Function onTap){
  return GestureDetector(
    onTap: (){
      onTap();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      color: Colors.transparent,
      width: double.infinity,
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title , style: const TextStyle(color: Color.fromRGBO(147, 147, 147, 1)),),
          const SizedBox(height: 6),
          Text(category),
          const Divider(
            color: Colors.black,
            thickness: 0,
          ),
        ],
      ),
    ),
  );
}

Widget adType(BuildContext context){
  return Consumer<FilterProvider>(
    builder: (context ,filter , _) {
      List<String> types = filter.adType;
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.ad_type , style: const TextStyle(color: Constants.orange),),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    filter.setAdType(context,"Privates");
                    // context.read<FilterProvider>().showAdsCount(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.orange),
                          ),
                          alignment: Alignment.center,
                          child: types.contains("Privates") ? const Icon(Icons.check , color: Constants.orange,size: 30,):null,
                        ),
                        Text(AppLocalizations.of(context)!.privates , style: const TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4),
                GestureDetector(
                  onTap: (){
                    filter.setAdType(context,"Professionals");
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.orange),
                          ),
                          alignment: Alignment.center,
                          child: types.contains("Professionals") ? const Icon(Icons.check , color: Constants.orange,size: 30,):null,
                        ),
                        Text(AppLocalizations.of(context)!.professionals , style: const TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  );
}

Widget searchOnlyInTitle(){
  return Selector<FilterProvider , bool>(
    selector: (context , prov) => prov.searchOnlyInTitle,
    builder: (context , search, _) {
      return Container(
        padding: const EdgeInsets.only(left: 25 , right: 35),
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.search_only_in_title),
            CupertinoSwitch(
                value: search,
                onChanged: (value){
                  context.read<FilterProvider>().setSearchOnlyInTitle(context);
                  // context.read<FilterProvider>().showAdsCount(context);
                })
          ],
        ),
      );
    }
  );
}

Widget showOnlyAdsWithPhotos() {
  return Selector<FilterProvider , bool>(
      selector: (context , prov) => prov.showOnlyAdsWithPhotos,
      builder: (context , search, _) {
        return Container(
          padding: const EdgeInsets.only(left: 25 , right: 35),
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.show_only_ads_with_photos),
              CupertinoSwitch(
                  value: search,
                  onChanged: (value){
                    context.read<FilterProvider>().setShowOnlyAdsWithPhotos(context);
                    // context.read<FilterProvider>().showAdsCount(context);
                  })
            ],
          ),
        );
      }
  );
}

Widget showOnlyFeaturedAds(){
  return Selector<FilterProvider , bool>(
      selector: (context , prov) => prov.showOnlyFeaturedAds,
      builder: (context , search, _) {
        return Container(
          padding: const EdgeInsets.only(left: 25 , right: 35),
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.show_only_featured_ads),
              CupertinoSwitch(
                  value: search,
                  onChanged: (value){
                    context.read<FilterProvider>().setShowOnlyFeaturedAds();
                    // context.read<FilterProvider>().showAdsCount(context);
                  })
            ],
          ),
        );
      }
  );
}

Widget makeCard(BuildContext context,Map<String , dynamic> make){
  return GestureDetector(
    onTap: (){
      context.read<FilterProvider>().setMake(context, make);
      context.read<FilterProvider>().setCategoryMetaFields(context , makeId: make['id'], clear: false);
      if(HiveStorageManager.getCurrentRoute() != "Category And Location"){
        context.read<FilterProvider>().showAdsCount(context);
      }
      Navigator.pop(context);
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      height: 40,
      child: Row(
        children: [
          Text(make['name'].toString()),
        ],
      ),
    ),
  );
}
