import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/add_photos_provider.dart';
class AddPhotosWidget extends StatelessWidget {
  const AddPhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPhotosProvider>(
      builder: (context, prov, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text("You can add up to 9 images", style: TextStyle(fontWeight: FontWeight.w500),)
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width + 20,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( mainAxisSpacing: 8, crossAxisSpacing: 8, crossAxisCount: 3, childAspectRatio: 0.9),
                    itemBuilder: (context, index){
                      return prov.imageList.length -1 >= index ? GestureDetector(
                        onTap: ()  {
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                            tag: prov.imageList[index].path,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.file(
                                    File(prov.imageList[index].path),
                                    fit: BoxFit.cover,
                                    color: prov.selected.contains(prov.imageList[index])?
                                    Colors.black.withOpacity(0.6)
                                        : Colors.transparent,
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: (){
                                      prov.setMainPicture(index);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      color: const Color.fromRGBO(0, 0, 0, 0.3),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(prov.imageList[index] == prov.mainPicture ? Icons.check_box: Icons.check_box_outline_blank, color: Colors.white,),
                                          const Text("Main picture", style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ): GestureDetector(
                          onTap: () async {
                            final List<XFile> images = await ImagePicker().pickMultiImage();
                            if (images.isNotEmpty) {
                              if(context.mounted){
                                context.read<AddPhotosProvider>().setImageList(images);
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_a_photo_rounded),
                          ));
                    }),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Upload as many clear images as possible, this will get your ad more views abd replies!", style: TextStyle(fontSize: 13, color: Color.fromRGBO(150, 150, 150, 0.8)),),
              ),
            ],
          ),
        );
      }
    );
  }
}
