import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import '../../../screens/ad_details/post_details_screen.dart';
import '../../../screens/ad_details/carousel_ads_widget.dart';
class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.imageUrl, required this.title, required this.price, required this.isFavorite, required this.favorite, required this.adId, required this.index});
  final String imageUrl;
  final String title;
  final String price;
  final bool isFavorite;
  final  VoidCallback favorite;
  final String adId;
  final int index;
  

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin{
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
    if (!widget.isFavorite) {
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
        context.read<AdDetailsProvider>().initialPage = widget.index;
        context.read<AdDetailsProvider>().getAdDetails(context, widget.adId);
        context.push('/homePageAdDetails', extra: {'isFavorite':false, 'initialIndex':widget.index});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(0, 2),
              blurRadius: 3,
              spreadRadius: -3,
            ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 1.22,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4) , topRight: Radius.circular(4)),
                child: Hero(
                  tag: widget.imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.4),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: AspectRatio(
                        aspectRatio: 1.22,
                        child: Container(
                          decoration: const  BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4) , topRight: Radius.circular(4)),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16 , left: 12),
              child: Text(widget.title ,maxLines: 2, style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 12 , bottom: 8 , right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.price , style: const TextStyle(fontSize: 16 , color: Colors.red , fontWeight: FontWeight.w600),),
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
                      widget.favorite();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: _animation.value,
                          child:  Image.asset("assets/icons/nav_bar_icons/heart.png" , color: Colors.red,width: 22,),
                        ),
                        Transform.scale(
                          scale: 1 - _animation.value,
                          child: Image.asset("assets/icons/nav_bar_icons/filled_heart.png" , color: Colors.red ,width: 22,),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
