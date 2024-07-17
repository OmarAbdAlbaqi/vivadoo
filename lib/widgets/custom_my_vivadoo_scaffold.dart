import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/my_vivafoo_providers/general_provider.dart';

import '../providers/auth/user_info_provider.dart';
import '../utils/hive_manager.dart';
class CustomMyVivadooScaffold extends StatelessWidget {
  const CustomMyVivadooScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final  box = HiveStorageManager.hiveBox;
    bool signedIn = box.get('signedIn') ?? false;
    return ValueListenableBuilder(
      valueListenable: HiveStorageManager.hiveBox.listenable(),
        builder: (context, hiveBox, widget) {
          String page = hiveBox.get('route');
          return Scaffold(
            backgroundColor: const Color.fromRGBO(235, 236, 247, 1),
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: signedIn ? 150 : context.watch<MyVivadooProvider>().toolbarHeightValue,
              backgroundColor: Colors.white,
              leading: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: const Color.fromRGBO(235, 236, 247, 1),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    height: page == "MyVivadoo" ? 350 : 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular( page == "MyVivadoo" && !signedIn ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 5), bottomRight: Radius.circular(page == "MyVivadoo" && !signedIn ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 5))
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
