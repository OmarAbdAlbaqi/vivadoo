import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../main.dart';
import '../../providers/ads_provider/ads_provider.dart';
import '../../providers/ads_provider/filtered_ads_provideer.dart';
import '../../providers/general/home_page_provider.dart';
import '../../widgets/home_screen_widgets/home_page_widgets/home_page_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshController refreshControllerHome = RefreshController(initialRefresh: false);

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    _scrollController.addListener(listeners);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500) , afterPageBuild);
    });
    super.initState();
  }
  void afterPageBuild() {
    context.read<HomePageProvider>().setFirstAnimate(false);
  }
  listeners(){
    context.read<HomePageProvider>().setOffset(_scrollController.offset);
    var direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse){
      context.read<HomePageProvider>().setIsScrollingUp(true);
    }else if (direction == ScrollDirection.forward){
      context.read<HomePageProvider>().setIsScrollingUp(false);
    }
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if(context.read<HomePageProvider>().homeType == HomeType.home){
        context.read<AdsProvider>().setLoading(true);
        String page = context.read<AdsProvider>().page;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        context.read<AdsProvider>().setPage((int.parse(page) + 1).toString());
        context.read<AdsProvider>().getAds(context).then((_) => context.read<AdsProvider>().setLoading(false));
      }else if (context.read<HomePageProvider>().homeType == HomeType.filteredHome){
        context.read<FilteredAdsProvider>().setLoading(true);
        String page = context.read<FilteredAdsProvider>().page;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        context.read<FilteredAdsProvider>().setPage((int.parse(page) + 1).toString());
        context.read<FilteredAdsProvider>().getTheNextPageOfFilteredAds(context).then((_) => context.read<FilteredAdsProvider>().setLoading(false));
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    double width =  MediaQuery.of(context).size.width;
    return Selector<HomePageProvider , HomeType>(
      selector: (context , prov) => prov.homeType,
      builder: (context , homeType , _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 246, 247),
          floatingActionButton: Visibility(
            visible: context
                .watch<HomePageProvider>()
                .homeType == HomeType.home,
            maintainAnimation: true,
            maintainState: true,
            child: Selector<HomePageProvider, double>(
                selector: (context, prov) => prov.offset,
                builder: (context, offset, _) {
                  return GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      margin: EdgeInsets.only(
                          right: offset >= 150 ? 0 : (width - 150) / 2),
                      duration: const Duration(milliseconds: 300),
                      width: offset >= 150 ? 50 : 130,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.orange,
                      ),
                      child: offset >= 150 ? const Hero(
                          tag: "floatingCamera",
                          child: Icon(Icons.camera_alt, color: Colors.white,
                            size: 40,)) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Hero(
                              tag: "floatingCamera",
                              child: Icon(Icons.camera_alt, color: Colors.white,
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
          ),

          body: HomePageWidget(width: width,  scrollController: _scrollController,  refreshController: refreshControllerHome),

          // Selector<HomePageProvider , ScrollPhysics>(
          //   selector: (context , prov) => prov.physics,
          //   builder: (context , physics , _) {
          //     return TabBarView(
          //       physics: physics,
          //       controller: tabController,
          //       children: [
          //         homePageWidget(context, width, isFirstAnimate, _scrollController , tabController , refreshControllerHome),
          //         filteredHomePage(context , tabController , _scrollController , refreshControllerFiltered),
          //         filterWidget(context ,_scrollController, tabController),
          //         locationFilterWidget(context , tabController),
          //         subLocationWidget(context , tabController),
          //       ],
          //     );
          //   }
          // ),

          //   AnimatedSwitcher(
          //       duration: const Duration(milliseconds: 300),
          //       transitionBuilder: (Widget child, Animation<double> animation){
          //         final Offset initialOffset = homeType == HomeType.home ? const Offset(-1.0, 0.0) : const Offset(-1.0, 0.0);
          //         final Offset finalOffset = homeType == HomeType.home ? const Offset(0.0, 0.0) : const Offset(0.0, 0.0);
          //         final tween = Tween(begin: initialOffset, end: finalOffset);
          //         return SlideTransition(
          //             transformHitTests: false,
          //           position: animation.drive(tween),
          //           child: child,
          //         );
          //       },
          //       child:
          //
          //   // ),
          // );
          // },
        );
      }
        );
  }

}
