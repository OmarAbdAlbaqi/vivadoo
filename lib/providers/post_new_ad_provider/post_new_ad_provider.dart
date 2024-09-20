import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/new_ad_model/new_ad_model.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/ad_poster_information_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/new_ad_details_provider.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../constants.dart';
import '../../models/auth/user_info_model.dart';
import '../my_vivadoo_providers/auth/generate_signature.dart';
class PostNewAdProvider with ChangeNotifier{
  List<String> photosIds = [];
  bool postNewAdLoading = false;

  bool adInProgress = false;


  void addPhotosToHive(List<XFile> newPhotos) {
    var box = HiveStorageManager.getNewAdModel();
    NewAdModel? ad = box.get('ad') ?? NewAdModel();
    ad.photos ??= [];
    ad.photos!.addAll(newPhotos.map((photo) => photo.path).toList());
    box.put('ad', ad);
  }

  void removePhotoFromHive(XFile photoToRemove) {
    var box = HiveStorageManager.getNewAdModel();
    NewAdModel? ad = box.get('ad');
    if (ad == null || ad.photos == null) return;
    ad.photos!.removeWhere((path) => path == photoToRemove.path);
    box.put('ad', ad);
  }


  List<XFile> getPhotosAsXFile(NewAdModel newAdModel) {
    return newAdModel.photos?.map((path) => XFile(path)).toList() ?? [];
  }

  void updateAdField(String key, dynamic value) {
    var box = HiveStorageManager.getNewAdModel();

    // Retrieve the current NewAdModel object from the box
    NewAdModel? ad = box.get('ad') ?? NewAdModel();

    // Use a switch to update the correct field
    switch (key) {
      case 'name':
        ad.name = value as String?;
        break;
      case 'title':
        ad.title = value as String?;
        break;
      case 'description':
        ad.description = value as String?;
        break;
      case 'location':
        ad.location = value as String?;
        break;
      case 'category':
        ad.category = value as String?;
        break;
      case 'price':
        ad.price = value as String?;
        break;
      case 'currency':
        ad.currency = value as String?;
        break;
      case 'email':
        ad.email = value as String?;
        break;
      case 'phone':
        ad.phone = value as String?;
        break;
      case 'emailActive':
        ad.emailActive = value as String?;
        break;
      case 'phoneActive':
        ad.phoneActive = value as String?;
        break;
      case 'metaFields':
        ad.metaFields = value as String?;
        break;
      case 'pseudo':
        ad.pseudo = value as String?;
        break;
      case 'photos':
        ad.photos = value as List<String>?;
        break;
      case 'categoryLink':
        ad.categoryLink = value as String?;
        break;
      case 'locationLink':
        ad.locationLink = value as String?;
        break;
      default:
        print("Field $key is not recognized.");
        return;
    }

    // Save the updated object back to the box
    box.put('ad', ad);
  }

  // To retrieve the whole object
  NewAdModel? getAd() {
    var box = HiveStorageManager.getNewAdModel();
    return box.get('ad');
  }

  getAdOldData(BuildContext context){
    NewAdModel newAdModel = getAd() ?? NewAdModel();
    HiveStorageManager.getNewAdModel().clear();
    context.read<AddPhotosProvider>().setImageList(context, getPhotosAsXFile(newAdModel));
    context.read<CategoryAndLocationProvider>().setCategoryLabel(newAdModel.category ?? "");
    context.read<CategoryAndLocationProvider>().categoryLink = newAdModel.categoryLink ?? "";
    context.read<CategoryAndLocationProvider>().setLocationLabel(newAdModel.location ?? "");
    context.read<CategoryAndLocationProvider>().locationLink = newAdModel.locationLink ?? "";
    context.read<NewAdDetailsProvider>().adTitleController.text = newAdModel.title ?? "";
    context.read<NewAdDetailsProvider>().adPriceController.text = newAdModel.price ?? "";
    context.read<NewAdDetailsProvider>().adDescriptionController.text = newAdModel.description ?? "";
    context.read<AdPosterInformationProvider>().nameController.text = newAdModel.name ?? "";
    context.read<AdPosterInformationProvider>().emailController.text = newAdModel.email ?? "";
    context.read<AdPosterInformationProvider>().phoneController.text = newAdModel.phone ?? "";
  }
  removeAdOldData(){
    HiveStorageManager.getNewAdModel().clear();
  }



  setPostNewAdLoading(bool value){
    postNewAdLoading = value;
    notifyListeners();
  }

  Future<void> uploadImages(BuildContext context) async {
    final userInfoBox = HiveStorageManager.getUserInfoModel();
    UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
    List<XFile> imageList = context.read<AddPhotosProvider>().imageList;
    XFile? mainPicture = context.read<AddPhotosProvider>().mainPicture;
    Uri url = Uri.https(
      Constants.authority,
      Constants.uploadPhotoPath,
    );
    for(int i=0 ; i < imageList.length ; i++){
      Map<String, String> data = {
        'id' : "",
        'order' : i.toString(),
        'main' : mainPicture == imageList[i] ? "1" : "0"
      };
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', imageList[i].path));
      request.fields.addAll(data);
      http.StreamedResponse response = await request.send();
      if(response.statusCode == 200){
        String str = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(str);
        bool success = jsonResponse['success'] == 1;
        if(success){
          String uniqueId = jsonResponse['image']['unique_id'];
          photosIds.add(uniqueId);
        }else{
          if(context.mounted){
            PopUps.somethingWentWrong(context);
          }
        }
        //flutter: {success: 1, image: {name: phpR9I9Wj_image_picker_F333A6B0-D4A6-4D99-ABFB-A677E018F449-4970-0000097A67EFA53B.jpg, size: 3936925, extension: jpeg, original: public/uploads/temp/full_b092f6e117611857bd4f63ffbd23cae5991040c85fff86841a428a8b37793428554eef64.jpeg, thumb: public/uploads/temp/thumb_b092f6e117611857bd4f63ffbd23cae5991040c85fff86841a428a8b37793428554eef64.jpeg, main: public/uploads/temp/main_b092f6e117611857bd4f63ffbd23cae5991040c85fff86841a428a8b37793428554eef64.jpeg, unique_id: b092f6e117611857bd4f63ffbd23cae5991040c85fff86841a428a8b37793428554eef64, prediction: [cars]}}
      }else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    }
  }

  Future<String> checkEmailActive(BuildContext context) async {
    String email = context.read<AdPosterInformationProvider>().emailController.text;
    Uri url = Uri.https(
      Constants.authority,
      Constants.checkEmailActivePath,
      {'username' : email}
    );
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var extractedData = jsonDecode(response.body);
      return extractedData['taken'].toString();
    }else{
      print(response.reasonPhrase);
      return "0";
    }
  }


  Future<void> postNewAd(BuildContext context) async {
    setPostNewAdLoading(true);
    await uploadImages(context);
    String title = "";
    String description = "";
    String emailActive = "";
    if(context.mounted){
      title = context.read<NewAdDetailsProvider>().adTitleController.text;
      description = context.read<NewAdDetailsProvider>().adDescriptionController.text;
      emailActive = await checkEmailActive(context);
    }

    Uri url = Uri.https(
      Constants.authority,
      Constants.userAdsListPath,
    );
    var headers = {
      'User-Agent' : 'vivadoo app',

    };
    Map<String, dynamic> body = {
      'title' : title,
      'description' : description,
      'emailActive' : emailActive,

    };
    AppSignature.generateAuthorization(headers, 'POST', url.toString());

  }
}