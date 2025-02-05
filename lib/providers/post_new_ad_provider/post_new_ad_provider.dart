import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/new_ad_model/new_ad_model.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/ad_poster_information_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/add_photos_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/category_and_location_provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/pages_providers/new_ad_details_provider.dart';
import 'package:vivadoo/tsting.dart';
import 'package:vivadoo/utils/hive_manager.dart';
import 'package:http/http.dart' as http;
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../constants.dart';
import '../../models/auth/user_info_model.dart';
import '../home_providers/filters/filter_provider.dart';
import '../my_vivadoo_providers/auth/generate_signature.dart';
final GlobalKey<ScaffoldState> scaffoldKeyPostNewAd = GlobalKey<ScaffoldState>();
class PostNewAdProvider with ChangeNotifier{
  List<String> photosIds = [];
  bool postNewAdLoading = false;

  bool adInProgress = false;

  PersistentBottomSheetController? bottomSheetController;
  String step = "send code";

  // startThePhoneNumberVerificationProcess(BuildContext context){
  //   switch(step){
  //     case "send code" : {
  //       _showBottomSheetPhoneNumberVerification(context, Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.height * 0.78,
  //         decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(24),
  //                 topRight: Radius.circular(24))),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Container(
  //               width: double.infinity,
  //               height: 65,
  //               decoration: const BoxDecoration(
  //                   border: Border(
  //                       bottom: BorderSide(
  //                           color: Colors.black, width: 0.2)),
  //                   color: Color.fromRGBO(235, 236, 247, 1),
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(24),
  //                       topRight: Radius.circular(24))),
  //               alignment: Alignment.center,
  //               child: const Text(
  //                 "Send a code",
  //                 style: TextStyle(
  //                     fontSize: 16, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //
  //             SingleChildScrollView(
  //               child: SizedBox(
  //                 width: double.infinity,
  //                 height: (MediaQuery.of(context).size.height * 0.78 )- 65,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     const Icon(Icons.mobile_off_outlined, color: Colors.red,size: 60,),
  //                     const Text("Your phone number is not verified yet\nPlease press VERIFY to send a verification code to your phone number", textAlign: TextAlign.center,),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         bottomSheetController?.close();
  //                       },
  //                       style: ButtonStyle(
  //                         padding: WidgetStateProperty.all<EdgeInsets?>(
  //                             const EdgeInsets.symmetric(horizontal: 20)
  //                         ),
  //                         minimumSize: WidgetStateProperty.all<Size?>(
  //                             Size( (MediaQuery.of(context).size.width -40 ) /2 , 45)),
  //                         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             side: const BorderSide(
  //                               color: Color.fromRGBO(0, 128, 0, 1),
  //                               width: 2,
  //                             ),
  //                           ),
  //                         ),
  //                         alignment: Alignment.center,
  //                         animationDuration: const Duration(milliseconds: 500),
  //                         backgroundColor: getColor(const Color.fromRGBO(0, 128, 0, 1), Colors.white),
  //                         foregroundColor: getColor(Colors.white, const Color.fromRGBO(0, 128, 0, 1)),
  //                       ),
  //                       child: const Text(
  //                         "VERIFY",
  //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  //       break;
  //     }
  //   }
  // }
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

