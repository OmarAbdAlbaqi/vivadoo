
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:vivadoo/providers/filters/filter_provider.dart';
import 'package:vivadoo/widgets/home_screen_widgets/location_widgets/location_filter_widget.dart';
import '../../../main.dart';
import '../../../models/filters/category_model.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../providers/ads_provider/filtered_ads_provideer.dart';
import '../../../providers/filters/location_filter.dart';
import '../../../providers/general/home_page_provider.dart';

import '../../../constants.dart';
import 'category_card.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                        "CATEGORY",
                        categoryLabel , (){
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
                    });
                  },
                ),
                const SizedBox(height: 6,),

                //location
                Selector<LocationFilterProvider , String>(
                  selector: (context , prov) => prov.tempLocation,
                  builder: (context , location , _){
                    return filterSelector("LOCATION",
                        location.isEmpty ? context.watch<LocationFilterProvider>().location : location , (){
                          context.read<HomePageProvider>().setHomeType(HomeType.locationFilter);
                          context.read<LocationFilterProvider>().setFromFilter(true);
                          Get.to(
                              ()=> const LocationFilterWidget(),
                              transition: Transition.rightToLeft,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 250),
                          );
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
                          "MAKE",
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
                                          return index == 0 ? const SizedBox(height: 10,):makeCard(context,makesList[index]);
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
              color: const Color.fromRGBO(245, 246, 247, 1),
              height: 70,
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: (){
                  context.read<FilterProvider>().showAds(context );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color.fromRGBO(59, 89, 152, 1),
                  ),
                  child: const Text("Search" , style: TextStyle(color: Color(0xFFffffff) , fontSize: 14 , fontWeight: FontWeight.w600),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget rangeFieldWidget (BuildContext context, MetaFieldsModel metaFieldsModel){
  int id = metaFieldsModel.range.firstWhere((element) => element['id'] == context.read<FilterProvider>().subCategoryId)['range_value'];
  List ranges = context.read<FilteredAdsProvider>().ranges.firstWhere((element) => element['id'] == id)['values'];
  WidgetsBinding.instance.addPostFrameCallback((_){
    if(context.read<FilterProvider>().currentRangeValues == const RangeValues(0,1)){
      context.read<FilterProvider>().setRangeValue(RangeValues(double.parse(ranges[0]), double.parse(ranges[ranges.length -1])));
    }
  });
  return SizedBox(
    width: double.infinity,
    height: 130,
    child: Selector<FilterProvider , RangeValues>(
        selector: (context , prov) => prov.currentRangeValues,
        builder: (context , rangeValue , _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.only(left: 20 , top: 20),
              child: Text(metaFieldsModel.name , style: const TextStyle(color: Constants.orange , fontSize: 14 , fontWeight: FontWeight.w500 ),),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width - 40,height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(rangeValue.start.toInt().toString()),
                  Text(rangeValue.end.toInt().toString()),
                ],
              ),
            ),
            RangeSlider(
                min: rangeValue.start == 0 ? 0 : double.parse(ranges[0]),
                max: rangeValue.end == 1 ? 1 :double.parse(ranges[ranges.length -1]),
                divisions: (int.parse(ranges[ranges.length -1]) - int.parse(ranges[0])) * 10 + 1,
                values: rangeValue,
                // labels: RangeLabels(rangeValue.start.toInt().toString() , rangeValue.end.toInt().toString()),
                onChanged: (value){
                  context.read<FilterProvider>().rangeMetaFieldId = metaFieldsModel.id.toString();
                  context.read<FilterProvider>().setRangeValue(value);
                }),

          ],
        );
      }
    ),
  );
}

