import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/ads_provider/ad_details_provider.dart';
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key, required this.isFav});
  final bool isFav;

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;
  late bool isFav;
  @override
  void initState() {
    isFav = widget.isFav;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    if(isFav){
      _controller.forward();
    }else{
      _controller.reverse();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        print(isFav);
        if(isFav){
          _controller.reverse();
          isFav = false;
        }else{
          _controller.forward();
          isFav = true;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Selector<AdDetailsProvider , double>(
            selector: (_ , prov) => prov.titleOpacity,
            builder: (_ , opacity , child) {
              return Transform.scale(
                scale: _animation.value,
                child: Icon(
                  Icons.favorite_outline,
                  size: 30,
                  color: Color.lerp(
                      Colors.white, Colors.black , opacity),
                ),
              );
            }
          ),
          Transform.scale(
            scale: 1 - _animation.value,
            child: const Icon(
              Icons.favorite,
              size: 30,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
