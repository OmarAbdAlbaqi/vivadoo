import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/filters/meta_fields_model.dart';
import '../../../providers/ads_provider/filtered_ads_provider.dart';
import '../../../providers/home_providers/filters/filter_provider.dart';
import '../../../providers/post_new_ad_provider/post_new_ad_provider.dart';
import '../../../providers/post_new_ad_provider/steps_bar_widget_provider.dart';
import '../../../providers/post_new_ad_provider/pages_providers/new_ad_details_provider.dart';

import '../../home_screen_widgets/general_filter_widgets/meta_fields/meta_fields_widget.dart';
import '../../home_screen_widgets/general_filter_widgets/meta_fields/sub_widgets_for_meta_fields/multi_selection_widget.dart';
import '../../home_screen_widgets/general_filter_widgets/meta_fields/sub_widgets_for_meta_fields/range_field_widget.dart';
import '../../home_screen_widgets/general_filter_widgets/meta_fields/sub_widgets_for_meta_fields/unique_selection_widget.dart';
import '../ad_details_input.dart';
import '../location_and_category_widget/category_location_widget.dart';

class NewAdDetails extends StatefulWidget {
  const NewAdDetails({super.key});

  @override
  State<NewAdDetails> createState() => _NewAdDetailsState();
}

class _NewAdDetailsState extends State<NewAdDetails> {
  PersistentBottomSheetController? _bottomSheetController;

  void _showBottomSheetLocation(Widget child) {
    context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(true);
    _bottomSheetController = scaffoldKeyPostNewAd.currentState
        ?.showBottomSheet((ctx) => child);

    _bottomSheetController?.closed.whenComplete(() {
      context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(false);
      i++;
      if (i < categoryMetaFields.length) {
        showNextMetaField();
      }
    });
  }

  late List<MetaFieldsModel> categoryMetaFields;

  int i = 0;

  void showNextMetaField() {
    switch (categoryMetaFields[i].type) {
      case "RANGE":
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FilteredAdsProvider>().setRangeValue(RangeValues(
                categoryMetaFields[i].range[0]['min'].toDouble(),
                categoryMetaFields[i].range[0]['max'].toDouble()));
          });
          return _showBottomSheetLocation(
              Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 65,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.2)),
                            color: Color.fromRGBO(235, 236, 247, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24))),
                        alignment: Alignment.center,
                        child: Text(
                          categoryMetaFields[i].name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      rangeFieldWidget(context, categoryMetaFields[i]),
                      // const SizedBox(
                      //   height: 100,
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      _bottomSheetController?.close();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 0.2, color: Colors.black.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: -1,
                                blurRadius: 3,
                                offset: const Offset(-2, 2)),
                          ]),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        }
      case "MULTISELECT":
        {
          return _showBottomSheetLocation(
              Consumer<FilterProvider>(
                builder: (context, filter, _) {
                  return Container(
                              width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height * 0.78,
                              decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                              child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 65,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.black, width: 0.2)),
                              color: Color.fromRGBO(235, 236, 247, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                          alignment: Alignment.center,
                          child: Text(
                            categoryMetaFields[i].name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height * 0.78) - 65,
                          child: SingleChildScrollView(
                            child: multiSelectionWidget(context, categoryMetaFields[i]),
                          ),
                        ),
                        // multiSelectionWidget(context, categoryMetaFields[i]),

                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          _bottomSheetController?.close();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.2, color: Colors.black.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: -1,
                                    blurRadius: 3,
                                    offset: const Offset(-2, 2)),
                              ]),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                              ),
                            );
                }
              ));
        }
      case "UNIQUESELECT":
        {
          return _showBottomSheetLocation(Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 65,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 0.2)),
                          color: Color.fromRGBO(235, 236, 247, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      alignment: Alignment.center,
                      child: Text(
                        categoryMetaFields[i].name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.78) - 65,
                      child: SingleChildScrollView(
                        child: uniqueSelectionWidget(context, categoryMetaFields[i]),
                      ),
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      _bottomSheetController?.close();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 0.2, color: Colors.black.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: -1,
                                blurRadius: 3,
                                offset: const Offset(-2, 2)),
                          ]),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        }
    }
    i++;
  }

  @override
  void initState() {
    categoryMetaFields = context.read<FilterProvider>().categoryMetaFields;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoryMetaFields.isNotEmpty) {
        showNextMetaField();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewAdDetailsProvider>(
        builder: (context, prov, _) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    AdDetailsInput(
                      title: "Ad Title",
                      keyboard: TextInputType.name,
                      onChanged: (value) {
                        prov.storeTitleInHive(context,value);
                      },
                      obscure: false,
                      validator: (value) {
                        if (true) {
                          return "";
                        } else {
                          return "";
                        }
                      },
                      hint: "Ad Title",
                      textCapitalization: TextCapitalization.sentences,
                      controller: prov.adTitleController,
                    ),
                    AdDetailsInput(
                        title: "Ad Price",
                        keyboard: TextInputType.number,
                        onChanged: (value) {
                          prov.storePriceInHive(context,value);
                        },
                        suffixIcon: GestureDetector(
                          onTap: ()=>context.read<NewAdDetailsProvider>().changeCurrency(),
                          child: context.watch<NewAdDetailsProvider>().currencyIsLbp ?
                          Container(
                              color: Colors.transparent,
                              width: 50,
                              alignment: const Alignment(0, 0),
                              child: const Text("LBP")) :
                          Container(
                              color: Colors.transparent,
                              width: 50,
                              alignment: const Alignment(0, 0),
                              child: const Text("USD")),
                        ),
                        obscure: false,
                        validator: (value) {
                          if (true) {
                            return "";
                          } else {
                            return "";
                          }
                        },
                        hint: "Ad Price",
                        textCapitalization: TextCapitalization.none,
                        controller: prov.adPriceController),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    const Text(
                      "Ad Description",
                      style: TextStyle(
                          fontFamily: 'Uber Move',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLines: null,
                      controller: prov.adDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (true) {
                          return "";
                        } else {
                          return "";
                        }
                      },
                      obscureText: false,
                      onChanged: (value) {
                        prov.storeDescriptionInHive(context,value);
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red.withOpacity(0.6),
                            )),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            width: 1.2,
                            color: Colors.red,
                          ),
                        ),
                        hintText: "Description",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.5), width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(8)),
                        fillColor: const Color.fromARGB(255, 245, 246, 247),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              metaFieldsWidget(),
            ],
          ),
        ),
      );
    });
  }
}
