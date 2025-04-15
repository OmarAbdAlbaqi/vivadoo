import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';

import '../../../constants.dart';
import '../../../providers/my_vivadoo_providers/auth/sign_in_provider.dart';
import 'auth_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignIn extends StatelessWidget {
   const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<SignInProvider>(
        builder: (context, signIn, _) {
          return Material(
            color:  const Color.fromRGBO(255, 255, 255, 1),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: signIn.formStateS,
              child: LayoutBuilder(builder: (context , constraints){
                return SingleChildScrollView(
                  child: ConstrainedBox(constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(AppLocalizations.of(context)!.please_use_your_credentials_to_sign_in_your_account , style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),)
                          ),
                          const SizedBox(height: 16),
                          AuthInput(
                            prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                            controller: signIn.emailController,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value)) {
                                return AppLocalizations.of(context)!.please_enter_a_valid_email;
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
                          AuthInput(
                            controller: signIn.passwordController,
                            prefixIcon: const Icon(Icons.lock , color: Colors.black,size: 22,),
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              icon: signIn.visible
                                  ? SvgPicture.asset(
                                  'assets/icons/auth/invisible.svg')
                                  : SvgPicture.asset(
                                  'assets/icons/auth/visible.svg'),
                              onPressed: () {
                                signIn.toggleVisible();
                              },
                            ),
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value!.isEmpty
                              // ||
                              // !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_.\-@#%&*!~]).{8,}$')
                              //     .hasMatch(value)
                              ) {
                                return AppLocalizations.of(context)!.please_enter_a_valid_password;
                              } else {
                                return null;
                              }
                            },
                            hint: AppLocalizations.of(context)!.password,
                            obscure: signIn.visible,
                            title: AppLocalizations.of(context)!.password,
                            keyboard: TextInputType.visiblePassword,
                            onChanged: (value) {
                            },
                          ),

                          //or
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  height: 1,
                                  width:
                                  (MediaQuery.of(context).size.width / 2) - 35,
                                ),
                                Text(AppLocalizations.of(context)!.or),
                                Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  height: 1,
                                  width:
                                  (MediaQuery.of(context).size.width /
                                      2) -
                                      35,
                                ),
                              ],
                            ),
                          ),

                          //google login
                          ElevatedButton(
                            onPressed:() {
                              signIn.loginWithSocial(context , SocialLoginProvider.google);
                            },
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty
                                  .all<Size?>(const Size(
                                  double.infinity, 40)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              animationDuration: const Duration(
                                  milliseconds: 500),
                              foregroundColor: context.read<MyVivadooProvider>().getColor(const Color.fromRGBO(61, 61, 61, 1),
                                  Colors.white),
                              backgroundColor: context.read<MyVivadooProvider>().getColor(
                                Colors.white,const Color.fromRGBO(61, 61, 61, 1),),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/icons/auth/gmail.png",
                                  width: 22,
                                  height: 22,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.continue_with_google,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w700),
                                ),
                                const Center(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //facebook login
                          ElevatedButton(
                            onPressed: () {
                              signIn.loginWithSocial(context, SocialLoginProvider.facebook);
                            },
                            style: ButtonStyle(
                              minimumSize:
                              WidgetStateProperty.all<Size?>(
                                  const Size(double.infinity, 40)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(66, 103, 178, 1),
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              animationDuration:
                              const Duration(milliseconds: 500),
                              foregroundColor: context.read<MyVivadooProvider>().getColor(
                                  Colors.white, const Color.fromRGBO(66, 103, 178, 1)),
                              backgroundColor: context.read<MyVivadooProvider>().getColor(
                                  const Color.fromRGBO(66, 103, 178, 1), Colors.white),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.facebook_outlined , color: Colors.white,),
                                Text(
                                  AppLocalizations.of(context)!.continue_with_facebook,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w700),
                                ),
                                const Center(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //Apple login
                          Visibility(
                              visible: Platform.isIOS,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      signIn.loginWithSocial(context, SocialLoginProvider.apple);
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                      WidgetStateProperty.all<Size?>(
                                          const Size(double.infinity, 40)),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          side: const BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      animationDuration:
                                      const Duration(milliseconds: 500),
                                      foregroundColor: context.read<MyVivadooProvider>().getColor(
                                          Colors.white, Colors.black),
                                      backgroundColor: context.read<MyVivadooProvider>().getColor(
                                          Colors.black, Colors.white),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                            Icons.apple_rounded, color: Colors.white),
                                        Text(
                                          AppLocalizations.of(context)!.continue_with_apple,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700),
                                        ),
                                        const Center(),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              signIn.signIn(context);
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
                            child: signIn.signInLoading ?
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                                : Text(
                              AppLocalizations.of(context)!.sign_in,
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
                  ),
                  ),
                );
              })
            ),
          );
        }
      ),
    );
  }
}
