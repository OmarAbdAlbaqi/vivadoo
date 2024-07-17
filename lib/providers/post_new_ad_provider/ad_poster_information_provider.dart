import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/ad_details_model.dart';
import 'package:vivadoo/providers/filters/location_filter.dart';

import 'add_photos_provider.dart';
import 'category_and_location_provider.dart';
import 'new_ad_details_provider.dart';
class AdPosterInformationProvider with ChangeNotifier{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool hideMyPhoneNumber = false;
  bool enableChatForThisAd = false;

  toggleHidePhoneNumber(){
    hideMyPhoneNumber =! hideMyPhoneNumber;
    notifyListeners();
  }

  toggleEnableChatForThisAd(){
    enableChatForThisAd =! enableChatForThisAd;
    notifyListeners();
  }


  previewAd(BuildContext context){
    List<XFile> imageList = context.read<AddPhotosProvider>().imageList;
    NewAdDetailsProvider adDetails = context.read<NewAdDetailsProvider>();

    List<Map<String, dynamic>> images = [];
    for (var element in imageList){
      images.add({'main' : element.path});
    }
   AdDetailsModel adDetailsModel = AdDetailsModel(
     images: images,
     title: adDetails.adTitleController.text,
     priceFormatted: "${adDetails.adPriceController.text} \$",
     location: context.read<LocationFilterProvider>().tempLocation,
     postBy: nameController.text,
     since: null,
     description: adDetails.adDescriptionController.text,
   );
    context.push('/previewAd', extra: {'isFavorite' : false , 'adDetailsModel' : adDetailsModel});
  }
}