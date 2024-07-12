import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../providers/filters/filter_provider.dart';


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