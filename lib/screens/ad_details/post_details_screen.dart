import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';
import 'package:vivadoo/models/user_pro_model.dart';
import 'package:vivadoo/screens/ad_details/favorite_widget.dart';
import 'package:vivadoo/screens/ad_details/share_button.dart';
import 'package:vivadoo/utils/api_manager.dart';
import 'package:vivadoo/utils/pop-ups/general_functions.dart';
import '../../models/ad_details_model.dart';
import '../../models/auth/user_info_model.dart';
import '../../providers/ads_provider/ad_details_provider.dart';


import '../../constants.dart';
import '../../utils/hive_manager.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen(
      {super.key, required this.isFavorite, required this.index,});

  final bool isFavorite;
  final int index;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;

  final Dio dio = Dio();

  _saveNetworkImage(String url, String fileName) async {
    // var response = await Dio().get(
    //     url,
    //     options: Options(responseType: ResponseType.bytes));
    // final result = await ImageGallerySaver.saveImage(
    //     Uint8List.fromList(response.data),
    //     quality: 100,
    //     name: fileName);
    print("_saveNetworkImage");
  }


  void _scrollListener() {
    double offset = scrollController.offset;
    double opacity =
    (offset / 200).clamp(0, 1);
    context.read<AdDetailsProvider>().setTitleOpacity(opacity);
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      context.read<AdDetailsProvider>().setIsScrollingUp(true);
    } else {
      context.read<AdDetailsProvider>().setIsScrollingUp(false);
    }
  }

  late final bool userIsPro;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabController.index == 0 ? context.read<AdDetailsProvider>().setIsSummary(
          true) : context.read<AdDetailsProvider>().setIsSummary(false);
    });
    scrollController.addListener(_scrollListener);
    userIsPro = context
        .read<AdDetailsProvider>()
        .listOfAdDetails[widget.index].userIsPro == 1;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String convertHtml(String htmlString) {
    String withNewLines = htmlString.replaceAll(
        RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    String withoutHtmlTags = withNewLines.replaceAll(RegExp(r'<[^>]*>'), '');

    List<String> lines = withoutHtmlTags.split('\n');
    context
        .read<AdDetailsProvider>()
        .maxLine = lines.length;

    return withoutHtmlTags;
  }

  /// Function to calculate text height dynamically
  double _calculateTextHeight(BuildContext context, String text, int maxLines) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16,
            height: 1.5), // Make sure this matches your Text widget style
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: MediaQuery
          .of(context)
          .size
          .width - 20);

    return textPainter.height;
  }


  bool isFavorite = false;

  final Decoration decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: const Color(0xffffffff),
    boxShadow: const [
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
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, innerBoxIsScrolled) {
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
                    preferredSize: Size(0, 0),
                    child: Divider(
                      height: 0,
                      thickness: 0.5,
                    ),
                  ),
                  title: Selector<AdDetailsProvider, Tuple2<double, String>>(
                      selector: (_, prov) => Tuple2(prov.titleOpacity,
                          prov.listOfAdDetails[widget.index].title ?? ""),
                      builder: (_, data, child) {
                        return Text(data.item2, maxLines: 1,
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.lerp(
                                  Colors.transparent, Colors.black, data.item1),
                              overflow: TextOverflow.ellipsis),);
                      }
                  ),
                  leading: Selector<AdDetailsProvider, double>(
                      selector: (_, prov) => prov.titleOpacity,
                      builder: (_, titleOpacity, child) {
                        return GestureDetector(
                          onTap: () => context.pop(),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined, color: Color
                              .lerp(
                              Colors.white, Colors.black, titleOpacity),),
                        );
                      }
                  ),
                  actions: [
                    FavoriteWidget(isFav: isFavorite),
                    const SizedBox(width: 12),
                    shareButton(),
                    const SizedBox(width: 12),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: Stack(
                      children: [
                        Selector<AdDetailsProvider, List<Map<String, dynamic>>>(
                            selector: (_, prov) =>
                            prov.listOfAdDetails[widget.index].images,
                            builder: (_, images, child) {
                              return PageView.builder(
                                  onPageChanged: (value) {
                                    Provider.of<AdDetailsProvider>(
                                        context, listen: false).setImageIndex(
                                        value);
                                    // prov.setImageIndex(value);
                                  },
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return ImageHolder(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                              useRootNavigator: false,
                                              context: context,
                                              builder: (_) {
                                                return Material(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height * 0.9,
                                                    color: Colors.black,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 100,
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  context.pop();
                                                                },
                                                                child: Container(
                                                                  height: 60,
                                                                  width: 70,
                                                                  color: Colors
                                                                      .transparent,
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left: 12),
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  child: const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,),
                                                                ),
                                                              ),
                                                              DropdownButtonHideUnderline(
                                                                child: DropdownButton2<
                                                                    String>(
                                                                  isExpanded: true,
                                                                  alignment: Alignment
                                                                      .center,
                                                                  hint: const Text(
                                                                    "Save",
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight
                                                                            .w900,
                                                                        color: Colors
                                                                            .white),),
                                                                  items: [
                                                                    DropdownMenuItem(

                                                                      value: "photo",
                                                                      child: Container(
                                                                          alignment: Alignment
                                                                              .center,
                                                                          height: 30,
                                                                          child: const Text(
                                                                            "Photo",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight: FontWeight
                                                                                    .w500),)),
                                                                    ),

                                                                    DropdownMenuItem(
                                                                      value: "all photos",
                                                                      child: Container(
                                                                          alignment: Alignment
                                                                              .center,
                                                                          height: 30,
                                                                          child: const Text(
                                                                            "All Photos",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight: FontWeight
                                                                                    .w500),)),
                                                                    ),
                                                                  ],
                                                                  onChanged: (
                                                                      String? value) {
                                                                    String title = context
                                                                        .read<
                                                                        AdDetailsProvider>()
                                                                        .listOfAdDetails[widget
                                                                        .index]
                                                                        .title ??
                                                                        "";
                                                                    if (value ==
                                                                        "photo") {
                                                                      _saveNetworkImage(
                                                                          images[index]['original'],
                                                                          title)
                                                                          .then((
                                                                          value) {
                                                                        Get
                                                                            .rawSnackbar(
                                                                          message: "Image saved to your gallery!",
                                                                        );
                                                                      });
                                                                    }
                                                                    else
                                                                    if (value ==
                                                                        "all photos") {
                                                                      for (int i = 0; i <
                                                                          images
                                                                              .length; i++) {
                                                                        _saveNetworkImage(
                                                                            images[i]['original'],
                                                                            "$title$i")
                                                                            .then((
                                                                            value) {
                                                                          ScaffoldMessenger
                                                                              .of(
                                                                              context)
                                                                              .showSnackBar(
                                                                              const SnackBar(
                                                                                  content: Text(
                                                                                      "Image saved to your gallery!")));
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  buttonStyleData: const ButtonStyleData(
                                                                    width: 120,
                                                                    height: 60,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .only(
                                                                        bottomRight: Radius
                                                                            .circular(
                                                                            8),
                                                                        bottomLeft: Radius
                                                                            .circular(
                                                                            8),
                                                                      ),
                                                                      color: Constants
                                                                          .orange,
                                                                    ),
                                                                  ),
                                                                  iconStyleData: const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .transparent,
                                                                      size: 0,
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData: DropdownStyleData(
                                                                    padding: EdgeInsets
                                                                        .zero,
                                                                    maxHeight: 100,
                                                                    width: 130,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          6),
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          66,
                                                                          69,
                                                                          72,
                                                                          1),
                                                                    ),
                                                                    offset: const Offset(
                                                                        -6, -6),
                                                                  ),
                                                                  menuItemStyleData: const MenuItemStyleData(
                                                                      padding: EdgeInsets
                                                                          .zero
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 70,
                                                                height: 60,
                                                                alignment: Alignment
                                                                    .center,
                                                                child: Selector<
                                                                    AdDetailsProvider,
                                                                    Tuple2<List<
                                                                        Map<
                                                                            String,
                                                                            dynamic>>,
                                                                        int>>(
                                                                    selector: (
                                                                        _,
                                                                        prov) =>
                                                                        Tuple2(
                                                                            prov
                                                                                .listOfAdDetails[widget
                                                                                .index]
                                                                                .images,
                                                                            prov
                                                                                .originalImageIndex),
                                                                    builder: (_,
                                                                        data,
                                                                        child) {
                                                                      return Text(
                                                                        "${data
                                                                            .item2
                                                                            .toString()}/${data
                                                                            .item1
                                                                            .length}",
                                                                        style: const TextStyle(
                                                                            fontSize: 13,
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight: FontWeight
                                                                                .w700),);
                                                                    }
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Selector<
                                                              AdDetailsProvider,
                                                              List<Map<
                                                                  String,
                                                                  dynamic>>>(
                                                              selector: (_,
                                                                  prov) =>
                                                              prov
                                                                  .listOfAdDetails[widget
                                                                  .index]
                                                                  .images,
                                                              builder: (_,
                                                                  images,
                                                                  child) {
                                                                return PageView
                                                                    .builder(
                                                                    controller: PageController(
                                                                        initialPage: context
                                                                            .read<
                                                                            AdDetailsProvider>()
                                                                            .imageIndex -
                                                                            1),
                                                                    onPageChanged: (
                                                                        value) {
                                                                      context
                                                                          .read<
                                                                          AdDetailsProvider>()
                                                                          .setOriginalImageIndex(
                                                                          value);
                                                                    },
                                                                    itemCount: images
                                                                        .length,
                                                                    itemBuilder: (
                                                                        context,
                                                                        index) {
                                                                      return List
                                                                          .generate(
                                                                          images
                                                                              .length ??
                                                                              0, (
                                                                          index) =>
                                                                          Dismissible(
                                                                              onDismissed: (
                                                                                  value) {
                                                                                Navigator
                                                                                    .pop(
                                                                                    context);
                                                                              },
                                                                              behavior: HitTestBehavior
                                                                                  .translucent,
                                                                              direction: DismissDirection
                                                                                  .down,
                                                                              key: UniqueKey(),
                                                                              child: InteractiveViewer(
                                                                                panEnabled: true,
                                                                                boundaryMargin: const EdgeInsets
                                                                                    .all(
                                                                                    100),
                                                                                minScale: 0.5,
                                                                                maxScale: 5,
                                                                                child: PhotoView
                                                                                    .customChild(
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: images[index]['original'],
                                                                                    fit: BoxFit
                                                                                        .contain,
                                                                                    placeholder: (
                                                                                        context,
                                                                                        _) {
                                                                                      return Shimmer
                                                                                          .fromColors(
                                                                                        baseColor: Colors
                                                                                            .grey
                                                                                            .withOpacity(
                                                                                            0.6),
                                                                                        highlightColor: Colors
                                                                                            .white
                                                                                            .withOpacity(
                                                                                            0.6),
                                                                                        child: Container(
                                                                                          width: double
                                                                                              .infinity,
                                                                                          height: double
                                                                                              .infinity,
                                                                                          color: Colors
                                                                                              .white,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),

                                                                              )
                                                                          ))[index];
                                                                    });
                                                              }
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        imageUrl: images[index]['main'],
                                        adId: images[index]['original']);
                                  });
                            }
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            width: double.infinity,
                            height: 24,
                            color: Colors.black.withOpacity(0.3),
                            alignment: Alignment.centerLeft,
                            child: Selector<AdDetailsProvider,
                                Tuple2<List<Map<String, dynamic>>, String>>(
                                selector: (_, prov) => Tuple2(
                                    prov.listOfAdDetails[widget.index].images,
                                    prov.imageIndex.toString()),
                                builder: (context, data, _) {
                                  return Text(
                                    "${data.item2}/${data.item1.length}",
                                    style: const TextStyle(fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),);
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
              padding: const EdgeInsets.all(10),
              children: [

                //title price address
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.all(8),
                  decoration: decoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Selector<AdDetailsProvider, String?>(
                          selector: (_, prov) =>
                          prov.listOfAdDetails[widget.index].title,
                          builder: (_, title, child) {
                            if (title == null || title.isEmpty) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.3),
                                  highlightColor: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 22,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            bottom: 8, right: 60),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                30)
                                        ),
                                      ),
                                      Container(
                                        height: 22,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            bottom: 8, right: 160),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                30)
                                        ),
                                      ),
                                    ],
                                  )
                              );
                            }
                            return Container(
                                alignment: const Alignment(-1, 0),
                                height: 60,
                                child: Text(
                                  widget.adDetailsModel.title ?? "null",
                                  style: const TextStyle(fontSize: 18,
                                      color: Color(0xff000000)),));
                          }
                      ),
                      const SizedBox(height: 15),
                      Text(widget.adDetailsModel.priceFormatted ?? "null",
                        style: const TextStyle(fontSize: 18,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700),),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/location_pin.png",
                            color: Constants.orange, height: 16,),
                          const SizedBox(width: 4,),
                          Text(widget.adDetailsModel.location ?? "",
                            style: const TextStyle(color: Color.fromRGBO(
                                245, 102, 1, 1), fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //user card
                GestureDetector(
                  onTap: () {
                    if (userIsPro) {
                      UserProModel userProModel = context
                          .read<AdDetailsProvider>()
                          .listOfAdDetails[widget.index].userProModel!;
                      context.push('/homePageAdDetails/adDetailsUserPage',
                          extra: userProModel);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    height: 90,
                    decoration: decoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 245, 246, 247)
                          ),
                          child: Image.asset(
                            "assets/icons/default_profile.png", fit: BoxFit
                              .cover,),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Selector<AdDetailsProvider, String?>(
                                selector: (_, prov) =>
                                prov.listOfAdDetails[widget.index].postBy,
                                builder: (_, postBy, child) {
                                  return Visibility(
                                    visible: postBy != null,
                                    replacement: Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.3),
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.5,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: Colors.white,
                                          ),
                                        )),
                                    child: Text(postBy ?? "",
                                      style: const TextStyle(
                                          color: Color(0xff000000)),),
                                  );
                                }
                            ),
                            const SizedBox(height: 6),
                            Selector<AdDetailsModel, String?>(
                                selector: (_, prov) => prov.since,
                                builder: (_, since, child) {
                                  return Visibility(
                                      visible: since != null,
                                      replacement: Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.3),
                                        highlightColor: Colors.white,
                                        child: Shimmer.fromColors(
                                            baseColor: Colors.grey.withOpacity(
                                                0.3),
                                            highlightColor: Colors.white,
                                            child: Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.5,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      child: Text(since ?? "", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.withOpacity(0.7)),)
                                  );
                                }
                            ),
                            Visibility(
                                visible: adDetailsModel.userIsPro == 1
                                    ? true
                                    : false,
                                child: const Row(
                                  children: [
                                    Icon(Icons.star,
                                      color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star,
                                      color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star,
                                      color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star,
                                      color: Color.fromRGBO(254, 209, 127, 1),),
                                    Icon(Icons.star_half,
                                      color: Color.fromRGBO(254, 209, 127, 1),),
                                  ],
                                ))
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_right_rounded,
                          color: Colors.black, size: 30,),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                //specs
                Container(
                  decoration: decoration,
                  child: Column(
                    children: [

                      //tabs
                      SizedBox(
                        height: 40,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<AdDetailsProvider>().setIsSummary(
                                    true);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2) - 16,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text("Summary", style: TextStyle(
                                      color: Color.fromRGBO(
                                          133, 133, 133, 1)),)),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<AdDetailsProvider>().setIsSummary(
                                    false);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text("Specs", style: TextStyle(
                                      color: Color.fromRGBO(
                                          133, 133, 133, 1)),)),
                            ),
                          ],
                        ),
                      ),

                      Selector<AdDetailsProvider, bool>(
                          selector: (_, prov) => prov.isSummary,
                          builder: (_, isSummary, child) {
                            return AnimatedContainer(
                              margin: EdgeInsets.only(
                                  left: !isSummary ? MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2 : 0,
                                  right: isSummary ? MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2 : 0),
                              duration: const Duration(milliseconds: 250),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                                height: 1,
                                color: const Color.fromRGBO(245, 135, 41, 1),
                              ),
                            );
                          }
                      ),

                      Selector<AdDetailsProvider, bool>(
                        selector: (context, prov) => prov.isSummary,
                        builder: (context, isSummary, _) {
                          return isSummary ?

                          //summary
                          Selector<
                              AdDetailsProvider,
                              Tuple3<String, int, bool>>(
                            selector: (_, prov) => Tuple3(
                                prov.listOfAdDetails[widget.index]
                                    .description ?? "", prov.maxLine,
                                prov.readMore),
                            builder: (context, data, _) {
                              print("show me how many build ");
                              bool isExpandable = data.item2 > 4;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.fromLTRB(
                                        8, 8, 8, 0),
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    height: data.item3
                                        ? _calculateTextHeight(
                                        context, convertHtml(data.item1),
                                        data.item2)
                                        : _calculateTextHeight(
                                        context, convertHtml(data.item1), 4),
                                    child: SingleChildScrollView( // Wrap text with scroll view to prevent overflow
                                      physics: const NeverScrollableScrollPhysics(),
                                      child: Text(
                                        convertHtml(data.item1),
                                        maxLines: data.item3 ? data.item2 : 4,
                                        overflow: data.item3 ? TextOverflow
                                            .visible : TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16, height: 1.5),
                                      ),
                                    ),
                                  ),
                                  if (isExpandable)
                                    GestureDetector(
                                      onTap: context
                                          .read<AdDetailsProvider>()
                                          .toggleReadMore,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8,
                                            top: prov.readMore ? 16 : 0),
                                        child: Text(
                                          data.item3
                                              ? "Read Less"
                                              : "Read More",
                                          style: const TextStyle(fontSize: 16,
                                              color: Colors.indigoAccent),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          )
                              :

                          //specs
                          Selector<
                              AdDetailsProvider,
                              List<Map<String, dynamic>>>(
                              selector: (_, prov) =>
                              prov.listOfAdDetails[widget.index].metafields ??
                                  [],
                              builder: (_, metaFields, child) {
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: metaFields.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      width: double.infinity,
                                      height: 70,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(metaFields[index]['name'],
                                            style: const TextStyle(fontSize: 16,
                                                color: Colors.grey),),
                                          Text(metaFields[index]['value'],
                                            style: const TextStyle(fontSize: 16,
                                                color: Colors.black),),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                  const Divider(height: 0,
                                    indent: 12,
                                    endIndent: 12,
                                    thickness: 0.3,),
                                );
                              }
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
                  decoration: decoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Share This Listing",
                        style: TextStyle(fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: () {
                          // Share.shareUri(uri)
                          //TODO share to facebook story
                        },
                        child: Image.asset(
                          "assets/icons/post_details_icons/facebook.png",
                          width: 35,),
                      ),
                      GestureDetector(
                        onTap: () async {
                          //TODO share to Messenger

                        },
                        child: Image.asset(
                          "assets/icons/post_details_icons/messenger.png",
                          width: 35,),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("share link");
                          // SocialShare.shareWhatsapp(widget.adDetailsModel.longLink??"");
                        },
                        child: Image.asset(
                          "assets/icons/post_details_icons/whatsapp.png",
                          width: 35,),
                      ),

                      GestureDetector(
                        onTap: () async {
                          print("share link");
                          // SocialShare.shareOptions(widget.adDetailsModel.longLink??"");
                        },
                        child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.share, size: 25, color: Colors
                                .white,)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //date
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  width: double.infinity,
                  height: 88,
                  decoration: decoration,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.watch_later_rounded, color: Color(
                              0xFF58595b),),
                          const SizedBox(width: 6),
                          Selector<AdDetailsProvider, String>(
                              selector: (_, prov) =>
                              prov.listOfAdDetails[widget.index].date ?? "",
                              builder: (_, date, child) {
                                return Text(date, style: TextStyle(fontSize: 13,
                                    color: Colors.grey.withOpacity(0.8)),);
                              }
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Selector<AdDetailsProvider, Tuple2<String, String>>(
                              selector: (_, prov) =>
                                  Tuple2(prov.listOfAdDetails[widget.index]
                                      .postViews.toString(),
                                      prov.listOfAdDetails[widget.index].id
                                          .toString()),
                              builder: (_, data, child) {
                                return Text(
                                  "${data.item1} Visits | ID :${data.item2}",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.8)),);
                              }
                          ),
                          GestureDetector(
                              onTap: () {

                              },
                              child: const Text("REPORT AD", style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w300),))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Selector<AdDetailsProvider, bool>(
              selector: (_, prov) => prov.isScrollingUp,
              builder: (_, isScrollingUp, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: isScrollingUp ? 0 : -100,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 247, 248),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: SafeArea(
                      top: false,
                      bottom: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          if(context.read<AdDetailsProvider>().listOfAdDetails[widget.index].contactByPhone ?? false)
                            GestureDetector(
                              onTap: () {
                                String contactPhone = context
                                    .read<AdDetailsProvider>()
                                    .listOfAdDetails[widget.index]
                                    .contactPhone ?? "";
                                GeneralFunctions.contactByPhone(contactPhone);
                              },
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3.3,
                                height: 50,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.lightGreen,
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/icons/post_details_icons/phone-call.png",
                                  color: Colors.white,),
                              ),
                            ),

                          //contact by email
                          Selector<AdDetailsProvider, bool>(
                            selector: (_, prov) =>
                            prov.listOfAdDetails[widget.index].contactByMail ??
                                false,
                            builder: (_, contactByEmail, child) {
                              if (contactByEmail) {
                                return GestureDetector(
                                  onTap: () {
                                    GeneralFunctions.contactByEmail('');
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.3,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.lightBlueAccent,
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/icons/post_details_icons/email.png",
                                      color: Colors.white,),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),

                          //has chat
                          Selector<AdDetailsProvider, bool>(
                              selector: (_, prov) =>
                              prov.listOfAdDetails[widget.index].hasChat ??
                                  false,
                              builder: (_, hasChat, child) {
                                if (hasChat) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final userInfoBox = HiveStorageManager
                                          .getUserInfoModel();
                                      String userId = userInfoBox.values
                                          .toList().cast<UserInfoModel>()[0]
                                          .emailAddress;
                                      // ApiManager().startNewDialog(widget.adDetailsModel.id.toString(), "");
                                      // ChatService.addNewDialogWithMessage(userId, dialog, message)
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 3.3,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Constants.orange,
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/icons/post_details_icons/chat.png",
                                        color: Colors.white,),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              }
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}


class ImageHolder extends StatelessWidget {
  const ImageHolder(
      {super.key, required this.onTap, required this.imageUrl, required this.adId});

  final Function() onTap;
  final String imageUrl;
  final String adId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 305 + kToolbarHeight,
        width: double.infinity,
        child: Hero(
          tag: imageUrl,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, _) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.6),
                highlightColor: Colors.white.withOpacity(0.6),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

