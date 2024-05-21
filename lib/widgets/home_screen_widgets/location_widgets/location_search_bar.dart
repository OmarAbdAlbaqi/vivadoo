import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/filters/location_filter.dart';

Widget locationSearchBar (BuildContext context) {
  return TextFormField(
    controller: context.watch<LocationFilterProvider>().textEditingController,
    onChanged: (value){
      if(value.length >= 2){
        context.read<LocationFilterProvider>().setToSearchText(value);
        context.read<LocationFilterProvider>().searchArea();
      }else{
        context.read<LocationFilterProvider>().resetSearch();
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
            const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(8)),
        hintText: "Search Vivadoo",
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Color.fromRGBO(88, 89, 91, 0.6)),
        contentPadding: const EdgeInsets.only(
            left: 12, right: 12, top: 0, bottom: 0),
        prefixIcon: const Icon(Icons.search,
            size: 35, color: Color.fromRGBO(88, 89, 91, 0.6)),
        suffixIcon:  InkWell(
          onTap: context.watch<LocationFilterProvider>().searchedResult.isNotEmpty ?
              () {
            context.read<LocationFilterProvider>().resetSearch();
            context.read<LocationFilterProvider>().clearText();
            FocusScope.of(context).unfocus();
          } :
              () {
          },
          child:
          Icon(
              context.watch<LocationFilterProvider>().searchedResult.isNotEmpty ?Icons.close : Icons.mic_rounded,
              size: 30, color: const Color.fromRGBO(88, 89, 91, 0.7)),

        )),
  );
}