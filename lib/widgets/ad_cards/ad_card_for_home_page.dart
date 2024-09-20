import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/widgets/general_widgets/favorite_button.dart';
class AdCardForHomePage extends StatelessWidget {
  const AdCardForHomePage({super.key,required this.adModel, required this.index});
  final AdModel adModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<AdDetailsProvider>().initialPage = index;
        context.read<AdDetailsProvider>().getAdDetails(context, adModel.id.toString());
        context.push('/homePageAdDetails', extra: {'isFavorite':false, 'initialIndex':index});
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
                  tag: adModel.thumb,
                  child: CachedNetworkImage(
                    imageUrl: adModel.thumb,
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
              child: Text(adModel.title ,maxLines: 2, style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 12 , bottom: 8 , right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(adModel.price , style: const TextStyle(fontSize: 16 , color: Colors.red , fontWeight: FontWeight.w600),),
                  FavoriteButton(adModel: adModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
