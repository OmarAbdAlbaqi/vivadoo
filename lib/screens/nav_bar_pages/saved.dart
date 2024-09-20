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
              Image.asset("assets/no_data.png"),
              const Align(
                alignment: Alignment(0, 0.5),
                child: Text("Sorry we didn't find any result!", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),),
              ),
            ],
          );
        }
        
      },
    );
  }
}
