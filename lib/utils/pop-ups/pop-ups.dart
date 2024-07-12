import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';

class PopUps {
  static Future somethingWentWrong (BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext ctx){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Something went wrong!/nPlease try again later." , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF000000),
                    ),
                    alignment: Alignment.center,
                    child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                  ),
                ),
              ],
            ),
          ),
        );
      });

  static Future apiError (BuildContext context, String message) => showDialog(
      context: context,
      builder: (BuildContext ctx){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(message , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF000000),
                    ),
                    alignment: Alignment.center,
                    child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                  ),
                ),
              ],
            ),
          ),
        );
      });

  static Future forgotPasswordEmailSent (BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext ctx){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/vivadoo.png', width: 60,height: 40)),
                const Text("Reset password email sent!" , style: TextStyle(fontSize: 16 , color: Colors.black , fontWeight: FontWeight.w600),),
                const SizedBox(height: 8),
                const Text("Click on the link in the email to reset your password" , style: TextStyle(fontSize: 14 , color: Colors.black87 , fontWeight: FontWeight.w500),),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(ctx);
                      Future.delayed(const Duration(milliseconds: 300)).then((value) => context.pop());
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:Constants.orange,
                      ),
                      alignment: Alignment.center,
                      child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w600 , color: Color(0xFFffffff)),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });

}