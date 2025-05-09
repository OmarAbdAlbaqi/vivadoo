import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:social_share/social_share.dart';
import '../../models/ad_details_model.dart';
import '../../providers/ads_provider/ad_details_provider.dart';


import '../../constants.dart';
class PreviewAd extends StatefulWidget {
  const PreviewAd({super.key, required this.isFavorite, required this.adDetailsModel,});
  final bool isFavorite;
  final AdDetailsModel adDetailsModel;

  @override
  State<PreviewAd> createState() => _PreviewAdState();
}

class _PreviewAdState extends State<PreviewAd> with TickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> _animation;
  late TabController tabController;


  @override
  void initState() {
    tabController = TabController(length: 2 , vsync: this);
    tabController.addListener(() {
      tabController.index == 0 ? context.read<AdDetailsProvider>().setIsSummary(true) : context.read<AdDetailsProvider>().setIsSummary(false);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 190) {
        context.read<AdDetailsProvider>().setTitleOpacity(1);
      } else {
        context.read<AdDetailsProvider>().setTitleOpacity(0);
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    if (!widget.isFavorite) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool isFavorite = false;
  double initialPositionX = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, innerBoxIsScrolled){
              return [
                SliverAppBar(
                  surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
                  expandedHeight: 300,
                  collapsedHeight: 50,
                  toolbarHeight: 50,
                  pinned: true,
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                  elevation: 0,
                  centerTitle: true,
                  stretch: true,
                  bottom: const PreferredSize(
                    preferredSize: Size(0,0),
                    child: Divider(
                      height: 0,
                      thickness: 0.5,
                    ),
                  ),
                  title: AnimatedOpacity(
                    opacity:  context.watch<AdDetailsProvider>().titleOpacity,
                    duration: const Duration(milliseconds: 300),
                    child: Text(widget.adDetailsModel.title ?? "" ,maxLines: 1,style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w700 , color: Colors.black , overflow: TextOverflow.ellipsis),),
                  ),
                  leading: GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_outlined , color: Color(0xffffffff),),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: (){
                        if (isFavorite) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                        setState(() {
                          isFavorite =! isFavorite;
                        });
                        // widget.favorite();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: _animation.value,
                            child:  Image.asset("assets/icons/nav_bar_icons/heart.png" , color: Colors.white ,width: 25,),
                          ),
                          Transform.scale(
                            scale: 1 - _animation.value,
                            child: Image.asset("assets/icons/nav_bar_icons/filled_heart.png" , color: Colors.red ,width: 25,),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        print("share link");
                          // SocialShare.shareOptions(widget.adDetailsModel.longLink ?? "");
                      },
                      child: const Icon(Icons.share , color: Colors.white,),
                    ),
                    const SizedBox(width: 12),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: Stack(
                      children: [
                        PageView.builder(
                            onPageChanged: (value){
                              context.read<AdDetailsProvider>().setImageIndex(value);
                            },
                            itemCount: widget.adDetailsModel.images.length,
                            itemBuilder: (context , index){
                              return List.generate(widget.adDetailsModel.images.length ?? 0, (index) =>
                                  ImageHolder(
                                      onTap: (){
                                        showCupertinoModalPopup(
                                            useRootNavigator: false,
                                            context: context,
                                            builder: (_){
                                              return Material(
                                                child: Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context).size.height * 0.9,
                                                  color: Colors.black,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 100,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){
                                                                context.pop();
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width: 70,
                                                                color: Colors.transparent,
                                                                padding: const EdgeInsets.only(left: 12),
                                                                alignment: Alignment.centerLeft,
                                                                child: const Icon(Icons.close , color: Colors.white,),
                                                              ),
                                                            ),
                                                            DropdownButtonHideUnderline(
                                                              child: DropdownButton2<String>(
                                                                isExpanded: true,
                                                                alignment: Alignment.center,
                                                                hint: const Text("Save" , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900 ,color: Colors.white ),),
                                                                items: const [
                                                                  // DropdownMenuItem(
                                                                  //   value: "photo",
                                                                  //   child: Container(
                                                                  //       alignment: Alignment.center,
                                                                  //       height: 30,
                                                                  //       child: const Text("Photo", style: TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w500),)),
                                                                  // ),
                                                                  //
                                                                  // DropdownMenuItem(
                                                                  //   value: "all photos",
                                                                  //   child: Container(
                                                                  //       alignment: Alignment.center,
                                                                  //       height: 30,
                                                                  //       child: const Text("All Photos", style: TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w500),)),
                                                                  // ),
                                                                ],
                                                                onChanged: (String? value) {
                                                                  // if(value == "photo"){
                                                                  //   _saveNetworkImage(widget.adDetailsModel.images[index]['original'], widget.adDetailsModel.title ?? "").then((value) {
                                                                  //     Get.rawSnackbar(
                                                                  //       message: "Image saved to your gallery!",
                                                                  //     );
                                                                  //   });
                                                                  // }
                                                                  // else if (value == "all photos"){
                                                                  //   for (int i =0 ; i < widget.adDetailsModel.images.length    ; i++){
                                                                  //     _saveNetworkImage(widget.adDetailsModel.images[i]['original'], "${widget.adDetailsModel.title}$i").then((value) {
                                                                  //       Get.rawSnackbar(
                                                                  //         message: "Image saved to your gallery!",
                                                                  //       );
                                                                  //     });
                                                                  //   }
                                                                  // }
                                                                },
                                                                buttonStyleData: const ButtonStyleData(
                                                                  width: 120,
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomRight: Radius.circular(8),
                                                                      bottomLeft: Radius.circular(8),
                                                                    ),
                                                                    color: Constants.orange,
                                                                  ),
                                                                ),
                                                                iconStyleData: const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons.arrow_drop_down,
                                                                    color: Colors.transparent,
                                                                    size: 0,
                                                                  ),
                                                                ),
                                                                dropdownStyleData: DropdownStyleData(
                                                                  padding: EdgeInsets.zero,
                                                                  maxHeight: 100,
                                                                  width: 130,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                    color: const Color.fromRGBO(66,69,72 ,1),
                                                                  ),
                                                                  offset: const Offset(-6, -6),
                                                                ),
                                                                menuItemStyleData: const MenuItemStyleData(
                                                                    padding: EdgeInsets.zero
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 70,
                                                              height: 60,
                                                              alignment: Alignment.center,
                                                              child: Selector<AdDetailsProvider , int>(
                                                                  selector: (context, prov) => prov.originalImageIndex,
                                                                  builder: (context , imageIndex , _) {
                                                                    return Text("${imageIndex.toString()}/${widget.adDetailsModel.images.length}" , style: const TextStyle(fontSize: 13 , color: Colors.white , fontWeight: FontWeight.w700),);
                                                                  }
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: PageView.builder(
                                                            controller: PageController(initialPage: context.read<AdDetailsProvider>().imageIndex -1),
                                                            onPageChanged: (value){
                                                              context.read<AdDetailsProvider>().setOriginalImageIndex(value);
                                                            },
                                                            itemCount: widget.adDetailsModel.images.length,
                                                            itemBuilder: (context , index){
                                                              return List.generate(widget.adDetailsModel.images.length??0, (index) =>
                                                                  Dismissible(
                                                                      onDismissed: (value){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      behavior: HitTestBehavior.opaque,
                                                                      direction: DismissDirection.down,
                                                                      key: const Key("i don't why this"),
                                                                      child: InteractiveViewer(
                                                                        panEnabled: true,
                                                                        boundaryMargin: const EdgeInsets.all(100),
                                                                        minScale: 0.5,
                                                                        maxScale: 5,
                                                                        child: Image.file(
                                                                          File(widget.adDetailsModel.images[index]['main']),
                                                                          fit: BoxFit.contain,
                                                                        ),

                                                                      )
                                                                  ))[index];
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      imagePath: widget.adDetailsModel.images[index]['main'],
                                      ))[index];
                            }),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            width: double.infinity,
                            height: 24,
                            color: Colors.black.withOpacity(0.3),
                            alignment: Alignment.centerLeft,
                            child: Selector<AdDetailsProvider , int>(
                                selector: (context, prov) => prov.originalImageIndex,
                                builder: (context , imageIndex , _) {
                                  return Text("${imageIndex.toString()}/${widget.adDetailsModel.images.length}" , style: const TextStyle(fontSize: 13 , color: Colors.white , fontWeight: FontWeight.w700),);
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [

                //title price address
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.only(left: 16 , top: 20 , bottom: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( widget.adDetailsModel.title ?? "null", style: const TextStyle(fontSize: 18 , color: Color(0xff000000) ),),
                      const SizedBox(height: 25),
                      Text(widget.adDetailsModel.priceFormatted ?? "null" , style: const TextStyle(fontSize: 18 , color: Color(0xff000000) , fontWeight: FontWeight.w700),),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.location_on , color: Colors.orange,),
                          Text(widget.adDetailsModel.location ?? "" , style: const TextStyle(color: Color.fromRGBO(245, 102, 1, 1) , fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //user card
                GestureDetector(
                  onTap: (){
                    // Get.to(
                    //     () => const UserAdsScreen(),
                    //   transition: Transition.native,
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeInOut
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8 , right: 8),
                    width: double.infinity,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 3),
                          blurRadius: 3,
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0, -3),
                          blurRadius: 3,
                          spreadRadius: -3,
                        ),
                      ],
                    ),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 245, 246, 247)
                          ),
                          child: Image.asset("assets/icons/default_profile.png" , fit: BoxFit.cover,),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                                visible: widget.adDetailsModel.postBy != null,
                              replacement: Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.3),
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  )),
                                child: Text(widget.adDetailsModel.postBy ?? "" , style: const TextStyle(color: Color(0xff000000) ),),
                            ),
                            const SizedBox(height: 6),
                            Visibility(
                                visible: widget.adDetailsModel.since != null,

                                child: Text(widget.adDetailsModel.since ?? "" , style: TextStyle(fontSize: 12,color: Colors.grey.withOpacity(0.7) ),)
                            ),
                            Visibility(
                                visible: widget.adDetailsModel.userIsPro  ==  1 ? true : false ,
                                child: const Row(
                                  children: [
                                    Icon(Icons.star , color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star, color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star, color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star, color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star_half, color: Color.fromRGBO(254, 209, 127, 1),),
                                  ],
                                ))
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_right_rounded , color: Colors.black , size: 20,),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                //specs
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, -3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      //tabs
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (){
                                context.read<AdDetailsProvider>().setIsSummary(true);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width /2,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text("Summary", style: TextStyle(color: Color.fromRGBO(133, 133, 133, 1)),)),
                            ),
                            GestureDetector(
                              onTap: (){
                                context.read<AdDetailsProvider>().setIsSummary(false);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width /2,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text("Specs" , style: TextStyle(color: Color.fromRGBO(133, 133, 133, 1)),)),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        margin: EdgeInsets.only(left: context.watch<AdDetailsProvider>().isSummary == false ? MediaQuery.of(context).size.width/2 : 0 , right: context.watch<AdDetailsProvider>().isSummary == true ? MediaQuery.of(context).size.width/2 : 0),
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          width: MediaQuery.of(context).size.width /2,
                          height: 1,
                          color: const Color.fromRGBO(245, 135, 41, 1),
                        ),
                      ),

                      Selector<AdDetailsProvider , bool>(
                        selector: (context , prov) => prov.isSummary,
                        builder: (context , isSummary ,_){

                          return isSummary ?

                              //summary
                          Consumer<AdDetailsProvider >(
                            // selector: (context, prov) => prov.maxLine,
                            builder: (context, prov, _) {
                              final numLines = '\n'.allMatches(widget.adDetailsModel.description ?? "").length + 1;
                              return Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: prov.readMore ? numLines * 20  : 70,
                                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Text(widget.adDetailsModel.description  ?? "")
                                  ),
                                  Visibility(
                                    visible: numLines > 4,
                                    child: GestureDetector(
                                      onTap: (){
                                        prov.toggleReadMore();
                                      },
                                      child: const Text("Read More", style: TextStyle(fontSize: 16 , color: Colors.indigoAccent),),
                                    ),
                                  ),
                                ],
                              );
                            }
                          ):

                              //specs
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              itemCount: widget.adDetailsModel.metafields?.length ?? 0,
                            itemBuilder: (context , index){
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  width: double.infinity,
                                  height: 70,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.adDetailsModel.metafields?[index]['name'], style: const TextStyle(fontSize: 16, color: Colors.grey),),
                                      Text(widget.adDetailsModel.metafields?[index]['value'], style: const TextStyle(fontSize: 16, color: Colors.black),),
                                    ],
                                  ),
                                );
                            },
                            separatorBuilder: (context , index) => const Divider(height: 0,indent: 12,endIndent: 12,thickness: 0.3,),
                          );
                        },
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //share this listening
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: double.infinity,
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, -3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Share This Listeing" , style: TextStyle(fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: (){
                          //TODO share to facebook story
                        },
                        child: Image.asset("assets/icons/post_details_icons/facebook.png" , width: 35,),
                      ),
                      GestureDetector(
                        onTap: () async {
                          //TODO share to Messenger

                        },
                        child: Image.asset("assets/icons/post_details_icons/messenger.png" , width: 35,),
                      ),
                      GestureDetector(
                        onTap: (){
                          // SocialShare.shareWhatsapp(widget.adDetailsModel.longLink??"");
                        },
                        child: Image.asset("assets/icons/post_details_icons/whatsapp.png" , width: 35,),
                      ),

                      GestureDetector(
                        onTap: () async {
                          // SocialShare.shareOptions(widget.adDetailsModel.longLink??"");
                        },
                        child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.share, size: 25,color: Colors.white,)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                  width: double.infinity,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, -3),
                        blurRadius: 3,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.watch_later_rounded , color: Color(0xFF58595b),),
                          const SizedBox(width:  6),
                          Text("Today at ${DateTime.now().hour}:${DateTime.now().minute}" , style: TextStyle(fontSize: 13,color: Colors.grey.withOpacity(0.8)),),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("0 Visits | ID :0" , style: TextStyle(color: Colors.grey.withOpacity(0.8)),),
                          GestureDetector(
                              onTap: (){

                              },
                              child: const Text("REPORT AD" , style: TextStyle(fontSize: 16 , color: Colors.red , fontWeight: FontWeight.w300),))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ImageHolder extends StatelessWidget {
  const ImageHolder({super.key, required this.onTap, required this.imagePath});
  final Function() onTap;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 305 + kToolbarHeight,
        width: double.infinity,
        child: Hero(
          tag: imagePath,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

