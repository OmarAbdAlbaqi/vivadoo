import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/user_ads_screen_provider.dart';

import '../../widgets/ad_cards/full_width_card_standard.dart';
class UserAdsScreen extends StatelessWidget {
  const UserAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("\n\n\n\n test building \n\n\n");
    return Scaffold(
      body: Consumer<UserAdsScreenProvider>(
        builder: (context, prov , _) {
          return CustomScrollView(
            controller: prov.scrollController,
            slivers: [
              SliverAppBar(
                surfaceTintColor: const Color.fromRGBO(88, 89, 91, 1),
                expandedHeight: MediaQuery.of(context).size.width * 0.8,
                pinned: true,
                backgroundColor: Colors.orange,
                centerTitle: false,
                stretch: true,
                leadingWidth: 65,
                // title: const Text("Title Text", style: TextStyle(color: Colors.orange),),
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 65,
                      color: Colors.transparent,
                      child: const Icon(Icons.arrow_back_ios_new_outlined , color: Color(0xffffffff),)),
                ),
                actions: [
                  GestureDetector(
                    onTap: (){},
                    child: Image.asset("assets/icons/user_ads_icons/paper-plane.png" , height: 30, color: Color(0xFFffffff),),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: (){},
                    child: Image.asset("assets/icons/user_ads_icons/notebook-of-contacts.png" , color: Colors.white,height: 30,),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: const Icon(Icons.star_rounded , color: Color(0xFFffffff),size: 40,),
                  ),
                  const SizedBox(width: 6),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: AnimatedContainer(
                    padding: const EdgeInsets.only(bottom: 16),
                    color: Colors.transparent,
                    duration: const Duration(milliseconds: 100),
                      alignment: Alignment(prov.scrollValue,1),
                      width: double.infinity,
                      child: const Text("Title Text", style: TextStyle(color: Colors.white),)),
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: AspectRatio(
                      aspectRatio: 1,
                      child:CachedNetworkImage(
                        imageUrl: "https://c4.wallpaperflare.com/wallpaper/568/750/440/nissan-gt-r-nissan-liberty-walk-lb-works-japanese-cars-hd-wallpaper-preview.jpg",
                        fit: BoxFit.cover,
                        color: Colors.grey,
                        colorBlendMode: BlendMode.color,
                      )
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                        return Container(
                          height: 1500,
                        );
                      }
                  ))
            ],
          );
        }
      ),
    );
  }
}
