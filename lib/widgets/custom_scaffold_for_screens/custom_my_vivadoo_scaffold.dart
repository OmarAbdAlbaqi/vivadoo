
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import '../../utils/hive_manager.dart';
import '../../utils/pop-ups/pop_ups.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomMyVivadooScaffold extends StatelessWidget {
  const CustomMyVivadooScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // final  box = HiveStorageManager.hiveBox;
    // bool signedIn = ;
    return ValueListenableBuilder(
      valueListenable: HiveStorageManager.hiveBox.listenable(),
        builder: (context, hiveBox, widget) {
          String page = hiveBox.get('route');
          String route = hiveBox.get('route');
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: Visibility(
              visible: HiveStorageManager.signedInNotifier.value && route == 'MyVivadoo',
              child: GestureDetector(
                onTap: () {
                  PopUps.logoutConfirmation(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(255, 0, 0, 1),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            appBar: HiveStorageManager.signedInNotifier.value ?
            AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset("assets/images/logo.png" , width: 100,),
                  ),
                  const SizedBox(width: 8),
                  const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600),),
                ],
              ),
            )
                :AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: HiveStorageManager.signedInNotifier.value ? 150 : context.watch<MyVivadooProvider>().toolbarHeightValue,
              backgroundColor: Colors.white,
              leading: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: Colors.white,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    height: page == "MyVivadoo" ? 350 : 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular( page == "MyVivadoo" && !HiveStorageManager.signedInNotifier.value ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 5), bottomRight: Radius.circular(page == "MyVivadoo" && !HiveStorageManager.signedInNotifier.value ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 5))
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),

                ],
              ),
              leadingWidth: double.infinity,
            ),
            body: child,
          );
        }
    );
  }
}
