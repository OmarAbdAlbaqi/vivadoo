import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/auth/user_info_provider.dart';

import '../../utils/hive_manager.dart';
import '../../widgets/my_vivadoo_widgets/enrolling_page.dart';
import '../../widgets/my_vivadoo_widgets/my_vivadoo_profile.dart';


class MyVivadoo extends StatelessWidget {
  const MyVivadoo({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: HiveStorageManager.signedInNotifier,
        builder: (context, signedIn, _) {
          print(signedIn);
          if (signedIn) {
            return const MyVivadooProfile();
          }
          return const Enrolling();
        }
    );
  }
}
