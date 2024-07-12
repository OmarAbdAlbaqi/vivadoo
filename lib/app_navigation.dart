

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivadoo/providers/navigation_shell_provider.dart';
import 'package:vivadoo/screens/auth/forgot_password.dart';
import 'package:vivadoo/widgets/post_new_ad_widgets/ad_poster_information_widget/ad_poster_information_widget.dart';
import '../screens/ad_details/carousel_ads_widget.dart';
import '../screens/app_init/splash_screen.dart';
import '../screens/auth/sign_in.dart';
import '../screens/auth/sign_up.dart';
import '../screens/main_screen.dart';
import '../screens/nav_bar_pages/home_page.dart';
import '../screens/nav_bar_pages/messages.dart';
import '../screens/nav_bar_pages/my_vivadoo.dart';
import '../screens/nav_bar_pages/post_new_ad.dart';
import '../screens/nav_bar_pages/saved.dart';
import '../utils/hive_manager.dart';
import '../widgets/custom_home_scaffold.dart';
import '../widgets/custom_my_vivadoo_scaffold.dart';
import '../widgets/custom_post_new_ad_scaffold.dart';
import '../widgets/home_screen_widgets/filtered_home_page.dart';
import '../widgets/home_screen_widgets/general_filter_widgets/filter_widget.dart';
import '../widgets/home_screen_widgets/location_widgets/location_filter_widget.dart';
import '../widgets/home_screen_widgets/location_widgets/sub_location_widget.dart';
import '../widgets/post_new_ad_widgets/location_and_category_widget/category_location_widget.dart';
import '../widgets/post_new_ad_widgets/new_ad_details_widget/new_ad_details.dart';


class AppNavigation {
  AppNavigation._();

  static String initR = '/splash';
  static final routNavigatorKey = GlobalKey<NavigatorState>();
  static final _routNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _routNavigatorMessages = GlobalKey<NavigatorState>(debugLabel: 'shellMessages');
  static final _routNavigatorMyVivadoo = GlobalKey<NavigatorState>(debugLabel: 'shellMyVivadoo');
  static final _routNavigatorPostNewAd = GlobalKey<NavigatorState>(debugLabel: 'shellPostNewAd');
  static final _routNavigatorSaved = GlobalKey<NavigatorState>(debugLabel: 'shellSaved');

