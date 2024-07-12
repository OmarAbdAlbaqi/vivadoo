import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/auth/user_info_provider.dart';

import '../../widgets/my_vivadoo_widgets/enrolling_page.dart';


class MyVivadoo extends StatefulWidget {
  const MyVivadoo({super.key});

  @override
  State<MyVivadoo> createState() => _MyVivadooState();
}

class _MyVivadooState extends State<MyVivadoo> {
  @override
  Widget build(BuildContext context) {
    bool signedIn = context.read<UserInfoProvider>().signedIn;
    if(signedIn) {
      return const Enrolling();
    }
    return const Center();
  }


}
