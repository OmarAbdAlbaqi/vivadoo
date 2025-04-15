import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/favorite_providers/favorite_provider.dart';

import '../../widgets/ad_cards/full_width_ad_card.dart';
import '../../widgets/ad_cards/native_ad_card.dart';

class Saved extends StatelessWidget {
  const Saved({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, prov, _){
        if(prov.favoriteAds.isNotEmpty){
          return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: prov.favoriteAds.length,
              itemBuilder: (context, index) {
                return prov.favoriteAds[index].typeAd == "native"
                    ? NativeAdCard(adModel: prov.favoriteAds[index], index: index,)
                    : FullWidthAdCard(
                    adModel: prov.favoriteAds[index], index: index);
              }
          );
        }else{
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 162,
                width: double.infinity,
              ),
              SizedBox(
                  width: 250,
                  child: Image.asset("assets/icons/nav_bar_icons/heart_bold.png" , color: Colors.grey.withAlpha(20),fit: BoxFit.fill,)),
               Align(
                alignment: const Alignment(0, -0.1),
                child: Text("Your favorites are empty", textAlign: TextAlign.center,style: TextStyle(fontSize: 22, color: Colors.black.withAlpha(200), fontWeight: FontWeight.w600),),
              ),
               Align(
                alignment: const Alignment(0, 0.1),
                child:  Text("Tab the heart icon on any ad to make it your favorite!", textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.black.withAlpha(200), fontWeight: FontWeight.w500),),
              ),
            ],
          );
        }
        
      },
    );
  }
}
