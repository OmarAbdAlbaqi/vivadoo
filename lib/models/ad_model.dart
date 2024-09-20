import 'package:hive_flutter/adapters.dart';
part "ad_model.g.dart";

@HiveType(typeId: 3)
class AdModel extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String long_link;
  @HiveField(2)
  String title;
  @HiveField(3)
  String thumb;
  @HiveField(4)
  String category;
  @HiveField(5)
  String location;
  @HiveField(6)
  String date;
  @HiveField(7)
  String price;
  @HiveField(8)
  int photos;
  @HiveField(9)
  bool contactByMail;
  @HiveField(10)
  bool hasChat;
  @HiveField(11)
  bool contactByPhone;
  @HiveField(12)
  String contactPhone;
  @HiveField(13)
  bool isMobile;
  @HiveField(14)
  bool isJob;
  @HiveField(15)
  int userIsPro;
  @HiveField(16)
  Map<String, dynamic> userPro;
  @HiveField(17)
  String externalLink;
  @HiveField(18)
  String typeAd;
  @HiveField(19)
  bool adFeatured;

  AdModel({
      required this.id,
      required this.long_link,
      required this.title,
      required this.thumb,
      required this.category,
      required this.location,
      required this.date,
      required this.price,
      required this.photos,
      required this.contactByMail,
      required this.hasChat,
      required this.contactByPhone,
      required this.contactPhone,
      required this.isMobile,
      required this.isJob,
      required this.userIsPro,
      required this.externalLink,
      required this.userPro,
      required this.typeAd,
      required this.adFeatured,
  });

  factory AdModel.fromJson(Map<String , dynamic> json){
    return AdModel(
        id: json['id'],
        long_link: json['long_link'],
        title: json['title'],
        thumb: json['thumb'],
        category: json['category'],
        location: json['location'],
        date: json['date'],
        price: json['price'],
        photos: json['photos'],
        contactByMail: json['contactByMail'],
        hasChat: json['hasChat'],
        contactByPhone: json['contactByPhone'],
        contactPhone: json['contactPhone'],
        isMobile: json['isMobile'],
        isJob: json['isJob'],
        userIsPro: json['userIsPro'],
        userPro: json['userPro'] ?? {},
        externalLink: json['externalLink'],
        typeAd: json['typeAd'],
        adFeatured: json['adFeatured'],
    );}

  @override
  String toString() {
    return 'AdModel{title: $title}';
  }
}