  //
  // Future<String> sendTheVerificationCode(BuildContext context) async {
  //   Map<String, dynamic> params = {"phone" : "81333541"};
  //   Uri url = Uri.https(
  //     Constants.authority,
  //     Constants.sendCodePath,
  //     params
  //   );
  //   // Uri url = Uri.parse("https://www.vivadoo.com/en/classifieds/api-secure/send-code?phone=81347855");
  //   // var headers = {
  //   //   'User-Agent' : 'vivadoo app',
  //   // };
  //   // AppSignature.generateAuthorization(headers, 'GET', url.toString());
  //   // print(headers);
  //   final userInfoBox = HiveStorageManager.getUserInfoModel();
  //   UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
  //   Map<String, String> headers = AppSignature2.generateHeaders(
  //     method: 'GET',
  //     fullUrl: url.toString(),
  //     secretKey: user.key,
  //     publicKey: user.token,
  //     username: user.emailAddress,
  //   );
  //   // print(user.key);
  //   // print(user.token);
  //   // print(user.emailAddress);
  //   http.Response response = await http.get(url, headers: headers).timeout(const Duration(seconds : 10));
  //   var jsonResponse = jsonDecode(response.body);
  //   print(jsonResponse.toString());
  //   // if(response.statusCode == 200){
  //   //   bool success = jsonResponse['success'] == 1;
  //   //   if(success){
  //   //     print(jsonResponse.toString());
  //   //   }else{
  //   //     if(context.mounted){
  //   //       PopUps.somethingWentWrong(context);
  //   //     }
  //   //   }
  //   // }
  //   return "";
  // }
  //
  // void _showBottomSheetPhoneNumberVerification(BuildContext context, Widget child, [bool done = false]) {
  //   // context.read<StepsBarWidgetProvider>().setIsBottomSheetOpen(true);
  //   bottomSheetController = scaffoldKeyPostNewAd.currentState
  //       ?.showBottomSheet((ctx) => child);
  //
  //   bottomSheetController?.closed.whenComplete(() {
  //     while(!done){
  //       if(context.mounted){
  //         startThePhoneNumberVerificationProcess(context);
  //       }
  //     }
  //   });
  // }

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
    List<XFile> imageList = context.read<AddPhotosProvider>().imageList;
    XFile? mainPicture = context.read<AddPhotosProvider>().mainPicture;
    Uri url = Uri.https(
      Constants.authority,
      Constants.uploadPhotoPath,
    );
    var headers = {
      'User-Agent' : 'vivadoo app',
    };
    AppSignature.generateAuthorization(headers, 'POST', url.toString());
    for(int i=0 ; i < imageList.length ; i++){
      Map<String, String> data = {
        'id' : "",
        'order' : i.toString(),
        'main' : mainPicture == imageList[i] ? "1" : "0"
      };

      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', imageList[i].path));
      request.fields.addAll(data);
      request.headers.addAll(headers);
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
    String phoneActive = "";
    String email = "";
    String phone = "";
    String pseudo = "";
    String price = "";
    String currency = "";
    String category = "";
    String location = "";
    String photos = "";
    String metaields = "";
    Map<String, dynamic> params = {};
    if(context.mounted){
      location = context.read<CategoryAndLocationProvider>().locationLink;
      category = context.read<CategoryAndLocationProvider>().categoryLink;
      params = context.read<FilterProvider>().filterParams;
      params.remove('maxResults');
      params.remove('page');
      params.remove('governorate');

      title = context.read<NewAdDetailsProvider>().adTitleController.text;
      price = context.read<NewAdDetailsProvider>().adPriceController.text;
      currency = context.read<NewAdDetailsProvider>().currencyIsLbp ? "LBP" : "USD";
      description = context.read<NewAdDetailsProvider>().adDescriptionController.text;

      pseudo = context.read<AdPosterInformationProvider>().nameController.text;
      email = context.read<AdPosterInformationProvider>().emailController.text;
      phone = context.read<AdPosterInformationProvider>().phoneController.text;

      phoneActive = context.read<AdPosterInformationProvider>().hideMyPhoneNumber ? "0" : "1";
      emailActive = context.read<AdPosterInformationProvider>().enableChatForThisAd ? "1" : "0";

      photos = photosIds.toString();
      metaields = params.toString();
    }

    Uri url = Uri.https(
      Constants.authority,
      Constants.postNewAdPath,
    );
    final userInfoBox = HiveStorageManager.getUserInfoModel();
    UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
    Map<String, String> headers = AppSignature2.generateHeaders(
      method: 'POST',
      fullUrl: url.toString(),
      secretKey: user.key,
      publicKey: user.token,
      username: user.emailAddress,
    );
    print(photosIds.toString());
    Map<String, dynamic> body = {
      'title' : title,
      'description' : description,
      'emailActive' : emailActive,
      'phoneActive' : phoneActive,
      'email' : email,
      'phone' : phone,
      'pseudo' : pseudo,
      'price' : price,
      'currency' : currency,
      'category' : category,
      'location' : location,
      'photos' : photos,
      'metafields' : metaields,
    };
    print(headers);
    // AppSignature.generateAuthorization(headers, 'POST', url.toString());
    try {
      print(url);
      http.Response response = await http.post(url, body: body, headers: headers).timeout(const Duration(seconds: 10));
      var extractedData = jsonDecode(response.body);
      print("The response is ${extractedData.toString()}");
      if(response.statusCode == 200){
        bool success = extractedData['success'] == 1;
        if(success){
        }else{
          if(extractedData['message'].contains("Phone number not verified")){
            if(context.mounted){
              PopUps.verifyPhoneNumber(context);
            }
          }else{
            if(context.mounted){
              PopUps.apiError(context, extractedData);
            }
          }
        }
      }else{
        if(context.mounted){
          PopUps.apiError(context, response.reasonPhrase.toString());
        }
      }
    } catch (e) {
      print("catch $e");
      if(context.mounted){
        PopUps.somethingWentWrong(context);
      }
    } finally {
      setPostNewAdLoading(false);
    }

  }


  String verificationCode = "";
  Future<void> verifyPhoneNumber(BuildContext context) async {

    String phone = context.read<AdPosterInformationProvider>().phoneController.text;
    print(verificationCode);
    if(verificationCode.length != 4){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill all the fields" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.orange,
      ));
    }else{
      setPostNewAdLoading(true);
      Map<String , dynamic> params = {
        "phone" : phone,
        "code": verificationCode
      };
      Uri url = Uri.https(
        Constants.authority,
        Constants.sendCodePath,
        params
      );
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text("$phone $verificationCode" , style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.orange,
      ));
      try{
        final userInfoBox = HiveStorageManager.getUserInfoModel();
        UserInfoModel user = userInfoBox.values.toList().cast<UserInfoModel>()[0];
        Map<String, String> headers = AppSignature2.generateHeaders(
          method: 'GET',
          fullUrl: url.toString(),
          secretKey: user.key,
          publicKey: user.token,
          username: user.emailAddress,
        );
        final response = await http.get(url , headers: headers).timeout(const Duration(seconds: 10));
        var extractedData = jsonDecode(response.body);
        if(response.statusCode == 200){
          bool success = extractedData['success'] == 1;
          if(success){
            if(context.mounted){
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Phone Number Verified Successfully!" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),),
                backgroundColor: Constants.orange,
              ));
            }
          } else {
            if(context.mounted){
              PopUps.apiError(context , extractedData.toString());
            }
          }
        }else{
          if(context.mounted){
            PopUps.apiError(context, response.reasonPhrase.toString());
          }
        }
      } catch (e){
        if(context.mounted){
          PopUps.apiError(context, e.toString());
        }
      } finally{
        setPostNewAdLoading(false);
      }
    }

  }



}