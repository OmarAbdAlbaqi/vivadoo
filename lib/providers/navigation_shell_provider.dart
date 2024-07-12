import 'package:go_router/go_router.dart';

class NavigationManager {
  static final NavigationManager _instance = NavigationManager._internal();
  late StatefulNavigationShell _navigationShell;

  factory NavigationManager() {
    return _instance;
  }

  NavigationManager._internal();

  void setNavigationShell(StatefulNavigationShell navigationShell) {
    _navigationShell = navigationShell;
  }

  void goBranch(int index, {bool initialLocation = false}) {
    _navigationShell.goBranch(index, initialLocation: initialLocation);
  }
}
