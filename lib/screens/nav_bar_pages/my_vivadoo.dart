import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/my_vivadoo_providers/auth/user_info_provider.dart';

import '../../utils/hive_manager.dart';
import '../../widgets/my_vivadoo_widgets/enrolling_page.dart';
import '../../widgets/my_vivadoo_widgets/my_vivadoo_profile_widgets/my_vivadoo_profile.dart';


class MyVivadoo extends StatelessWidget {
  const MyVivadoo({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: HiveStorageManager.signedInNotifier,
        builder: (context, signedIn, _) {
          if (signedIn) {
            context.read<UserInfoProvider>().getUserAds(context);
            return MyVivadooProfile();
          }
          return const Enrolling();
        }
    );
  }
}
