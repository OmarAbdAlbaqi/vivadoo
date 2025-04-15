import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/providers/general/nav_bar_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../../constants.dart';
import '../../../providers/my_vivadoo_providers/auth/user_info_provider.dart';
import '../../../providers/my_vivadoo_providers/my_vivadoo_profile_provider.dart';
import '../../../screens/nav_bar_pages/messages.dart';
import '../../../utils/pop-ups/pop_ups.dart';
import '../../ad_cards/full_width_ad_card.dart';
import 'package:vivadoo/main.dart' as main;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyVivadooProfile extends StatelessWidget {
   MyVivadooProfile({super.key});

  final List<String> locales = ["en","ar","fr"];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // TabBar(
          //   padding: EdgeInsets.zero,
          //   indicatorSize: TabBarIndicatorSize.tab,
          //   tabs: [
          //     Tab(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Icon(Icons.list),
          //           const SizedBox(width: 12),
          //           Text(AppLocalizations.of(context)!.my_ads),
          //         ],
          //       ),
          //     ),
          //     Tab(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Icon(Icons.settings),
          //           const SizedBox(width: 12),
          //           Text(AppLocalizations.of(context)!.settings),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Constants.orange,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                TabItem(title: 'My Ads'),
                TabItem(title: 'Settings'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go('/myVivadoo/editAccountDetails');
            },
            child: ValueListenableBuilder<Box<UserInfoModel>>(
              valueListenable:
              HiveStorageManager.getUserInfoModel().listenable(),
              builder: (context, userInfoBox, _) {
                UserInfoModel? userInfo;
                if (userInfoBox.values.isNotEmpty) {
                  userInfo = userInfoBox.values.toList().first;
                }
                return Visibility(
                  visible: userInfo != null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor:
                          const Color.fromRGBO(255, 255, 255, 1),
                          child: Image.asset(
                            'assets/images/vivadoo.png',
                            width: 50,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userInfo?.firstName ?? ""} ${userInfo?.lastName ?? ""}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userInfo?.emailAddress ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset('assets/icons/edit.png', width: 35),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Selector<UserInfoProvider, List<AdModel>>(
                  selector: (context, prov) => prov.userAds,
                  builder: (context, ads, _) {
                    if (ads.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ads.length,
                        itemBuilder: (context, index) {
                          return AnimationLimiter(
                            child: AnimationConfiguration.synchronized(
                              duration: const Duration(milliseconds: 300),
                              child: SlideAnimation(
                                duration: const Duration(milliseconds: 300),
                                verticalOffset: 120,
                                child: FullWidthAdCard(
                                  adModel: ads[index],
                                  index: index,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.sorry_we_did_not_find_any_result,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      );
                    }
                  },
                ),
                ListView(
                  padding: const EdgeInsets.all(12),
                  // controller: scrollController,
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Selector<MyVivadooProfileProvider, double>(
                        selector: (context, prov) => prov.languageTabHeight,
                        builder: (context, height, _) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<MyVivadooProfileProvider>()
                                  .changeLanguageTabHeight();
                            },
                            child: AnimatedContainer(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              duration: const Duration(milliseconds: 200),
                              height: height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white38,
                                border: Border.all(
                                    color: Constants.orange.withOpacity(0.4),
                                    width: 2),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      width: 150,
                                      child: Text(AppLocalizations.of(context)!.change_language)),
                                  AnimatedPositioned(
                                    top: height == 54 ? 0 : 52,
                                    left: HiveStorageManager.getCurrentLocal() == "ar" ? height == 54 ?  60  : MediaQuery.of(context).size.width - 130: height == 54 ?  MediaQuery.of(context).size.width - 180 : 0,
                                    right:  HiveStorageManager.getCurrentLocal() == "ar" ?  height == 54 ?  100: 0 : 60,
                                    bottom: height == 54 ? 0 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: height == 54 ? 1 : 3,
                                        itemBuilder: (context, index) {
                                          if(height == 54){
                                            return languageCard(context, HiveStorageManager.getCurrentLocal(), 54);
                                          }else{
                                            return languageCard(context,locales[index], height);
                                          }
                                        }
                                    ),
                                  ),
                                  Align(
                                    alignment: HiveStorageManager.getCurrentLocal() == "ar" ? const Alignment( -1, -1) : const Alignment(1, -1),
                                    child: SizedBox(
                                      width: 30,
                                      height: 50,
                                      child: AnimatedRotation(
                                        turns: height == 54 ? 0 : 0.5,
                                        duration: const Duration(milliseconds: 300),
                                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: (){
                        context.push('/myVivadoo/termsOfUse');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white38,
                          border: Border.all(
                              color: Constants.orange.withOpacity(0.4),
                              width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.terms_and_conditions),
                            const Icon(Icons.keyboard_arrow_right, size: 30,)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget languageCard(BuildContext context, String language, double height) {
  String title = switch(language){
    "en"=>"English",
    "ar"=>"العربية",
    "fr"=>"Français",
    String() => throw UnimplementedError(),
  };
    return GestureDetector(
      onTap: height == 54 ? (){
        context.read<MyVivadooProfileProvider>().changeLanguageTabHeight();
      }:(){
        main.MyApp.setLocale(context, Locale(language));
        HiveStorageManager.hiveBox.put("locale", language);
        // context.read<MyVivadooProfileProvider>().changeLanguageTabHeight();
        // context.read<NavBarProvider>().setNavBarData(context);
      },
      child: Container(
        width: double.infinity,
          height: 50,
          alignment:  Alignment.centerLeft,
          color: Colors.transparent,
          child: Text(title)),
    );


}