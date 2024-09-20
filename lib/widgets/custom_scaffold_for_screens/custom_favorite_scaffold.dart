import 'package:flutter/material.dart';


class CustomFavoriteScaffold extends StatelessWidget {
  const CustomFavoriteScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 246, 255, 1),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight:  120,
        backgroundColor: Colors.white,
        leading: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: const Color.fromRGBO(245, 246, 255, 1),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 60),
              width: double.infinity,
              height:  120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular( MediaQuery.of(context).size.width / 5 ), bottomRight: Radius.circular( MediaQuery.of(context).size.width / 5 ))
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
        leadingWidth: double.infinity,
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
