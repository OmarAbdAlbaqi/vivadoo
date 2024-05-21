import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/providers/general/nav_bar_provider.dart';
import 'package:vivadoo/screens/nav_bar_pages/home_page.dart';
import 'package:vivadoo/screens/nav_bar_pages/messages.dart';
import 'package:vivadoo/screens/nav_bar_pages/my_vivadoo.dart';
import 'package:vivadoo/screens/nav_bar_pages/post_new_add.dart';
import 'package:vivadoo/screens/nav_bar_pages/saved.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
  List<Widget> screens = const [
    HomePage(),
    MyVivadoo(),
    PostNewAd(),
    Saved(),
    Messages(),
  ];
  double containerHeight = 100;
@override
  void initState() {
  pageController = PageController(initialPage: 0);
  Future.delayed(const Duration(milliseconds: 800)).then((value) => setState(() {
    containerHeight = 75;
  }));
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
      body: SizedBox.expand(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            context.read<NavBarProvider>().setCurrentPage(index);
          },
          children: screens,
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: context.watch<HomePageProvider>().homeType == HomeType.home,
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
                         context.read<NavBarProvider>().setCurrentPage(index);
                         pageController.jumpToPage(index);
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
