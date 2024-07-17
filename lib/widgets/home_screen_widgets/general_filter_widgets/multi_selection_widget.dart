import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/filters/filter_provider.dart';


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
                    context.read<FilterProvider>().showAdsCount(context);
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