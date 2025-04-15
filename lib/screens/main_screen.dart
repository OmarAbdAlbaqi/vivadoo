import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_model.dart';
import 'package:vivadoo/providers/post_new_ad_provider/steps_bar_widget_provider.dart';
import 'package:vivadoo/providers/home_providers/home_page_provider.dart';
import 'package:vivadoo/providers/general/nav_bar_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';
import 'package:vivadoo/utils/chat_service.dart';
import 'package:vivadoo/utils/hive_manager.dart';


import '../models/auth/user_info_model.dart';
import '../providers/favorite_providers/favorite_provider.dart';
import '../providers/general/navigation_shell_provider.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  double containerHeight = 100;


@override
  void initState() {
    if(HiveStorageManager.hiveBox.get('adInProgress') == true && HiveStorageManager.hiveBox.get('adInProgress') != null){
      context.read<PostNewAdProvider>().adInProgress = true;
      print(context.read<PostNewAdProvider>().getAd().toString());
    }else{
      context.read<PostNewAdProvider>().adInProgress = false;
    }
    if(HiveStorageManager.signedInNotifier.value){
      final userInfoBox = HiveStorageManager.getUserInfoModel();
      String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
      ChatService.updateDialogsInFirestore(userId);
    }

  pageController = PageController(initialPage: 0);
  Future.delayed(const Duration(milliseconds: 500)).then((value) => setState(() {
    containerHeight = 60;
  }));
  pageController.addListener(() {
    context.read<HomePageProvider>().onPageChanged(pageController.page ?? 0);
  });
    super.initState();
  }



@override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<NavBarProvider>().setNavBarData(context);
      List<AdModel> ads = HiveStorageManager.getFavoriteAds().values.toList().cast<AdModel>();
      context.read<FavoriteProvider>().setFavoriteAds(ads);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: widget.navigationShell,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: HiveStorageManager.hiveBox.listenable(),
        builder: (context, hiveBox, widget) {
          bool visible = [
            "Home",
            "MyVivadoo",
            "PostNewAd",
            "Saved",
            "Messages",
            "Category And Location",
            "NewAdDetails",
            "PosterInformation",
            "MyVivadooProfile"
            "Chat Screen"
          ].contains(hiveBox.get('route'));

          return SafeArea(
            bottom: visible,
            top: false,
            right: false,
            left: false,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: visible ? containerHeight : 0, // Ensures the bar doesn't collapse
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    bottom: visible ? 0 : -containerHeight, // Slide down effect
                    left: 0,
                    right: 0,
                    child: Consumer<NavBarProvider>(
                      builder: (context, prov, _) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 800),
                          opacity: visible ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 6),
                            height: containerHeight,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return NavBarItem (
                                  onTap: () {
                                    NavigationManager().goBranch(index);
                                    switch (index) {
                                      case 0:
                                        context.read<HomePageProvider>().onNavigateToHomePage(context);
                                        break;
                                      case 1:
                                        HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
                                        break;
                                      case 2:
                                        context.read<StepsBarWidgetProvider>().setCurrentPostNewAdPage(context);
                                        break;
                                      case 3:
                                        context.read<FavoriteProvider>().onNavigateToFavoritePage(context);
                                        break;
                                      case 4:
                                        HiveStorageManager.hiveBox.put('route', 'Messages');
                                        break;
                                    }
                                    prov.setCurrentPage(index);
                                  },
                                  title: prov.navBarItems[index]['title'] ?? "",
                                  imageUrl: prov.navBarItems[index]['imageUrl'] ?? "",
                                  selected: prov.currentPage == index,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}


class NavBarItem extends StatefulWidget {
  const NavBarItem({super.key, required this.onTap, required this.title, required this.imageUrl, required this.selected});
  final Function onTap;
  final String title;
  final String imageUrl;
  final bool selected;


  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

     _animation = Tween<double>(begin: -0.5 , end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  bool test = true;
  @override
  Widget build(BuildContext context) {
    if(test){
      _controller.reverse();
      test = false;
    }else{
      widget.selected ? _controller.reverse():_controller.forward();
    }
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      child: AnimatedBuilder(
          animation:  _controller ,
          builder: (context , child){
            return Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width / 5,
              // height: 40,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment(0.0 , _animation.value ),
                    child: SizedBox(
                      height: 30,
                      child: Image.asset(widget.imageUrl, color: widget.selected ? Colors.red : Colors.orange,),
                    ),
                  ),
                  Visibility(
                    visible: widget.selected,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 18,
                        child: Text(widget.title ,textAlign: TextAlign.center, style: TextStyle(fontSize: 11 ,  color: widget.selected ? Colors.red : Colors.orange,),),
                      ),
                    ),)
                ],
              ),
            );
          }
      ),
    );
  }
}
