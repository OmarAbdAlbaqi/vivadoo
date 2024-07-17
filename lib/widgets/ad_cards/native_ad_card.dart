import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/ad_model.dart';
import '../../providers/ads_provider/ad_details_provider.dart';
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key, required this.adModel});
  final AdModel adModel;

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    if (true) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<AdDetailsProvider>().initialPage = 0;
        context.read<AdDetailsProvider>().getAdDetails(context, widget.adModel.id.toString());
        context.push('/homePageAdDetails', extra: {'isFavorite':false, 'adId':widget.adModel.id.toString(),'initialIndex':0});
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
                  imageUrl: widget.adModel.thumb,
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
                }
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
                  child: Text(widget.adModel.title , maxLines: 2, style: const TextStyle(color: Color(0xFF000000) , fontSize: 14 ,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4 , bottom: 20),
                  width: double.infinity,
                  height: 25,
                  child: Text(widget.adModel.price , maxLines: 1, style: const TextStyle(fontSize: 18 ,overflow: TextOverflow.ellipsis , fontWeight: FontWeight.w800),),
                ),
                CachedNetworkImage(
                    imageUrl: widget.adModel.userPro['company_logo'],
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
                              Text(widget.adModel.date , style: const TextStyle(fontSize: 12,color: Color(0xFF000000),),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on , color: Colors.grey.withOpacity(0.4), size: 18,),
                              const SizedBox(width:  6),
                              Text(widget.adModel.location ,maxLines: 1, style: const TextStyle(fontSize: 12,color: Color(0xFF000000) , overflow: TextOverflow.ellipsis),)
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          if (isFavorite) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                          setState(() {
                            isFavorite =! isFavorite;
                          });
                          // widget.favorite();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: _animation.value,
                              child:  Image.asset("assets/icons/nav_bar_icons/heart.png" , color: Colors.red ,width: 22,),
                            ),
                            Transform.scale(
                              scale: 1 - _animation.value,
                              child: Image.asset("assets/icons/nav_bar_icons/filled_heart.png" , color: Colors.red ,width: 22,),
                            ),
                          ],
                        ),
                      ),
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
