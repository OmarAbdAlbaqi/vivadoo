import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/my_vivadoo_providers/auth/change_password_provider.dart';
import 'auth_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<ChangePasswordProvider>(
        builder: (context, prov, _) {
          return Material(
            color: const Color.fromRGBO(235, 236, 247, 1),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: prov.formStateChangePassword,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                           Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(AppLocalizations.of(context)!.enter_your_new_password)
                          ),
                          const SizedBox(height: 16),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: prov.passwordController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return AppLocalizations.of(context)!.please_enter_a_valid_password;
                              } else {
                                return null;
                              }
                            },
                            suffixIcon: GestureDetector(
                                onTap: ()=>prov.togglePasswordVisible(),
                                child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset(prov.passwordVisible ? "assets/icons/auth/visible.svg" : "assets/icons/auth/invisible.svg"))),
                            hint: AppLocalizations.of(context)!.password,
                            obscure: !prov.passwordVisible,
                            title: AppLocalizations.of(context)!.password,
                            keyboard: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: prov.confirmPasswordController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value!.isEmpty || value != prov.passwordController.text) {
                                return AppLocalizations.of(context)!.password_not_match;
                              } else {
                                return null;
                              }
                            },
                            suffixIcon: GestureDetector(
                                onTap: ()=>prov.toggleConfirmPasswordVisible(),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset(prov.confirmPasswordVisible ? "assets/icons/auth/visible.svg" : "assets/icons/auth/invisible.svg"))),
                            hint: AppLocalizations.of(context)!.confirm_Password,
                            obscure: !prov.confirmPasswordVisible,
                            title: AppLocalizations.of(context)!.confirm_Password,
                            keyboard: TextInputType.text,
                          ),
                        ],
                      ),
                      Align(
                        alignment: const Alignment(0,0.93),
                        child: ElevatedButton(
                          onPressed: () {
                            prov.changePassword(context);
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
                          child: Text(
                            AppLocalizations.of(context)!.submit,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
