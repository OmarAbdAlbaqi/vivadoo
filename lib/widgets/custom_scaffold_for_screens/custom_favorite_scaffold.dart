import 'package:flutter/material.dart';


class CustomFavoriteScaffold extends StatelessWidget {
  const CustomFavoriteScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Image.asset("assets/images/logo.png" , width: 100,),
            ),
            const SizedBox(width: 8),
            const Text("Favorites" , style: TextStyle(fontWeight: FontWeight.w600),),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
