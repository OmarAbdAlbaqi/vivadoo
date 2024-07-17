import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/filters/filter_provider.dart';


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
                    context.read<FilterProvider>().showAdsCount(context);
                  }),

            ],
          );
        }
    ),
  );
}