import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import '../../providers/home_providers/filters/filter_provider.dart';
import '../../providers/home_providers/filters/location_filter.dart';
import '../../providers/my_vivadoo_providers/auth/user_info_provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? firstVisit;
  bool? signedInWithGoogle;
  bool? signedInWithFacebook;
  bool? signedInNormally;
  bool? signedInWithApple;

  Future<void> getPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    firstVisit = pref.getBool('firstVisit') ?? true;
  }

  @override
  void initState() {
    getPrefs();
    context.read<UserInfoProvider>().getUserInfo();
    context.read<FilteredAdsProvider>().getCategories();
    context.read<LocationFilterProvider>().getAreaList();
    context.read<AdsProvider>().getAds(context).then((_) => getPage());
    context.read<FilteredAdsProvider>().getMetaFields();
    context.read<FilterProvider>().showAdsCount(context);
    super.initState();
  }

  getPage(){
    context.go('/home');
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset("assets/images/vivadoo.png"),
        ),
      ),
    );
  }
}
