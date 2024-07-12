import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/providers/ads_provider/ads_provider.dart';
import 'package:vivadoo/providers/ads_provider/filtered_ads_provider.dart';
import 'package:vivadoo/providers/general/home_page_provider.dart';
import 'package:vivadoo/screens/main_screen.dart';

import '../../providers/filters/filter_provider.dart';
import '../../providers/filters/location_filter.dart';
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
    signedInWithGoogle = pref.getBool('signedIn') ?? false;
    signedInWithFacebook = pref.getBool('signedInWithFacebook') ?? false;
    signedInNormally = pref.getBool('signedInNormally') ?? false;
    signedInWithApple = pref.getBool('signedInWithApple') ?? false;
  }

  @override
  void initState() {
    getPrefs();
    context.read<FilteredAdsProvider>().getCategories();
    context.read<LocationFilterProvider>().getAreaList();
    context.read<AdsProvider>().refreshAds(context).then((_) => getPage());
    context.read<FilteredAdsProvider>().getMetaFields();
    super.initState();
  }

  getPage(){
    context.go('/home');
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Splash screen"),
    );
  }
}
