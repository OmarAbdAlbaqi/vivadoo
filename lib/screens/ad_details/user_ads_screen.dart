import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/ad_cards/full_width_card_standard.dart';
class UserAdsScreen extends StatefulWidget {
  const UserAdsScreen({super.key});

  @override
  State<UserAdsScreen> createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 247, 1),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()=> Get.back(),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: const Icon(Icons.arrow_back_ios_new_outlined , color: Color(0xFFffffff),),
          ),
        ),
        centerTitle: true,
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
        backgroundColor: const Color.fromRGBO(88, 89, 91, 1),
        title: const Text("User Ads" , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500 , color: Color(0xFFffffff) , ),),
      ),
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child:CachedNetworkImage(
              imageUrl: "https://c4.wallpaperflare.com/wallpaper/568/750/440/nissan-gt-r-nissan-liberty-walk-lb-works-japanese-cars-hd-wallpaper-preview.jpg",
              fit: BoxFit.cover,
              color: Colors.grey,
              colorBlendMode: BlendMode.color,
            )
          ),
          ListView(
            children: [
              AspectRatio(
                aspectRatio: 1,
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemCount: 4,
              //     itemBuilder: (context , index){
              //     return UserPostCard(isFavorite: false);
              //     })
            ],
          ),
        ],
      ),
    );
  }
}
