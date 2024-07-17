import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/providers/custom_widget_provider/steps_bar_widget_provider.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/providers/general/nav_bar_provider.dart';
import 'package:vivadoo/screens/nav_bar_pages/home_page.dart';
import 'package:vivadoo/screens/nav_bar_pages/messages.dart';
import 'package:vivadoo/screens/nav_bar_pages/my_vivadoo.dart';
import 'package:vivadoo/screens/nav_bar_pages/post_new_ad.dart';
import 'package:vivadoo/screens/nav_bar_pages/saved.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../app_navigation.dart';
import '../providers/navigation_shell_provider.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  List<Map<String , String>> navBarItems = [
    {
      "title" : "Home",
      "imageUrl" : "assets/icons/nav_bar_icons/home.png",
    },
    {
      "title" : "My Vivadoo",
      "imageUrl" : "assets/icons/nav_bar_icons/user.png",
    },
    {
      "title" : "Post",
      "imageUrl" : "assets/icons/nav_bar_icons/camera.png",
    },
    {
      "title" : "Saved",
      "imageUrl" : "assets/icons/nav_bar_icons/heart.png",
    },
    {
      "title" : "Messages",
      "imageUrl" : "assets/icons/nav_bar_icons/dialog.png",
    },
  ];
  double containerHeight = 100;



  void _goToBranch (int index){
    widget.navigationShell.goBranch(index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );



    switch(index){
      case 0 : HiveStorageManager.hiveBox.put('route', 'Home');
      case 1 : HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
      case 2 : HiveStorageManager.hiveBox.put('route', 'PostNewAd');
      case 3 : HiveStorageManager.hiveBox.put('route', 'Saved');
      case 4 : HiveStorageManager.hiveBox.put('route', 'Messages');
    }
    context.read<NavBarProvider>().setCurrentPage(index);

    // pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

@override
  void initState() {
  pageController = PageController(initialPage: 0);
  Future.delayed(const Duration(milliseconds: 800)).then((value) => setState(() {
    containerHeight = 75;
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
    return Scaffold(

      body:
      // PageView(
      //   controller: pageController,
      //   onPageChanged: (index) {
      //     context.read<NavBarProvider>().setCurrentPage(index);
      //   },
      //   children: screens,
      // ),
      SizedBox.expand(
        child: widget.navigationShell
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: HiveStorageManager.hiveBox.listenable(),
        builder: (context, hiveBox, widget) {
          return Visibility(
            visible: hiveBox.get('route') == "Home" || hiveBox.get('route') == "MyVivadoo" || hiveBox.get('route') == "PostNewAd" || hiveBox.get('route') == "Saved" || hiveBox.get('route') == "Messages" || hiveBox.get('route') == "Category And Location"  || hiveBox.get('route') == "NewAdDetails"  || hiveBox.get('route') == "PosterInformation" || hiveBox.get('route') == "MyVivadooProfile",
            child: Selector<NavBarProvider , int>(
              selector: (context , prov) => prov.currentPage,
              builder: (context , currentPage , _) {
                return AnimatedContainer(
                  padding: const EdgeInsets.only(bottom: 20),
                  duration: const Duration(milliseconds: 500),
                  height: containerHeight,
                  child:
                  Selector<NavBarProvider , int>(
                    selector: (context , prov)=> prov.currentPage,
                    builder: (context , currentPage , _) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context , index){
                            return NavBarItem(index: index , onTap: (){
                              NavigationManager().goBranch(index);
                              switch(index){
                                case 0 : HiveStorageManager.hiveBox.put('route', 'Home');
                                break;
                                case 1 : HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
                                break;
                                case 2 : context.read<StepsBarWidgetProvider>().setCurrentPostNewAdPage(context);
                                break;
                                case 3 : HiveStorageManager.hiveBox.put('route', 'Saved');
                                break;
                                case 4 : HiveStorageManager.hiveBox.put('route', 'Messages');
                                break;
                              }
                              context.read<NavBarProvider>().setCurrentPage(index);
                            },
                            title: navBarItems[index]['title'] ?? "",
                              imageUrl: navBarItems[index]['imageUrl'] ?? "",
                            );
                          });
                    }
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }
}


class NavBarItem extends StatefulWidget {
  const NavBarItem({super.key, required this.index, required this.onTap, required this.title, required this.imageUrl});
  final int index;
  final Function onTap;
  final String title;
  final String imageUrl;


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
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: -2.6 , end: widget.index == 0 ? -0.3 : 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
          _controller.forward();
          Future.delayed(const Duration(milliseconds: 500)).then((value) => context.read<NavBarProvider>().setFirstRun());

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bool firstRun = context.watch<NavBarProvider>().firstRun;
    final int currentPage = context.watch<NavBarProvider>().currentPage;
    final animation2 = Tween<double>(begin: -0.4, end:  0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
   if(!firstRun){
     currentPage == widget.index ? _controller.reverse():_controller.forward();
   }
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context , child){
            return Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width / 5,
              height: 52,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment(0.0 , firstRun? _animation.value: animation2.value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Image.asset(widget.imageUrl, color: widget.index == currentPage ? Colors.red : Colors.orange,),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.index == currentPage,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 18,
                        child: Text(widget.title , style: TextStyle(fontSize: 12 ,  color: widget.index == currentPage ? Colors.red : Colors.orange,),),
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
