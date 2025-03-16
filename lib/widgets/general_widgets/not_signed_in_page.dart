import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/general/nav_bar_provider.dart';
import '../../providers/general/navigation_shell_provider.dart';
import '../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import '../../utils/hive_manager.dart';

Widget notSignedInPage(BuildContext context){
  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return WidgetStateProperty.resolveWith(getColor);
  }
  return SizedBox.expand(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You need to be Signed in to post a new Ad"),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: ElevatedButton(
              onPressed: () {
                HiveStorageManager.hiveBox.put('route', 'MyVivadoo');
                context.read<NavBarProvider>().setCurrentPage(1);
                NavigationManager().goBranch(1);
                context.read<MyVivadooProvider>().changeValue(false);
                context.go('/myVivadoo/signIn');
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size?>(
                    const Size(double.infinity, 45)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                animationDuration: const Duration(milliseconds: 500),
                backgroundColor: getColor(Colors.orange, Colors.white),
                foregroundColor: getColor(Colors.white, Colors.orange),
              ),
              child: const Stack(
                children: [
                  Icon(Icons.arrow_back),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Text(
                      "Get back to Vivadoo Profile",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}