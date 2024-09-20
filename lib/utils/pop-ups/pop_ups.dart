import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';
import '../../providers/my_vivadoo_providers/my_vivadoo_general_provider.dart';
import '../../constants.dart';
import '../../providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';
import '../hive_manager.dart';

class PopUps {

  static Future adInProgress (BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext ctx){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 8),
            width: 300,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFffffff),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Image.asset('assets/icons/post_new_ad/info.png', color: Colors.red,width: 50,height: 50,fit: BoxFit.cover,),
                const SizedBox(height: 20),
                const Text("Your have an Ad in progress!\nDo you want to continue?", style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                const Text("Press YES if you want to load the old data.", style: TextStyle(fontSize: 13, color: Colors.black54),textAlign: TextAlign.center,),
                const SizedBox(height: 8),
                const Text("Press NO if you want to remove the old data the post new ad ", style: TextStyle(fontSize: 13, color: Colors.black54),textAlign: TextAlign.center,),
                const Spacer(),
                const Divider(height: 0, color: Colors.grey,thickness: 0.5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        context.read<PostNewAdProvider>().getAdOldData(context);
                        ctx.pop();
                      },
                      child: Container(
                        width: 149.75,
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                        ),
                        alignment: Alignment.center,
                        child: const Text("YES", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: 50,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: (){
                        context.read<PostNewAdProvider>().adInProgress = false;
                        ctx.pop();
                      },
                      child: Container(
                        width: 149.75,
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                        ),
                        alignment: Alignment.center,
                        child: const Text("NO", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.red),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 9),
                Image.asset("assets/icons/info.png", width: 40,height: 40,color: Colors.red,),
                Container(
                  width: double.infinity,
                  height: 100,
                  alignment: const Alignment(0, 0),
                  child: const Text("Something went wrong!\nPlease try again later" ,textAlign: TextAlign.center, style: const TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                ),
                const Spacer(),
                const Divider(height: 0),
                GestureDetector(
                  onTap: () => ctx.pop(),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFF000000)),),
                  ),
                ),
              ],
            ),
          ),
        );
      });

  static Future selectPhotoPickType (BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext ctx){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(ctx);
                    final List<XFile> images = await ImagePicker().pickMultiImage();
                    if (images.isNotEmpty) {
                      if(context.mounted){
                        context.read<AddPhotosProvider>().setImageList(context,images);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    color: Colors.transparent,
                    width: double.infinity,
                    height: 70,
                    child: const Row(
                      children: [
                        Icon(Icons.image_search_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Gallery" , style: TextStyle(color: Colors.black , fontSize: 14 , fontWeight: FontWeight.w600),)
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(ctx);
                    final XFile? images = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (images != null) {
                      if(context.mounted){
                        context.read<AddPhotosProvider>().setImageList(context,[images]);
                      }
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20),
                    height: 70,
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Camera" , style: TextStyle(color: Colors.black , fontSize: 14 , fontWeight: FontWeight.w600),)
                      ],
                    ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 9),
                Image.asset("assets/icons/info.png", width: 40,height: 40,color: Colors.red,),
                Container(
                  width: double.infinity,
                  height: 100,
                  alignment: const Alignment(0, 0),
                  child: Text(message , style: const TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                ),
                const Spacer(),
                const Divider(height: 0),
                GestureDetector(
                  onTap: () => ctx.pop(),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text("OK" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFF000000)),),
                  ),
                ),
              ],
            ),
          ),
        );
      });

  static Future apiConfirmation (BuildContext context, String message,{String? type}) => showDialog(
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
                 Text(message , style: const TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                GestureDetector(
                  onTap: switch(type){
                    "changePassword" => (){
                      Navigator.pop(ctx);
                      Future.delayed(const Duration(milliseconds: 200)).then((value) => context.pop());
                      Future.delayed(const Duration(milliseconds: 200)).then((value) => context.pop());
                    },

                    null || String() => (){
                      Navigator.pop(ctx);
                      Future.delayed(const Duration(milliseconds: 300)).then((value) => context.pop());
                    },
                  },
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

  static Future logoutConfirmation (BuildContext context) => showDialog(
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
                const Text("Do you really want to logout?" , style: TextStyle(fontSize: 14 , color: Colors.black , fontWeight: FontWeight.w500),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        context.pushReplacement('/myVivadoo');
                        context.read<MyVivadooProvider>().changeValue(true);
                        HiveStorageManager.setSignedIn(false);
                        HiveStorageManager.getUserInfoModel().clear();
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1e6229),
                        ),
                        alignment: Alignment.center,
                        child: const Text("Yes" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromRGBO(255, 0, 0, 1),
                        ),
                        alignment: Alignment.center,
                        child: const Text("No" , style: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xFFffffff)),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });

}