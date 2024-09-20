import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../models/filters/meta_fields_model.dart';
import '../../../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../../../providers/home_providers/filters/filter_provider.dart';
import '../../../../../providers/home_providers/filters/range_filter_provider.dart';


Widget rangeFieldWidget (BuildContext context, MetaFieldsModel metaFieldsModel){
  int id = metaFieldsModel.range.firstWhere((element) => element['id'] == context.read<FilterProvider>().subCategoryId)['range_value'];
  List ranges = context.read<FilteredAdsProvider>().ranges.firstWhere((element) => element['id'] == id)['values'];
  WidgetsBinding.instance.addPostFrameCallback((_){
    if(context.read<RangeFilterProvider>().currentRangeValues == const RangeValues(0,1)){
      context.read<RangeFilterProvider>().setRangeValue(RangeValues(double.parse(ranges[0]), double.parse(ranges[ranges.length -1])));
    }
  });
  return SizedBox(
    width: double.infinity,
    height: 130,
    child: Consumer<RangeFilterProvider>(
        // selector: (context , prov) => prov.currentRangeValues,
        builder: (context , prov , _) {
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
                    Text(prov.currentRangeValues.start.toInt().toString()),
                    Text(prov.currentRangeValues.end.toInt().toString()),
                  ],
                ),
              ),
              RangeSlider(
                  min: prov.currentRangeValues.start == 0 ? 0 : double.parse(ranges[0]),
                  max: prov.currentRangeValues.end == 1 ? 1 :double.parse(ranges[ranges.length -1]),
                  divisions: (int.parse(ranges[ranges.length -1]) - int.parse(ranges[0])) * 10 + 1,
                  values: prov.currentRangeValues,
                  onChangeEnd: (value){
                    context.read<FilterProvider>().addSelectedRangeToSelectedMetaFields(context);
                    // context.read<FilterProvider>().showAdsCount(context);
                  },
                  onChanged: (value){
                    prov.rangeMetaFieldId = metaFieldsModel.id.toString();
                    prov.setRangeValue(value);
                  }),

            ],
          );
        }
    ),
  );
}