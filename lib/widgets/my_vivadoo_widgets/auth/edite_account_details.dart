import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/my_vivadoo_providers/auth/edit_account_details_provider.dart';
import 'auth_input.dart';
class EditAccountDetails extends StatelessWidget {
  const EditAccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<EditAccountDetailsProvider>(
        builder: (context, prov, _) {
          return Material(
            color: const Color.fromRGBO(235, 236, 247, 1),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: prov.formStateEditAccountDetails,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text("Update your personal information")
                          ),
                          const SizedBox(height: 16),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: prov.firstNameController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 3) {
                                return 'Please enter a valid name';
                              } else {
                                return null;
                              }
                            },
                            hint: 'First Name',
                            obscure: false,
                            title: 'First Name',
                            keyboard: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: prov.lastNameController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Please enter a valid last name';
                              } else {
                                return null;
                              }
                            },
                            hint: 'Last Name',
                            obscure: false,
                            title: 'Last Name',
                            keyboard: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: prov.phoneController,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'Please enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
                            hint: 'Phone Number',
                            obscure: false,
                            title: 'Phone Number',
                            keyboard: TextInputType.phone,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: (){
                                context.go('/myVivadoo/editAccountDetails/changePassword');
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 8),
                                width: 160,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                color: Colors.transparent,
                                child: const Text("Change Password", style: TextStyle(color: Colors.indigoAccent),),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80,),
                        ],
                      ),
                      Align(
                        alignment: const Alignment(0,0.93),
                        child: ElevatedButton(
                          onPressed: () {
                            prov.updateUerInfo(context);
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets?>(
                                const EdgeInsets.symmetric(horizontal: 20)
                            ),
                            minimumSize: WidgetStateProperty.all<Size?>(
                                Size(MediaQuery.of(context).size.width - 24, 45)),
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
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          );
        }
      ),
    );
  }
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
}
