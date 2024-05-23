import 'package:flutter/material.dart';

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

}