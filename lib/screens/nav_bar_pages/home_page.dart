import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/app_navigation.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../providers/general/home_page_provider.dart';
import '../../providers/general/nav_bar_provider.dart';
import '../../providers/navigation_shell_provider.dart';
import '../../widgets/home_screen_widgets/home_page_widgets/home_page_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // HiveStorageManager.hiveBox.put('route', 'Home');
      Future.delayed(const Duration(milliseconds: 1500) , context.read<HomePageProvider>().setFirstAnimate(false));
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Selector<HomePageProvider, double>(
          selector: (context, prov) => prov.offset,
          builder: (context, offset, _) {
            return GestureDetector(
              onTap: offset >= 1600 ? (){
                context.read<HomePageProvider>().scrollController.animateTo(
                  duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    context.read<HomePageProvider>().scrollController.position.minScrollExtent);
              }:() {
                NavigationManager().goBranch(2);
                context.read<NavBarProvider>().setCurrentPage(2);
                String page = HiveStorageManager.hiveBox.get('PostNewAdSavedPage') ?? "PostNewAd";
                HiveStorageManager.hiveBox.put('route', page);
              },
              child: AnimatedContainer(
                margin: EdgeInsets.only(
                    right: offset >= 150 ? 0 : (Constants.width(context) - 150) / 2),
                duration: const Duration(milliseconds: 300),
                width: offset >= 150 ? 50 : 130,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.orange,
                ),
                child: offset >= 150 ?  Hero(
                    tag: "floatingCamera",
                    child: Icon(offset >= 1600 ? Icons.keyboard_double_arrow_up_rounded:Icons.camera_alt, color: Colors.white,
                      size: 40,)) :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Hero(
                        tag: "floatingCamera",
                        child: Icon( Icons.camera_alt, color: Colors.white,
                          size: 30,)),
                    AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: offset >= 150 ? 0 : 1,
                        child: const Text("Post my Ad", style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),))
                  ],
                ),
              ),
            );
          }
      ),
      body: const HomePageWidget(),
    );
  }
}
