import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/ad_poster_information_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/new_ad_details_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';
import 'package:vivadoo/widgets/post_new_ad_widgets/location_and_category_widget/category_location_widget.dart';

import '../../constants.dart';
import '../../providers/post_new_ad_provider/steps_bar_widget_provider.dart';
import '../../providers/general/nav_bar_provider.dart';
import '../../providers/general/navigation_shell_provider.dart';
import '../../providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';
import '../../utils/hive_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../general_widgets/not_signed_in_page.dart';


class CustomPostNewAdScaffold extends StatelessWidget {
  const CustomPostNewAdScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HiveStorageManager.hiveBox.listenable(),
      builder: (context, hiveBox, widget) {
        String page = HiveStorageManager.getCurrentRoute();
        return Consumer<StepsBarWidgetProvider>(
          builder: (context, prov, _) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                key: scaffoldKeyPostNewAd,
                backgroundColor: Colors.white,

                appBar: HiveStorageManager.signedInNotifier.value ?
                AppBar(
                  leading: GestureDetector(
                    onTap: switch(page){
                      "PostNewAd" =>  (){
                        NavigationManager().goBranch(0);
                        context.read<NavBarProvider>().setCurrentPage(0);
                        HiveStorageManager.hiveBox.put('route', "Home");
                      },
                    "Category And Location" => (){
                        if(prov.isBottomSheetOpen){
                          prov.currentTabBarViewIndex == 0 ? Navigator.pop(context) : context.read<CategoryAndLocationProvider>().tabController.animateTo(0);
                        } else {
                          context.pop();
                        }
                    },
                    "NewAdDetails" || "PosterInformation" => (){
                        context.pop();
                    },

                      // TODO: Handle this case.
                      String() => (){},
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ) ,
                  surfaceTintColor: Colors.white,
                  title: Text(
                    switch(prov.currentIndex){
                      0 => "Ad Photos",
                      1 => "Location & Category",
                      2 => "Ad Details",
                      3 => "Ad Poster Information",
                      _ => "",
                    }
                  ),
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(4.0),
                      child: Container(
                        color: Colors.grey.withOpacity(0.6),
                        height: 1,
                      )),
                ) :
                AppBar(
                  leading: GestureDetector(
                    onTap: (){
                      // context.read<MyVivadooProvider>().changeValue(true);
                      HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
                      context.read<NavBarProvider>().setCurrentPage(1);
                      NavigationManager().goBranch(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  surfaceTintColor: Colors.white,
                  centerTitle: true,
                  title: const Text(
                      "Vivadoo"
                  ),
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(4.0),
                      child: Container(
                        color: Colors.grey.withOpacity(0.6),
                        height: 1,
                      )),
                ),
                body: HiveStorageManager.signedInNotifier.value ?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: stepsBarWidget(context, 4),
                    ),
                    Expanded(child: child),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Selector<PostNewAdProvider , bool>(
                            selector: (context , prov) => prov.postNewAdLoading,
                            builder: (context , loading , _) {
                              return ElevatedButton(
                                // onPressed: (){
                                //   PopUps.verifyPhoneNumber(context);
                                // },
                                onPressed: loading ? (){} :() {
                                  switch(prov.currentIndex){
                                    //Ad Photos
                                    case 0 : {
                                      if(context.read<AddPhotosProvider>().imageList.isNotEmpty){
                                        if(context.read<AddPhotosProvider>().mainPicture != null){
                                          // context.read<PostNewAdProvider>().uploadImages(context);
                                          context.go('/postNewAd/categoryAndLocation');
                                          prov.setCurrentIndex(1);
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                              content: Text('Please set the main picture!', style: TextStyle(fontWeight: FontWeight.w600),),
                                            ),
                                          );
                                        }

                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                            content: Text('Please add at least 1 picture!', style: TextStyle(fontWeight: FontWeight.w600),),
                                          ),
                                        );
                                      }
                                  }

                                  //Location & Category
                                    case 1 : {
                                      if(context.read<CategoryAndLocationProvider>().locationLink.isNotEmpty && context.read<CategoryAndLocationProvider>().categoryLink.isNotEmpty){
                                        context.go('/postNewAd/categoryAndLocation/newAdDetails');
                                        prov.setCurrentIndex(2);
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                            content: Text('Please fill the required fields!', style: TextStyle(fontWeight: FontWeight.w600),),
                                          ),
                                        );
                                      }
                                    }
                                    //Ad Details
                                    case 2 : {
                                      if(context.read<NewAdDetailsProvider>().adTitleController.text.isNotEmpty && context.read<NewAdDetailsProvider>().adPriceController.text.isNotEmpty && context.read<NewAdDetailsProvider>().adDescriptionController.text.isNotEmpty){
                                        context.go('/postNewAd/categoryAndLocation/newAdDetails/posterInformation');
                                        prov.setCurrentIndex(3);
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                            content: Text('Please fill the required fields!', style: TextStyle(fontWeight: FontWeight.w600),),
                                          ),
                                        );
                                      }
                                    }
                                    //Ad Poster Information
                                    case 3 : {
                                      if(context.read<AdPosterInformationProvider>().nameController.text.isNotEmpty && context.read<AdPosterInformationProvider>().emailController.text.isNotEmpty && context.read<AdPosterInformationProvider>().phoneController.text.isNotEmpty){
                                        context.read<AdPosterInformationProvider>().previewAd(context);
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                            content: Text('Please fill the required fields!', style: TextStyle(fontWeight: FontWeight.w600),),
                                          ),
                                        );
                                      }

                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets?>(
                                      const EdgeInsets.symmetric(horizontal: 20)
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size?>(
                                       Size(prov.currentIndex == 3 ? (MediaQuery.of(context).size.width - 50 ) /2  :MediaQuery.of(context).size.width -40 , 45)),
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
                                child: loading ? const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(color: Constants.orange,),):Text(
                                  prov.currentIndex == 3 ? "preview" :"Continue",
                                  style: const  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              );
                            }
                          ),
                          Visibility(
                            visible: prov.currentIndex == 3,
                            child: Selector<PostNewAdProvider , bool>(
                              selector: (context , prov) => prov.postNewAdLoading,
                              builder: (context , loading , _) {
                                return ElevatedButton(
                                onPressed: loading ? (){} : () {
                                  print("posting a new ad");

                                  context.read<PostNewAdProvider>().postNewAd(context);
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets?>(
                                      const EdgeInsets.symmetric(horizontal: 20)
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size?>(
                                      Size( (MediaQuery.of(context).size.width -40 ) /2 , 45)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color.fromRGBO(0, 128, 0, 1),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  animationDuration: const Duration(milliseconds: 500),
                                  backgroundColor: getColor(const Color.fromRGBO(0, 128, 0, 1), Colors.white),
                                  foregroundColor: getColor(Colors.white, const Color.fromRGBO(0, 128, 0, 1)),
                                ),
                                child: loading ? const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(color: Constants.orange,),):const Text(
                                  "Post Ad",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                                          );
                              }
                            ),),
                        ],
                      ),
                    ),
                  ],
                ) :
                notSignedInPage(context),
              ),
            );
          }
        );
      }
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