Widget uniqueSelectionWidget (BuildContext context, MetaFieldsModel metaFieldsModel){
  String? group (Map<String, dynamic>? temp){
    if(temp != null){
      List<MapEntry<String, dynamic>> entries = temp.entries.toList();
      if (entries.isNotEmpty) {
        MapEntry<String, dynamic> firstEntry = entries.first;
        dynamic firstValue = firstEntry.value;
        return firstValue.toString();
      }
    }
    return null;
  }
  return Consumer<FilterProvider>(
    builder: (context , filter , _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20 , top: 20),
            child: Text(metaFieldsModel.name , style: const TextStyle(color: Constants.orange , fontSize: 14 , fontWeight: FontWeight.w500 ),),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
              itemCount: metaFieldsModel.options.length,
              itemBuilder: (context , index){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                        fillColor: MaterialStateProperty.all<Color>(Colors.orange),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: metaFieldsModel.options[index],
                        groupValue: group(filter.selected[metaFieldsModel.name]) ?? "",
                        onChanged: (value){
                          // filter.uniqueSelection(metaFieldsModel.name  , {"[${metaFieldsModel.id}][$index]" : value});
                        }),
                    GestureDetector(
                      onTap: (){
                        filter.uniqueSelection(metaFieldsModel.name  ,{"[${metaFieldsModel.id}][$index]" : metaFieldsModel.options[index]});
                    },
                      child: Container(
                        width: 300,
                        height: 40,
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Text(metaFieldsModel.options[index],),
                      ),
                    ),
                  ],
                );
              })
        ],
      );
    }
  );
}

Widget multiSelectionWidget (BuildContext context , MetaFieldsModel metaFieldsModel){
  return Consumer<FilterProvider>(
    builder: (context , filter , _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20 , top: 20),
            child: Text(metaFieldsModel.name , style: const TextStyle(color: Constants.orange , fontSize: 14 , fontWeight: FontWeight.w500 ),),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 18),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: metaFieldsModel.options.length,
            itemBuilder: (context , index){
              return GestureDetector(
                onTap: (){
                  filter.multiCheckSelection("[${metaFieldsModel.id}][$index]",metaFieldsModel.options[index], index);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Constants.orange),
                      ),
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: filter.selected.containsKey("[${metaFieldsModel.id}][$index]"),
                        child: const Icon(Icons.check , color: Constants.orange),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 300,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        child: Text(metaFieldsModel.options[index])),
                  ],
                ),
              );
            },
          ),

        ],
      );
    }
  );
}

Widget metaFieldsWidget() {
  return Selector<FilterProvider, List<MetaFieldsModel>>(
    selector: (context, prov) => prov.categoryMetaFields,
    builder: (context, fields, _) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: fields.length,
        itemBuilder: (context, index) {
          switch (fields[index].type) {
            case "RANGE":{
              WidgetsBinding.instance.addPostFrameCallback((_){
                context.read<FilteredAdsProvider>().setRangeValue(RangeValues(fields[index].range[0]['min'].toDouble() , fields[index].range[0]['max'].toDouble()));
              });
                return rangeFieldWidget(context, fields[index]);
              }
            case "MULTISELECT":{
                return multiSelectionWidget(context , fields[index]);
              }
            case "UNIQUESELECT":{
                return uniqueSelectionWidget(context , fields[index]);
              }
            case "TEXT":{
                return Container();
              }
            default:{
                return Container(

                ); // Handle any other types if needed
              }
          }
        },
      );
    },
  );
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
            const Text("Ad Type" , style: TextStyle(color: Constants.orange),),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    filter.setAdType("Privates");
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
                        const Text("Privates" , style: TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4),
                GestureDetector(
                  onTap: (){
                    filter.setAdType("Professionals");
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
                        const Text("Professionals" , style: TextStyle(fontWeight: FontWeight.w500),),
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
            const Text("Search only in title"),
            CupertinoSwitch(
                value: search,
                onChanged: (value){
                  context.read<FilterProvider>().setSearchOnlyInTitle();
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
              const Text("Show only ads with photos"),
              CupertinoSwitch(
                  value: search,
                  onChanged: (value){
                    context.read<FilterProvider>().setShowOnlyAdsWithPhotos();
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
              const Text("Show only featured ads"),
              CupertinoSwitch(
                  value: search,
                  onChanged: (value){
                    context.read<FilterProvider>().setShowOnlyFeaturedAds();
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
      context.read<FilterProvider>().makeLink = make['cat_link'];
      context.read<FilterProvider>().cleanSelected();
      context.read<FilterProvider>().setMakeLabel(make['name']);
      context.read<FilterProvider>().setCategoryMetaFields(context , makeId: make['id'], method: "add");
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
