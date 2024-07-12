import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/auth/sign_up_provider.dart';
import 'package:vivadoo/widgets/auth/auth_input.dart';

import '../../constants.dart';
import '../../providers/my_vivafoo_providers/general_provider.dart';
class SignUp extends StatelessWidget {
   const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(
      builder: (context, signUp, _) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Material(
            color:  const Color.fromRGBO(235, 236, 247, 1),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: signUp.formStateSignUp,
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 80),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text("Let's get started")
                      ),
                      const SizedBox(height: 16),

                      //first name
                      AuthInput(
                        prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                        controller: signUp.firstNameController,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter a valid Name';
                          } else {
                            return null;
                          }
                        },
                        hint: 'First Name',
                        obscure: false,
                        title: 'First Name',
                        keyboard: TextInputType.name,
                      ),
                      const SizedBox(height: 8),

                      //last name
                      AuthInput(
                        prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                        controller: signUp.lastNameController,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter a valid Name';
                          } else {
                            return null;
                          }
                        },
                        hint: 'Last Name',
                        obscure: false,
                        title: 'Last Name',
                        keyboard: TextInputType.name,
                      ),
                      const SizedBox(height: 8),

                      //phone number
                      AuthInput(
                        prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                        controller: signUp.phoneNumberController,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Please enter a valid Phone number';
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

                      //email address
                      AuthInput(
                        prefixIcon: const Icon(Icons.person , color: Colors.black,size: 22,),
                        controller: signUp.emailController,
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
                        hint: 'Email Address',
                        obscure: false,
                        title: 'Email Address',
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 8),

                      //password
                      AuthInput(
                        controller: signUp.passwordController,
                        prefixIcon: const Icon(Icons.lock , color: Colors.black,size: 22,),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          icon: signUp.visible
                              ? SvgPicture.asset(
                              'assets/icons/auth/unvisible.svg')
                              : SvgPicture.asset(
                              'assets/icons/auth/visible.svg'),
                          onPressed: ()=> signUp.toggleVisible(),
                        ),
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          } else {
                            return null;
                          }
                        },
                        hint: 'Password',
                        obscure: signUp.visible,
                        title: 'Password',
                        keyboard: TextInputType.visiblePassword,
                      ),

                      //confirm password
                      AuthInput(
                        controller: signUp.confirmPasswordController,
                        prefixIcon: const Icon(Icons.lock , color: Colors.black,size: 22,),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          icon: signUp.confirmVisible
                              ? SvgPicture.asset(
                              'assets/icons/auth/unvisible.svg')
                              : SvgPicture.asset(
                              'assets/icons/auth/visible.svg'),
                          onPressed: ()=> signUp.toggleConfirmVisible(),
                        ),
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value != signUp.passwordController.text) {
                            return 'Password not match';
                          } else {
                            return null;
                          }
                        },
                        hint: 'Confirm Password',
                        obscure: signUp.confirmVisible,
                        title: 'Confirm Password',
                        keyboard: TextInputType.visiblePassword,
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
                            const Text("OR"),
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



                                               Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         //google login
                         Padding(
                           padding:  EdgeInsets.only(left: Platform.isIOS ? 0 : 50),
                           child: ElevatedButton(
                             onPressed:() {
                               // if(context.read<SignInProvider>().agreed == false){
                               //   Get.rawSnackbar(
                               //     backgroundColor: Constants.redC,
                               //     message: "Please check our Terms of Use and Privacy Notice",
                               //   );
                               // }else{
                               //   context
                               //       .read<
                               //       SignInWithGoogleProvider>()
                               //       .signInWithGoogle(context);
                               // }

                             },
                             style: ButtonStyle(

                               minimumSize: MaterialStateProperty
                                   .all<Size?>(const Size(
                                   50, 50)),
                               shape: MaterialStateProperty.all<
                                   RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius.circular(6),
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
                             child: Image.asset(
                               "assets/icons/auth/gmail.png",
                               width: 22,
                               height: 22,
                             ),
                           ),
                         ),


                         //facebook login
                         Padding(
                           padding:  EdgeInsets.only(left: Platform.isIOS ? 0 : 25),
                           child: ElevatedButton(
                             onPressed: () {
                               // if(context.read<SignInProvider>().agreed == false){
                               //   Get.rawSnackbar(
                               //     backgroundColor: Constants.redC,
                               //     message: "Please check our Terms of Use and Privacy Notice",
                               //   );
                               // }else{
                               //   context
                               //       .read<SignInWithFacebookProvider>()
                               //       .signInWithFacebook(context);
                               // }

                             },
                             style: ButtonStyle(
                               minimumSize:
                               MaterialStateProperty.all<Size?>(
                                   const Size(50, 50)),
                               shape: MaterialStateProperty.all<
                                   RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius.circular(6),
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
                             child: Icon(
                                 Icons.facebook_outlined),
                           ),
                         ),


                         //Apple login
                          Visibility(
                             visible: Platform.isIOS,
                             child: ElevatedButton(
                               onPressed: () {
                                 // if(context.read<SignInProvider>().agreed == false){
                                 //   Get.rawSnackbar(
                                 //     backgroundColor: Constants.redC,
                                 //     message: "Please check our Terms of Use and Privacy Notice",
                                 //   );
                                 // }else{
                                 //   context.read<SignInWithAppleProvider>().signInWithApple(context);
                                 // }

                               },
                               style: ButtonStyle(
                                 minimumSize:
                                 MaterialStateProperty.all<Size?>(
                                     const Size(50, 50)),
                                 shape: MaterialStateProperty.all<
                                     RoundedRectangleBorder>(
                                   RoundedRectangleBorder(
                                     borderRadius:
                                     BorderRadius.circular(6),
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
                               child: const Icon(
                                   Icons.apple_rounded, color: Colors.white),
                             ),
                          ),
                       ],),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              signUp.signUp(context);
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size?>(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
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
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
