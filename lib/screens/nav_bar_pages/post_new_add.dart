import 'package:flutter/material.dart';
class PostNewAd extends StatefulWidget {
  const PostNewAd({super.key});

  @override
  State<PostNewAd> createState() => _PostNewAdState();
}

class _PostNewAdState extends State<PostNewAd> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Post new ad"),
    );
  }
}
