import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/favorite_providers/favorite_provider.dart';

import '../../models/ad_model.dart';
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.adModel});

  final AdModel adModel;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
      setState(() {
      });
      });

    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, prov, _) {
        if(prov.favoriteAds.any((element) => element.id == widget.adModel.id)){
            _controller.forward();
        }else{
            _controller.reverse();
        }
        return GestureDetector(
          onTap: (){
            context.read<FavoriteProvider>().favoriteButtonPressed(widget.adModel);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: _animation.value,
                child:  Image.asset("assets/icons/nav_bar_icons/heart.png" , color: Colors.red ,width: 22,),
              ),
              Transform.scale(
                scale: 1 - _animation.value,
                child: Image.asset("assets/icons/nav_bar_icons/filled_heart.png" , color: Colors.red ,width: 22,),
              ),
            ],
          ),
        );
      }
    );
  }
}
