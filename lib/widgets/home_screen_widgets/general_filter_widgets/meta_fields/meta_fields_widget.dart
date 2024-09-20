import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/home_providers/filters/filter_provider.dart';
import 'sub_widgets_for_meta_fields/range_field_widget.dart';
import 'sub_widgets_for_meta_fields/unique_selection_widget.dart';
import '../../../../models/filters/meta_fields_model.dart';
import '../../../../providers/ads_provider/filtered_ads_provider.dart';
import 'sub_widgets_for_meta_fields/multi_selection_widget.dart';

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