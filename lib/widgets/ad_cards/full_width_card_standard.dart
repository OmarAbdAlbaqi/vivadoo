import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/ad_model.dart';
import '../../providers/ads_provider/ad_details_provider.dart';
class FullWidthStandardAdCard extends StatefulWidget {
  const FullWidthStandardAdCard({super.key, required this.adModel, required this.index, });
  final AdModel adModel;
  final int index;
  @override
  State<FullWidthStandardAdCard> createState() => _FullWidthStandardAdCardState();
}

class _FullWidthStandardAdCardState extends State<FullWidthStandardAdCard> with TickerProviderStateMixin{

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
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        context.read<AdDetailsProvider>().initialPage = widget.index;
        context.read<AdDetailsProvider>().getAdDetails(context, widget.adModel.id.toString());
        context.push('/homePageAdDetails', extra: {'isFavorite':false, 'adId':widget.adModel.id.toString(),'initialIndex':widget.index});
      },
      child: Container(
        width: double.infinity,
        height: 170,
        color: const Color.fromRGBO(245, 246, 247, 1),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 180,
          decoration: BoxDecoration(
            color: widget.adModel.adFeatured == true ? const Color.fromRGBO(252, 241, 220, 1) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
               BoxShadow(
                color: Color(0xFF000000),
                spreadRadius: -3,
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                width: 168,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    tag: widget.adModel.thumb,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.adModel.thumb,
                        placeholder: (context , _){
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.1),
                            highlightColor: Colors.grey.withOpacity(0.4),
                            child: Container(
                              height: double.infinity,
                              width: 168,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top:  8, bottom: 16, left: 2, right: 8),
                height: 170,
                width: MediaQuery.of(context).size.width -196,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 36,
                          width: width - 220,
                          child: Text(widget.adModel.title,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),)
                        ),
                        Visibility(
                          visible: widget.adModel.typeAd == "premium",
                            child: SizedBox(
                                height: 36,
                                width: 4,
                                child: Image.asset("assets/icons/arrows.png" , fit: BoxFit.cover,)))
                      ],
                    ),
                    const SizedBox(height: 8),
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
                        Flexible(
                            child: Text(widget.adModel.location ,maxLines: 1, style: const TextStyle(fontSize: 12,color: Color(0xFF000000) , overflow: TextOverflow.ellipsis),))
                      ],
                    ),
                    const SizedBox(height: 12),
                    widget.adModel.userIsPro == 1 && widget.adModel.userPro.isNotEmpty ?
                    CachedNetworkImage(
                      imageUrl: widget.adModel.userPro['company_logo'] ?? "https://www.vivadoo.com/images/logo.png",
                      width: 40,
                      height: 25,
                      errorWidget: (context , err , _){
                        return const Center();
                      },
                        placeholder: (context , _){
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.1),
                            highlightColor: Colors.grey.withOpacity(0.4),
                            child: Container(
                              height: 50,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                    ) :
                    const Center(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.adModel.price , style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w700),),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
