import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/favorite_providers/favorite_provider.dart';
import 'package:vivadoo/providers/home_providers/filters/filter_provider.dart';
import 'package:vivadoo/providers/home_providers/filters/location_filter.dart';
import 'package:vivadoo/providers/home_providers/filters/range_filter_provider.dart';
import 'package:vivadoo/providers/home_providers/home_search_provider.dart';
import 'package:vivadoo/providers/messages/messages_provider.dart';
import 'package:vivadoo/utils/app_navigation.dart';
import '../providers/my_vivadoo_providers/my_vivadoo_profile_provider.dart';
import '../providers/post_new_ad_provider/post_new_ad_provider.dart';
import '../firebase_options.dart';
import '../providers/my_vivadoo_providers/auth/change_password_provider.dart';
import '../providers/my_vivadoo_providers/auth/edit_account_details_provider.dart';
import '../providers/my_vivadoo_providers/auth/forgot_password_provider.dart';
import '../providers/my_vivadoo_providers/auth/sign_in_provider.dart';
import '../providers/my_vivadoo_providers/auth/sign_up_provider.dart';
import '../providers/my_vivadoo_providers/auth/social_media_auth/apple_auth_provider.dart';
import '../providers/my_vivadoo_providers/auth/user_info_provider.dart';
import 'constants.dart';
import 'providers/post_new_ad_provider/pages_providers/ad_poster_information_provider.dart';
import '../services/push_notifications.dart';
import 'providers/post_new_ad_provider/steps_bar_widget_provider.dart';
import '../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import 'providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';
import 'providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';
import 'providers/post_new_ad_provider/pages_providers/new_ad_details_provider.dart';
import '../utils/hive_manager.dart';
import '../providers/ads_provider/ad_details_provider.dart';
import '../providers/ads_provider/ads_provider.dart';
import '../providers/ads_provider/filtered_ads_provider.dart';
import '../providers/ads_provider/user_ads_screen_provider.dart';
import 'providers/home_providers/home_page_provider.dart';
import '../providers/general/nav_bar_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'models/ad_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleBackGroundMessage(RemoteMessage message) async {
  print(message.data);
}
appInit() async {
  await FirebaseAPI().initNotifications();
}


main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorageManager.openHiveBox();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await appInit();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (context) => NavBarProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => LocationFilterProvider()),
        ChangeNotifierProvider(create: (context) => AdDetailsProvider()),
        ChangeNotifierProvider(create: (context) => FilteredAdsProvider(context)),
        ChangeNotifierProvider(create: (context) => UserAdsScreenProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => MyVivadooProvider()),
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => StepsBarWidgetProvider()),
        ChangeNotifierProvider(create: (context) => AddPhotosProvider()),
        ChangeNotifierProvider(create: (context) => CategoryAndLocationProvider()),
        ChangeNotifierProvider(create: (context) => NewAdDetailsProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider(context)),
        ChangeNotifierProvider(create: (context) => MyAppleAuthProvider()),
        ChangeNotifierProvider(create: (context) => AdPosterInformationProvider()),
        ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (context) => EditAccountDetailsProvider()),
        ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (context) => MyVivadooProfileProvider()),
        ChangeNotifierProvider(create: (context) => PostNewAdProvider()),
        ChangeNotifierProvider(create: (context) => RangeFilterProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => HomeSearchProvider()),
        ChangeNotifierProvider(create: (context) => MessagesProvider()),
      ],
      child: ValueListenableBuilder(
          valueListenable: HiveStorageManager.hiveBox.listenable(),
        builder: (context, Box hiveBox, widget) {
          print(hiveBox.get('route'));
            if(hiveBox.get('popped') ?? false){
              switch(hiveBox.get('route')){
                case "Home" : {
                  if(hiveBox.get('prevRoute') == "FilteredHome"){
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      List<AdModel> adsList = context.read<AdsProvider>().adsList;
                      context.read<AdDetailsProvider>().setListOfAdDetails(adsList, clearList: true);
                      context.read<FilterProvider>().clearFilter(context);
                      context.read<FilteredAdsProvider>().setFirstAnimation(false);
                    });
                    break;
                  }
                  if(hiveBox.get('prevRoute') == "Home Page Ad Details"){
                    context.read<AdDetailsProvider>().readMore = false;
                    context.read<AdDetailsProvider>().titleOpacity = 0;
                    break;
                  }
                }
                case "MyVivadoo" : {
                  if(hiveBox.get('prevRoute') == "SignIn" || hiveBox.get('prevRoute') == "SignUp" || hiveBox.get('prevRoute') == "ForgotPassword" || hiveBox.get('prevRoute') == "TermsOfUse" ){
              WidgetsBinding.instance.addPostFrameCallback((_){
                context.read<MyVivadooProvider>().changeValue(true);
              });
                  }
                  break;
                }
                case "PostNewAd" : {
                  if(hiveBox.get('prevRoute') == "Category And Location"){
                    context.read<StepsBarWidgetProvider>().setCurrentIndex(0);
                  }
                  break;
                }
                case "Category And Location" : {
                  if(hiveBox.get('prevRoute') == "NewAdDetails"){
                    context.read<StepsBarWidgetProvider>().setCurrentIndex(1);
                  }
                  break;
                }
                case "NewAdDetails" : {
                  if(hiveBox.get('prevRoute') == "PosterInformation"){
                    context.read<StepsBarWidgetProvider>().setCurrentIndex(2);
                  }
                  break;
                }
                case "FilteredHome" : {
                if(hiveBox.get('prevRoute') == "Filter"){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    context.read<FilterProvider>().resetFilter(context);
                  });
                  break;
                }
                if(hiveBox.get('prevRoute') == "Home Page Ad Details"){
                  context.read<AdDetailsProvider>().readMore = false;
                  context.read<AdDetailsProvider>().titleOpacity = 0;
                  break;
                }
              }
              }
              hiveBox.put('popped', false);
            }
          return
            MaterialApp.router(
            routerDelegate: AppNavigation.router.routerDelegate,
            routeInformationParser: AppNavigation.router.routeInformationParser,
            routeInformationProvider: AppNavigation.router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              sliderTheme:  SliderThemeData(
                activeTrackColor: Constants.orange,
                inactiveTrackColor: Colors.grey,
                thumbColor: Constants.orange,
                overlayColor: Constants.orange.withOpacity(0.2),
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                trackHeight: 1,
                rangeValueIndicatorShape: const RectangularRangeSliderValueIndicatorShape(
                ),
                valueIndicatorColor: Constants.orange,
                rangeThumbShape: const RoundRangeSliderThumbShape(
                )
              )
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _locale,
          );
        }
      ),
    );
  }
}
// context.read<LocationFilterProvider>().location = AppLocalizations.of(context).all_over_country;