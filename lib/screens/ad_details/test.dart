import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_details_model.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/screens/ad_details/post_details_screen.dart';

import '../../main.dart';
import '../../providers/general/home_page_provider.dart';
import '../../utils/page_ttransform/page_transformer.dart';
class CarouselTest extends StatefulWidget {
  const CarouselTest({super.key, required this.isFavorite, required this.adId, required this.initialIndex});
  final bool isFavorite;
  final String adId;
  final int initialIndex;

  @override
  State<CarouselTest> createState() => _CarouselTestState();
}

class _CarouselTestState extends State<CarouselTest> {
  PageController controller = PageController();


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) async {
        context.read<HomePageProvider>().setHomeType(HomeType.home);
      },
      child: Selector<AdDetailsProvider, List<AdDetailsModel>>(
        selector: (context, prov) => prov.listOfAdDetails,
        builder: (context, listOfAdDetails, _) {
          return Material(
            color: Colors.white54,
            child: TransformerPageView(
              index: widget.initialIndex,
              transformer:  DepthPageTransformer(),
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index){
                context.read<AdDetailsProvider>().setCurrentAdIndex(index!);
                context.read<AdDetailsProvider>().getAdDetails(context, listOfAdDetails[index].id.toString());
                if(index >= listOfAdDetails.length -2){
                  context.read<AdsProvider>().getMoreAds(context);
                }
              },
              // controller: PageController(initialPage: widget.initialIndex),
              itemCount: context.watch<AdDetailsProvider>().listOfAdDetails.length,
              itemBuilder: (context, index) {
                return PostDetailsScreen(isFavorite: false, adDetailsModel: listOfAdDetails[index]);
              },
            ),
          );
        }
      ),
    );
  }
}
