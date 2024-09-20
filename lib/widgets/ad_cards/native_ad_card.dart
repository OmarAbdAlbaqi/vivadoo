import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:vivadoo/widgets/general_widgets/favorite_button.dart';

import '../../models/ad_model.dart';
import '../../providers/ads_provider/ad_details_provider.dart';
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key, required this.adModel, required this.index});
  final AdModel adModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(HiveStorageManager.getCurrentRoute() == "Saved"){
          context.read<AdDetailsProvider>().initialPage = index;
          context.read<AdDetailsProvider>().getAdDetails(context, adModel.id.toString());
          context.push('/homePageAdDetails', extra: {'isFavorite':false, 'adId':adModel.id.toString(),'initialIndex':index});
          HiveStorageManager.hiveBox.put('prevRoute', 'Saved');
        }else{
          context.read<AdDetailsProvider>().initialPage = 0;
          context.read<AdDetailsProvider>().getAdDetails(context, adModel.id.toString());
          context.push('/homePageAdDetails', extra: {'isFavorite':false, 'adId':adModel.id.toString(),'initialIndex':0});
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: MediaQuery.of(context).size.width - 8,
        height: 410,
        decoration: BoxDecoration(
            color: const Color(0xFFffffff),
          borderRadius: BorderRadius.circular(3)
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: CachedNetworkImage(
                  imageUrl: adModel.thumb,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                placeholder: (context , _){
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.4),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                      ),
                    );
                },
                errorWidget: (context, err, _){
                    return Image.network(adModel.thumb, height: 200);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16 , left: 16 , right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: Text(adModel.title , maxLines: 2, style: const TextStyle(color: Color(0xFF000000) , fontSize: 14 ,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4 , bottom: 20),
                  width: double.infinity,
                  height: 25,
                  child: Text(adModel.price , maxLines: 1, style: const TextStyle(fontSize: 18 ,overflow: TextOverflow.ellipsis , fontWeight: FontWeight.w800),),
                ),
                CachedNetworkImage(
                    imageUrl: adModel.userPro['company_logo'],
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width - 48,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.watch_later_rounded , color: Color(0xFF58595b),size: 18,),
                              const SizedBox(width:  6),
                              Text(adModel.date , style: const TextStyle(fontSize: 12,color: Color(0xFF000000),),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on , color: Colors.grey.withOpacity(0.4), size: 18,),
                              const SizedBox(width:  6),
                              Text(adModel.location ,maxLines: 1, style: const TextStyle(fontSize: 12,color: Color(0xFF000000) , overflow: TextOverflow.ellipsis),)
                            ],
                          ),
                        ],
                      ),
                      FavoriteButton(adModel: adModel),
                      // GestureDetector(
                      //   onTap: (){
                      //     if (isFavorite) {
                      //       _controller.reverse();
                      //     } else {
                      //       _controller.forward();
                      //     }
                      //     setState(() {
                      //       isFavorite =! isFavorite;
                      //     });
                      //     // widget.favorite();
                      //   },
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       Transform.scale(
                      //         scale: _animation.value,
                      //         child:  Image.asset("assets/icons/nav_bar_icons/heart.png" , color: Colors.red ,width: 22,),
                      //       ),
                      //       Transform.scale(
                      //         scale: 1 - _animation.value,
                      //         child: Image.asset("assets/icons/nav_bar_icons/filled_heart.png" , color: Colors.red ,width: 22,),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
