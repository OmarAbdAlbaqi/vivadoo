import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivadoo/widgets/post_new_ad_widgets/photos_widget/add_photos_widget.dart';

class PostNewAd extends StatefulWidget {
  const PostNewAd({super.key});

  @override
  State<PostNewAd> createState() => _PostNewAdState();
}

class _PostNewAdState extends State<PostNewAd> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        AddPhotosWidget(),
      ],
    );
  }

}


