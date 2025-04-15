import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/my_vivadoo_providers/auth/sign_up_provider.dart';
import '../../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import 'auth_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUp, _) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: signUp.formStateSignUp,
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                            AppLocalizations.of(context)!.let_get_started,style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),)),
                    const SizedBox(height: 16),

                    //first name
                    AuthInput(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 22,
                      ),
                      controller: signUp.firstNameController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_name;
                        } else {
                          return null;
                        }
                      },
                      hint: AppLocalizations.of(context)!.first_name,
                      obscure: false,
                      title: AppLocalizations.of(context)!.first_name,
                      keyboard: TextInputType.name,
                    ),
                    const SizedBox(height: 8),

                    //last name
                    AuthInput(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 22,
                      ),
                      controller: signUp.lastNameController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_last_name;
                        } else {
                          return null;
                        }
                      },
                      hint: AppLocalizations.of(context)!.last_name,
                      obscure: false,
                      title: AppLocalizations.of(context)!.last_name,
                      keyboard: TextInputType.name,
                    ),
                    const SizedBox(height: 8),

                    //phone number
                    AuthInput(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 22,
                      ),
                      controller: signUp.phoneNumberController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_phone_number;
                        } else {
                          return null;
                        }
                      },
                      hint: AppLocalizations.of(context)!.phone_number,
                      obscure: false,
                      title: AppLocalizations.of(context)!.phone_number,
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 8),

                    //email address
                    AuthInput(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 22,
                      ),
                      controller: signUp.emailController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value)) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_email;
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

                    //password
                    AuthInput(
                      controller: signUp.passwordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        icon: signUp.visible
                            ? SvgPicture.asset(
                                'assets/icons/auth/invisible.svg')
                            : SvgPicture.asset('assets/icons/auth/visible.svg'),
                        onPressed: () => signUp.toggleVisible(),
                      ),
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_password;
                        } else {
                          return null;
                        }
                      },
                      hint: AppLocalizations.of(context)!.password,
                      obscure: signUp.visible,
                      title: AppLocalizations.of(context)!.password,
                      keyboard: TextInputType.visiblePassword,
                    ),

                    //confirm password
                    AuthInput(
                      controller: signUp.confirmPasswordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        icon: signUp.confirmVisible
                            ? SvgPicture.asset(
                                'assets/icons/auth/invisible.svg')
                            : SvgPicture.asset('assets/icons/auth/visible.svg'),
                        onPressed: () => signUp.toggleConfirmVisible(),
                      ),
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value != signUp.passwordController.text) {
                          return AppLocalizations.of(context)!
                              .password_not_match;
                        } else {
                          return null;
                        }
                      },
                      hint: AppLocalizations.of(context)!.confirm_Password,
                      obscure: signUp.confirmVisible,
                      title: AppLocalizations.of(context)!.confirm_Password,
                      keyboard: TextInputType.visiblePassword,
                    ),

                    //or
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                            width: (MediaQuery.of(context).size.width / 2) - 35,
                          ),
                          Text(AppLocalizations.of(context)!.or),
                          Container(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                            width: (MediaQuery.of(context).size.width / 2) - 35,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //google login
                        Padding(
                          padding:
                              EdgeInsets.only(left: Platform.isIOS ? 0 : 50),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size?>(
                                  const Size(50, 50)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              foregroundColor: context
                                  .read<MyVivadooProvider>()
                                  .getColor(const Color.fromRGBO(61, 61, 61, 1),
                                      Colors.white),
                              backgroundColor:
                                  context.read<MyVivadooProvider>().getColor(
                                        Colors.white,
                                        const Color.fromRGBO(61, 61, 61, 1),
                                      ),
                            ),
                            child: Image.asset(
                              "assets/icons/auth/gmail.png",
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ),

                        //facebook login
                        Padding(
                          padding:
                              EdgeInsets.only(left: Platform.isIOS ? 0 : 25),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size?>(
                                  const Size(50, 50)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(66, 103, 178, 1),
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              foregroundColor: context
                                  .read<MyVivadooProvider>()
                                  .getColor(Colors.white,
                                      const Color.fromRGBO(66, 103, 178, 1)),
                              backgroundColor: context
                                  .read<MyVivadooProvider>()
                                  .getColor(
                                      const Color.fromRGBO(66, 103, 178, 1),
                                      Colors.white),
                            ),
                            child: const Icon(Icons.facebook_outlined , color: Colors.white,),
                          ),
                        ),

                        //Apple login
                        Visibility(
                          visible: Platform.isIOS,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size?>(
                                  const Size(50, 50)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              foregroundColor: context
                                  .read<MyVivadooProvider>()
                                  .getColor(Colors.white, Colors.black),
                              backgroundColor: context
                                  .read<MyVivadooProvider>()
                                  .getColor(Colors.black, Colors.white),
                            ),
                            child: const Icon(Icons.apple_rounded,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        signUp.signUp(context);
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
                        backgroundColor: context
                            .read<MyVivadooProvider>()
                            .getColor(Constants.orange, Colors.white),
                        foregroundColor: context
                            .read<MyVivadooProvider>()
                            .getColor(Colors.white, Constants.orange),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.sign_up,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
