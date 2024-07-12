import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/custom_widget_provider/steps_bar_widget_provider.dart';
import 'package:vivadoo/widgets/auth/auth_input.dart';
import 'package:vivadoo/widgets/post_new_ad_widgets/photos_widget/add_photos_widget.dart';

import '../../widgets/custom_post_new_ad_scaffold.dart';
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


