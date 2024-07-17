import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/my_vivafoo_providers/general_provider.dart';
import 'package:vivadoo/screens/auth/sign_up.dart';

class Enrolling extends StatelessWidget {
  const Enrolling({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        //sign in
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              context.read<MyVivadooProvider>().changeValue(false);
              context.go('/myVivadoo/signIn');
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size?>(
                  const Size(double.infinity, 45)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              "Sign In",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        //or
        Row(
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

        //sign up
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              context.read<MyVivadooProvider>().changeValue(false);
              context.go('/myVivadoo/signUp');
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size?>(
                  const Size(double.infinity, 45)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              backgroundColor: getColor(Colors.white, Colors.orange),
              foregroundColor: getColor(Colors.orange, Colors.white),
            ),
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        //forgot password
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: (){
              context.read<MyVivadooProvider>().changeValue(false);
              context.go('/myVivadoo/forgotPassword');
            },
            child: Container(
              width: 160,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 8),
              child: const Text("Forgot Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
            ),
          ),
        ),

        const Spacer(),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By Logging in, You agree to our ",
                        style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),
                      ),
                      TextSpan(
                          text: " TERMS OF USE ",
                          style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 , color: Colors.deepPurpleAccent ,),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              print("qwertyuiop[");
                            }
                      ),
                      // TextSpan(
                      //   text: "and land for sale and for rent throughout the RE/MAX Organization and by RE/MAX Affiliates, as well as various real estate related issues we think may interest you. Company information and information on the RE/MAX Organization and RE/MAX Affiliates is also,provided on this site. To insure a safe, non-offensive environment for all visitors to this website, we have established these “Terms of Use.” By accessing any areas of remax.com.e.g., you agree to be bound by the terms and conditions set forth below. If you do not agree to all the Terms of Use, please do not use this site.",
                      //   style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),
                      // ),
                    ])),
          ),
        ),
        const SizedBox(height:12),
      ],
    );
  }
  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }
}
