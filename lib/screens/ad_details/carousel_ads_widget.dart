import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/screens/ad_details/post_details_screen.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../providers/home_providers/home_page_provider.dart';
class CarouselAdsWidget extends StatefulWidget {
  const CarouselAdsWidget({super.key, required this.isFavorite,  required this.initialIndex});
  final bool isFavorite;
  final int initialIndex;

  @override
  State<CarouselAdsWidget> createState() => _CarouselAdsWidgetState();
}

class _CarouselAdsWidgetState extends State<CarouselAdsWidget> {
  late PageController controller;
  double _previousPage = 0;

  @override
  void initState() {
    int initialPage = context.read<AdDetailsProvider>().initialPage;
    controller = PageController(initialPage: initialPage, viewportFraction: 1.01)..addListener(_onPageViewScroll);
    super.initState();
  }
  @override
  void dispose() {
    controller.removeListener(_onPageViewScroll);
    controller.dispose();
    super.dispose();
  }

  void _onPageViewScroll() {
    double currentPage = controller.page!;
    if (currentPage > _previousPage) {
      //next page

    } else if (currentPage < _previousPage) {
      //previous page
    }
    _previousPage = currentPage;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AdDetailsProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: PageView.builder(
            itemCount: prov.listOfAdDetails.length,
            padEnds: true,
            controller: controller,
            pageSnapping: true,
              itemBuilder: (context, index){
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    double value = -1;
                    if (controller.position.haveDimensions) {
                      value = controller.page! - index;
                      value = (1 - (value.abs() * 0.15)).clamp(0.0, 1);
                    }
                    return Transform(
                      transform: Matrix4.identity()
                        ..scale(value)
                        ..translate(value * 1),
                      child: PostDetailsScreen(isFavorite: false, adDetailsModel: prov.listOfAdDetails[index]),
                    );
                  },
                );
              },
            onPageChanged: (index){
              String prevRoute = HiveStorageManager.hiveBox.get('prevRoute');
              context.read<AdDetailsProvider>().getAdDetails(context, prov.listOfAdDetails[index].id.toString());
              if(index >= prov.listOfAdDetails.length - 3 && prevRoute != "Saved"){
                if(!context.read<HomePageProvider>().homePageLoading){
                  context.read<AdsProvider>().getMoreAds(context);
                }
              }
            },
          ),
        );
      }
    );
  }
}