Widget stepsBarWidget (BuildContext context, int stepsNumber) {
  double width = MediaQuery.of(context).size.width;
  double widgetWidth = (((width - 40) - 32 ) /3 ) -32;
  return Consumer<StepsBarWidgetProvider>(
      builder: (context, prov, _) {
        return SizedBox(
          width: width,
          height: 50,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: stepsNumber,
            itemBuilder: (context, index){
              return step(context, selected: index <= prov.currentIndex, nextStep: index -1 == prov.currentIndex, stepsNumber: stepsNumber, lastIndex: index == stepsNumber -1, width: widgetWidth );
            },
          ),
        );
      }
  );
}


Widget step (BuildContext context , {required bool selected, required bool nextStep, required int stepsNumber, required bool lastIndex, required double width}){
  return Row(
    children: [
      Container(
        margin: const EdgeInsets.only(left: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selected ? Constants.orange : Colors.transparent,
          border: Border.all(color: selected ? Colors.transparent : Colors.grey, width: 2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: selected ? const Icon(Icons.check, size: 18,color: Colors.white,) : nextStep ? const Icon(Icons.circle, size: 15,color: Colors.grey,) : const SizedBox.shrink(),
      ),
      lastIndex ? const SizedBox.shrink() : Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4),
            width:width ,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 4),
            width: selected? width : 0,
            height: 3,
            decoration: BoxDecoration(
              color: Constants.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    ],
  );
}