  static final GoRouter router = GoRouter(
    observers: [MyRouteObserver()],
    initialLocation: initR,
    navigatorKey: routNavigatorKey,
    routes: <RouteBase>[
      // splash
      GoRoute(
        path: '/splash',
        name: 'Splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      // add details screen
      GoRoute(
        path: '/homePageAdDetails',
        name: 'Home Page Ad Details',
        builder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          return CarouselAdsWidget(isFavorite: data['isFavorite'], initialIndex: data['initialIndex']);
        },
      ),
      StatefulShellRoute.indexedStack(
          parentNavigatorKey: routNavigatorKey,
          branches: <StatefulShellBranch>[
            // home page
            StatefulShellBranch(
              observers: [MyRouteObserver()],
              navigatorKey: _routNavigatorHome,
              routes: [
                ShellRoute(
                  observers: [MyRouteObserver()],
                  builder: (
                      BuildContext context,
                      GoRouterState state,
                      Widget child,
                      ) {
                    return CustomHomeScaffold(child: child);
                  },
                  routes: [
                    GoRoute(
                        name: 'Home',
                        path: '/home',
                        builder: (context, state) {
                          return const HomePage();
                        },
                        routes: [
                          GoRoute(
                              name: "FilteredHome",
                              path: 'filteredHome',
                              builder: (context, state) {
                                return const FilteredHomePage();
                              },
                              routes: [
                                GoRoute(
                                    name: "Filter",
                                    path: 'filter',
                                    builder: (context, state) {
                                      return const FilterWidget();
                                    },
                                    routes: [
                                      GoRoute(
                                          name: "LocationFilterFromFilter",
                                          path: 'locationFilterFromFilter',
                                          builder: (context, state) {
                                            return const LocationFilterWidget();
                                          },
                                          routes: [
                                            GoRoute(
                                                name: "SubLocationFilterFromFilter",
                                                path: 'subLocationFilterFromFilter',
                                                builder: (context, state) {
                                                  return const SubLocationWidget();
                                                }
                                            ),
                                          ]
                                      ),
                                    ]
                                ),
                                GoRoute(
                                    name: "LocationFilterFromHome",
                                    path: 'locationFilterFromHome',
                                    builder: (context, state) {
                                      return const LocationFilterWidget();
                                    },
                                    routes: [
                                      GoRoute(
                                          name: "SubLocationFilterFromHome",
                                          path: 'subLocationFilterFromHome',
                                          builder: (context, state) {
                                            return const SubLocationWidget();
                                          }
                                      ),
                                    ]
                                ),
                              ]
                          ),
                        ]
                    ),
                  ],
                ),
              ],
            ),

            // my vivadoo
            StatefulShellBranch(
              observers: [MyRouteObserver()],
              navigatorKey: _routNavigatorMyVivadoo,
              routes: [
                ShellRoute(
                    observers: [MyRouteObserver()],
                    builder: (
                        BuildContext context,
                        GoRouterState state,
                        Widget child,
                        ){
                      return CustomMyVivadooScaffold(child: child);
                    },
                    routes: [
                      GoRoute(
                          path: '/myVivadoo',
                          name: 'MyVivadoo',
                          builder: (context, state) {
                            return const MyVivadoo();
                          },
                          routes: [
                            GoRoute(
                              name: "SignIn",
                              path: 'signIn',
                              builder: (context, state) {
                                return const SignIn();
                              },
                            ),
                            GoRoute(
                              name: "SignUp",
                              path: 'signUp',
                              builder: (context, state) {
                                return const SignUp();
                              },
                            ),
                            GoRoute(
                              name: "ForgotPassword",
                              path: 'forgotPassword',
                              builder: (context, state) {
                                return const ForgotPasswordWidget();
                              },
                            ),
                          ]
                      ),
                    ]
                ),
              ],
            ),
            // post new ad
            StatefulShellBranch(
              observers: [MyRouteObserver()],
              navigatorKey: _routNavigatorPostNewAd,
              routes: [
                ShellRoute(
                    observers: [MyRouteObserver()],
                    builder: (
                        BuildContext context,
                        GoRouterState state,
                        Widget child,
                        ){
                      return CustomPostNewAdScaffold(child: child);
                    },
                    routes: [
                      GoRoute(
                          path: '/postNewAd',
                          name: 'PostNewAd',
                          builder: (context, state) {
                            return const PostNewAd();
                          },
                          routes: [
                            GoRoute(
                                path: 'categoryAndLocation',
                                name: 'Category And Location',
                                builder: (context, state) {
                                  return const CategoryAndLocationWidget();
                                },
                                routes: [
                                  GoRoute(
                                    path: 'newAdDetails',
                                    name: 'NewAdDetails',
                                    builder: (context, state) {
                                      return const NewAdDetails();
                                    },
                                    routes: [
                                      //posterInformation
                                      GoRoute(
                                          path: 'posterInformation',
                                          name: 'PosterInformation',
                                          builder: (context, state) {
                                            return const AdPosterInformationWidget();
                                          },
                                      ),
                                    ]
                                  ),
                                ]
                            ),
                          ]
                      ),
                    ]
                ),
              ],
            ),
            // saved
            StatefulShellBranch(
              observers: [MyRouteObserver()],
              navigatorKey: _routNavigatorSaved,
              routes: [
                GoRoute(
                    path: '/saved',
                    name: 'Saved',
                    builder: (context, state) {
                      return Saved(key: state.pageKey);
                    },
                    routes: const []
                ),
              ],
            ),
            // messages
            StatefulShellBranch(
              observers: [MyRouteObserver()],
              navigatorKey: _routNavigatorMessages,
              routes: [
                GoRoute(
                    path: '/messages',
                    name: 'Messages',
                    builder: (context, state) {
                      return Messages(key: state.pageKey);
                    },
                    routes: const []
                ),
              ],
            ),
          ],
          builder: (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
              ) {
            NavigationManager().setNavigationShell(navigationShell);
            return MainScreen(navigationShell: navigationShell);
          }
      ),
    ],
  );

  static void popUntilPath(BuildContext context, String routePath) {
    while (
    router.routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        routePath) {
      if (!context.canPop()) {
        return;
      }
      context.pop();
    }
  }
}



class MyRouteObserver extends NavigatorObserver {
  var box = HiveStorageManager.hiveBox;

  void handlePop(String poppedFrom) {
    String? previousPage = box.get('prevRoute');
    print(poppedFrom);
    switch (poppedFrom) {
      case "Home Page Ad Details":
        previousPage != null && previousPage == "FilteredHome" ? box.put('route', 'FilteredHome') : box.put('route', 'Home');
        break;
      case "FilteredHome":
        box.put('route', 'Home');
        break;
      case "Filter":
        box.put('route', 'FilteredHome');
        break;
      case "LocationFilterFromFilter":
        box.put('route', 'Filter');
        break;
      case "LocationFilterFromHome":
        box.put('route', 'FilteredHome');
        break;
      case "SubLocationFilterFromFilter":
        box.put('route', 'LocationFilterFromFilter');
        break;
      case "SubLocationFilterFromHome":
        box.put('route', 'LocationFilterFromHome');
        break;
      case "SignIn" || "SignUp" || "ForgotPassword":
        box.put('route', 'MyVivadoo');
        break;
      case "Category And Location":
        box.put('route', 'PostNewAd');
        box.put('PostNewAdSavedPage', 'PostNewAd');
        break;
      case "NewAdDetails":
        box.put('route', 'Category And Location');
        box.put('PostNewAdSavedPage', 'Category And Location');
        break;
      case "PosterInformation":
        box.put('route', 'NewAdDetails');
        break;
    }
    box.put('prevRoute', poppedFrom);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null && route.isCurrent) {
      box.put('prevRoute', box.get('route'));

      box.put('route', route.settings.name);
      print("the route is : ${route.settings.name}");
      box.put('popped', false);
      if(route.settings.name == "Category And Location" || route.settings.name == "NewAdDetails" || route.settings.name == "PostNewAd" ){
        box.put('PostNewAdSavedPage', route.settings.name);

      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    handlePop(route.settings.name ?? "");
    box.put('prevRoute', route.settings.name);
    box.put('popped', true);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    box.put('route', newRoute?.settings.name);
    print('Route replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}


