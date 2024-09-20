import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/ad_poster_information_provider.dart';
import 'package:vivadoo/widgets/post_new_ad_widgets/ad_details_input.dart';
class AdPosterInformationWidget extends StatelessWidget {
  const AdPosterInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdPosterInformationProvider>(
      builder: (context, prov, _) {
        return Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            child: Column(
              children: [
                AdDetailsInput(
                    title: 'Name',
                    keyboard: TextInputType.name,
                    obscure: false,
                    onChanged: (value){
                      prov.storeNameInHive(context,value);
                    },
                    validator: (value){
                      if(value != null  && value.isEmpty){
                        return "Please enter a valid name";
                      }else{
                        return null;
                      }
                    },
                    hint: 'Name',
                    textCapitalization: TextCapitalization.words,
                    controller: prov.nameController,
                ),
                AdDetailsInput(
                    title: 'Email Address',
                    keyboard: TextInputType.emailAddress,
                    obscure: false,
                    onChanged: (value){
                      prov.storeEmailInHive(context,value);
                    },
                    validator: (value){
                      if(value != null  && value.isEmpty){
                        return "Please enter a valid email";
                      }else{
                        return null;
                      }
                    },
                    hint: 'Email',
                    textCapitalization: TextCapitalization.none,
                    controller: prov.emailController,
                ),
                AdDetailsInput(
                    title: 'Phone Number',
                    keyboard: TextInputType.phone,
                    obscure: false,
                    onChanged: (value){
                      prov.storePhoneInHive(context,value);
                    },
                    validator: (value){
                      if(value != null  && value.isEmpty){
                        return "Please enter a valid phone number";
                      }else{
                        return null;
                      }
                    },
                    hint: 'Phone Number',
                    textCapitalization: TextCapitalization.none,
                    controller: prov.phoneController,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Hide my phone number"),
                      CupertinoSwitch(
                          value: prov.hideMyPhoneNumber,
                          onChanged: (value){
                            prov.toggleHidePhoneNumber();
                          })
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Enable chat for this ad"),
                      CupertinoSwitch(
                          value: prov.enableChatForThisAd,
                          onChanged: (value){
                            prov.toggleEnableChatForThisAd();
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
