import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/my_vivadoo_providers/auth/forgot_password_provider.dart';
import '../../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import 'auth_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<ForgotPasswordProvider>(
        builder: (context, forgotPassword, _) {
          return Material(
            color:  const Color.fromRGBO(235, 236, 247, 1),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: forgotPassword.formStateForgotPassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20 , right: 20 , top: 20),
                    child: Column(
                      children: [
                       Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(AppLocalizations.of(context)!.please_enter_your_email_address_to_reset_your_password)
                        ),
                        const SizedBox(height: 16),
                        AuthInput(
                          prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                          controller: forgotPassword.emailController,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(value)) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                          hint: AppLocalizations.of(context)!.email_address,
                          obscure: false,
                          title: AppLocalizations.of(context)!.email_address,
                          keyboard: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),


                      ],
                    ),
                  ),

                  //normal sign in
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only( left: 20 , right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            forgotPassword.forgotPassword(context);
                          },
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all<Size?>(
                                const Size(double.infinity, 40)),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: const BorderSide(
                                  color: Constants.orange,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            animationDuration: const Duration(milliseconds: 500),
                            backgroundColor: context.read<MyVivadooProvider>().getColor(Constants.orange, Colors.white),
                            foregroundColor: context.read<MyVivadooProvider>().getColor(Colors.white, Constants.orange),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.submit,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:  Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
