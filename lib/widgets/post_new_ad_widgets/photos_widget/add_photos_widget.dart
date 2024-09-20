import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';

import '../../../providers/ads_provider/ad_details_provider.dart';
import '../../../utils/pop-ups/pop_ups.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text("You can add up to 9 images", style: TextStyle(fontWeight: FontWeight.w500),)
                  ),
                  Visibility(
                    visible: prov.selectMode,
                    child: GestureDetector(
                      onTap: (){
                        prov.removeAllSelectedImages(context);
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        color: Colors.transparent,
                        child: const Row(
                          children: [
                            Text("Remove", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(255, 0, 0, 1)),),
                            Icon(Icons.delete_forever, color: Color.fromRGBO(255, 0,0, 1),)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width + 20,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( mainAxisSpacing: 8, crossAxisSpacing: 8, crossAxisCount: 3, childAspectRatio: 0.9),
                    itemBuilder: (context, index){
                      return prov.imageList.length -1 >= index ?
                      GestureDetector(
                        onTap: ()  {
                          prov.selectMode ? prov.setSelectMode(prov.imageList[index]):
                          showCupertinoModalPopup(
                              useRootNavigator: true,
                              context: context,
                              builder: (_){
                                return Material(
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.9,
                                    color: Colors.black,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  context.pop();
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 70,
                                                  color: Colors.transparent,
                                                  padding: const EdgeInsets.only(left: 12),
                                                  alignment: Alignment.centerLeft,
                                                  child: const Icon(Icons.close , color: Colors.white,),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                height: 60,
                                                alignment: Alignment.center,
                                                child: Selector<AdDetailsProvider , int>(
                                                    selector: (context, prov) => prov.originalImageIndex,
                                                    builder: (context , imageIndex , _) {
                                                      return Text("${imageIndex.toString()}/${prov.imageList.length}" , style: const TextStyle(fontSize: 13 , color: Colors.white , fontWeight: FontWeight.w700),);
                                                    }
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: PageView.builder(
                                              controller: PageController(initialPage: context.read<AdDetailsProvider>().imageIndex -1),
                                              onPageChanged: (value){
                                                context.read<AdDetailsProvider>().setOriginalImageIndex(value);
                                              },
                                              itemCount: prov.imageList.length,
                                              itemBuilder: (context , index){
                                                return List.generate(prov.imageList.length??0, (index) =>
                                                    Dismissible(
                                                        onDismissed: (value){
                                                          Navigator.pop(context);
                                                        },
                                                        behavior: HitTestBehavior.opaque,
                                                        direction: DismissDirection.down,
                                                        key: const Key("i don't why this"),
                                                        child: InteractiveViewer(
                                                          panEnabled: true,
                                                          boundaryMargin: const EdgeInsets.all(100),
                                                          minScale: 0.5,
                                                          maxScale: 5,
                                                          child: Image.file(
                                                            File(prov.imageList[index].path),
                                                            fit: BoxFit.contain,
                                                          ),

                                                        )
                                                    ))[index];
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        onLongPress: (){
                          prov.setSelectMode(prov.imageList[index]);
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
                                Visibility(
                                  visible: prov.selected.contains(prov.imageList[index]),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.check_circle_outline, color: Colors.white,),
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
                      ):
                      GestureDetector(
                          onTap: () async {
                            await PopUps.selectPhotoPickType(context);
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
