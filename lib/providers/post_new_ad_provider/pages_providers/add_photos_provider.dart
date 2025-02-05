import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/main.dart';
import 'package:vivadoo/models/new_ad_model/new_ad_model.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';

import '../../../constants.dart';
class AddPhotosProvider with ChangeNotifier{
  bool photosState = false;
  bool selectMode = false;

  List<XFile> imageList = [];
  List<XFile> selected = [];
  XFile? mainPicture;

  setMainPicture(int index){
    mainPicture = imageList[index];
    notifyListeners();
  }

  setPhotosState() {
    photosState = imageList.isNotEmpty;
  }

  setSelectMode(XFile image) {
    if (selected.contains(image)) {
      selected.remove(image);
      if (selected.isEmpty) {
        selectMode = false;
      }
      notifyListeners();
    } else {
      selected.add(image);
      selectMode = true;
      notifyListeners();
    }
  }

  setImageList(BuildContext context,List<XFile> newImages) {
    if(newImages.length + imageList.length > 9){
      int y = 9 - imageList.length;
      for(int i = 0 ; i < y ; i++){
        imageList.add(newImages[i]);
        context.read<PostNewAdProvider>().addPhotosToHive([newImages[i]]);

      }
      Get.rawSnackbar(
        messageText: const Text("Maximum 9 photos!\nOnly 9 photos will be shown" ,textAlign: TextAlign.start, style: TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w500),),
        isDismissible: true,
        duration: const Duration(seconds:4),
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Constants.orange,
      );
    }else{
      imageList.addAll(newImages);
      context.read<PostNewAdProvider>().addPhotosToHive(newImages);
    }
    setPhotosState();
    notifyListeners();
  }

  removeAllSelectedImages(BuildContext context) {
    for (var element in selected) {
      if (imageList.contains(element)) {
        imageList.remove(element);
        context.read<PostNewAdProvider>().removePhotoFromHive(element);
      }
    }
    setPhotosState();
    selected.clear();
    selectMode = false;
    notifyListeners();
  }



}