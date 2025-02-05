import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/home_providers/filters/location_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class Debounce {
  final int milliseconds;
  Timer? _timer;
  Debounce({required this.milliseconds});
  void run(VoidCallback  action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
  void dispose() => _timer?.cancel();
}

Widget locationSearchBar (BuildContext context) {

  final _debounce = Debounce(milliseconds: 700);
  void doSearch(String text) {
    _debounce.run(() {
      context.read<LocationFilterProvider>().searchArea();
    });
  }
  return TextFormField(
    controller: context.watch<LocationFilterProvider>().textEditingController,
    onChanged: (value) {
        doSearch(value);


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
        hintText: AppLocalizations.of(context)!.search_vivadoo,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Color.fromRGBO(88, 89, 91, 0.6)),
        contentPadding: const EdgeInsets.only(
            left: 12, right: 12, top: 0, bottom: 0),
        prefixIcon: const Icon(Icons.search,
            size: 35, color: Color.fromRGBO(88, 89, 91, 0.6)),
        suffixIcon:  InkWell(
          onTap: context.watch<LocationFilterProvider>().textEditingController.text.isNotEmpty ?
              () {
            context.read<LocationFilterProvider>().resetSearch();
            context.read<LocationFilterProvider>().clearText();
            FocusScope.of(context).unfocus();
          } :
              () {

          },
          child:
          Icon(
              context.watch<LocationFilterProvider>().textEditingController.text.isNotEmpty ?Icons.close : Icons.mic_rounded,
              size: 30, color: const Color.fromRGBO(88, 89, 91, 0.7)),

        )),
  );
}