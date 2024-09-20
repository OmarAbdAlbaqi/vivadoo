import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../../providers/my_vivadoo_providers/auth/user_info_provider.dart';
import '../../../utils/pop-ups/pop_ups.dart';
import '../../ad_cards/full_width_ad_card.dart';
class MyVivadooProfile extends StatelessWidget {
  const MyVivadooProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 236, 247, 1),
      floatingActionButton: Visibility(
        visible: HiveStorageManager.hiveBox.get('signedIn'),
        child: GestureDetector(
          onTap: (){
            PopUps.logoutConfirmation(context);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 140,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color.fromRGBO(255, 0, 0, 1),
            ),
            child:
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white, size: 30,),
                Text("Logout", style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),)
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          GestureDetector(
            onTap: (){
              context.go('/myVivadoo/editAccountDetails');
            },
            child: ValueListenableBuilder<Box<UserInfoModel>>(
              valueListenable: HiveStorageManager.getUserInfoModel().listenable(),
              builder: (context, userInfoBox, _){
                UserInfoModel? userInfo;
                if(userInfoBox.values.toList().cast<UserInfoModel>().isNotEmpty){
                   userInfo = userInfoBox.values.toList().cast<UserInfoModel>()[0];
                }
                return Visibility(
                  visible: userInfoBox.values.toList().cast<UserInfoModel>().isNotEmpty,
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: width,
                    height: 100,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                          child: Image.asset('assets/images/vivadoo.png' , width: 50,),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${userInfo?.firstName ?? ""} ${userInfo?.lastName ?? ""}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                            const SizedBox(height: 4),
                            Text(userInfo?.emailAddress ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),),
                          ],
                        ),
                        const Spacer(),
                        Image.asset('assets/icons/edit.png', width: 35)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(
            height: 20,
          ),
          GestureDetector(
              onTap: () async {

              },
              child: const Text("My Ads")),

          Selector<UserInfoProvider,List<AdModel>>(
            selector: (context, prov) => prov.userAds,
            builder: (context, ads, _){
              if(ads.isNotEmpty){
                return ListView.builder(
                  // controller: context.watch<FilteredAdsProvider>().scrollControllerFiltered,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      return AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                                duration: const Duration(
                                    milliseconds: 300),
                                verticalOffset:  120,
                                child: FullWidthAdCard(
                                  adModel: ads[index], index: index,))),
                      );
                    });
              }else{
                return SizedBox(
                  height: 330,
                  child: Column(
                    children: [
                      Image.asset("assets/no_data.png", height: 300,),
                      const Spacer(),
                      const Text("Sorry we didn't find any result!", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),),
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
