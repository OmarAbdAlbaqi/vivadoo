import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';


Widget shareButton(){
  return GestureDetector(
    onTap: () {
      print("share link");
      // SocialShare.shareOptions(widget.adDetailsModel.longLink ?? "");
    },
    child: Consumer<AdDetailsProvider>(
      builder: (_ , prov , child) {
        return Icon(Icons.share , color: Color.lerp(
            Colors.white, Colors.black , prov.titleOpacity),);
      }
    ),
  );
}