import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_details_model.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/screens/ad_details/post_details_screen.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../providers/home_providers/home_page_provider.dart';

class CarouselAdsWidget extends StatefulWidget {
  const CarouselAdsWidget({super.key, required this.isFavorite, required this.initialIndex});
  final bool isFavorite;
  final int initialIndex;

  @override
  State<CarouselAdsWidget> createState() => _CarouselAdsWidgetState();
}

class _CarouselAdsWidgetState extends State<CarouselAdsWidget> {
  late PageController controller;

  @override
  void initState() {
    int initialPage = context.read<AdDetailsProvider>().initialPage;
    controller = PageController(initialPage: initialPage, viewportFraction: 1.01);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<AdDetailsModel> listOfAdDetails = context.read<AdDetailsProvider>().listOfAdDetails;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        itemCount: listOfAdDetails.length,
        controller: controller,
        pageSnapping: true,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 1;
              if (controller.position.haveDimensions) {
                double pageOffset = controller.page ?? controller.initialPage.toDouble();
                value = (1 - ((pageOffset - index).abs() * 0.1)).clamp(0.9, 1.0);
              }

              return Transform.scale(
                scale: value,
                child: child, // ✅ Child is passed to avoid unnecessary rebuilds
              );
            },
            child: PostDetailsScreen(
              isFavorite: HiveStorageManager.getFavoriteAds().values.toList().any((element)=> element.id == listOfAdDetails[index].id),
              index: index,
            ),
          );
        },
        onPageChanged: (index) {
          String prevRoute = HiveStorageManager.hiveBox.get('prevRoute');
          context.read<AdDetailsProvider>().getAdDetails(context, listOfAdDetails[index].id.toString());

          if (index >= listOfAdDetails.length - 3 && prevRoute != "Saved") {
            if (!context.read<HomePageProvider>().homePageLoading) {
              context.read<AdsProvider>().getMoreAds(context);
            }
          }
        },
      ),
    );
  }
}
