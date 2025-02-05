import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
              minimumSize: WidgetStateProperty.all<Size?>(
                  const Size(double.infinity, 45)),
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
              AppLocalizations.of(context)!.sign_in,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

        //sign up
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              context.read<MyVivadooProvider>().changeValue(false);
              context.go('/myVivadoo/signUp');
            },
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size?>(
                  const Size(double.infinity, 45)),
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
              backgroundColor: getColor(Colors.white, Colors.orange),
              foregroundColor: getColor(Colors.orange, Colors.white),
            ),
            child: Text(
              AppLocalizations.of(context)!.register,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              child: Text(AppLocalizations.of(context)!.forgot_password, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
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
                        text: AppLocalizations.of(context)!.by_logging_in_you_agree_to_our,
                        style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)!.terms_of_use,
                          style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 , color: Colors.deepPurpleAccent ,),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              context.read<MyVivadooProvider>().changeValue(false);
                              context.go('/myVivadoo/termsOfUse');
                            }
                      ),
                    ])),
          ),
        ),
        const SizedBox(height:12),
      ],
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
