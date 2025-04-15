import 'package:vivadoo/models/user_pro_model.dart';

class AdDetailsModel {
  final int? id;
  List<Map<String, dynamic>> images;
  String? publicLink;
  String? longLink;
  final String? title;
  String? postBy;
  final String? price;
  int? postViews;
  String? currency;
  bool? contactByMail;
  bool? hasChat;
  bool? contactByPhone;
  String? contactPhone;
  String? description;
  String? dirDescription;
  String? category;
  final String? location;
  String? date;
  final String? priceFormatted;
  List<Map<String, dynamic>>? metafields;
  int? userIsPro;
  int? count;
  String? since;
  UserProModel? userProModel;
  AdDetailsModel({
    this.id,
    required this.images,
    this.publicLink,
    this.longLink,
    this.title,
    this.postBy,
    this.price,
    this.postViews,
    this.currency,
    this.contactByMail,
    this.hasChat,
    this.contactByPhone,
    this.contactPhone,
    this.description,
    this.dirDescription,
    this.category,
    this.location,
    this.date,
    this.priceFormatted,
    this.metafields,
    this.userIsPro,
    this.count,
    this.since,
    this.userProModel
  });

  factory AdDetailsModel.fromJson(Map<String, dynamic> json) {
    return AdDetailsModel(
      images: List<Map<String, dynamic>>.from(json['images']),
      publicLink: json['public_link'] ?? "",
      longLink: json['long_link'] ?? "",
      title: json['title'] ?? "",
      postBy: json['postBy'] ?? "",
      price: json['price'] ?? "",
      postViews: json['postViews'],
      currency: json['currency'] ?? "",
      contactByMail: json['contactByMail'],
      hasChat: json['hasChat'],
      contactByPhone: json['contactByPhone'],
      contactPhone: json['contactPhone'] ?? "",
      description: json['description'] ?? "",
      dirDescription: json['dirDescription'] ?? "",
      category: json['category'] ?? "",
      location: json['location'] ?? "",
      date: json['date'] ?? "",
      priceFormatted: json['priceFormated'] ?? "",
      metafields: List<Map<String, dynamic>>.from(json['metafields']),
      userIsPro: json['userIsPro'],
      count: json['count'],
      since: json['since'] ?? "",
      userProModel: UserProModel.fromJson(json['userPro'] ?? {}),
    );
  }

  AdDetailsModel copyWith({
    int? id,
    List<Map<String, dynamic>>? images,
    String? publicLink,
    String? longLink,
    String? title,
    String? postBy,
    String? price,
    int? postViews,
    String? currency,
    bool? contactByMail,
    bool? hasChat,
    bool? contactByPhone,
    String? contactPhone,
    String? description,
    String? dirDescription,
    String? category,
    String? location,
    String? date,
    String? priceFormatted,
    List<Map<String, dynamic>>? metafields,
    int? userIsPro,
    int? count,
    String? since,
  }) {
    return AdDetailsModel(
      id: id ?? this.id,
      images: images ?? this.images,
      publicLink: publicLink ?? this.publicLink,
      longLink: longLink ?? this.longLink,
      title: title ?? this.title,
      postBy: postBy ?? this.postBy,
      price: price ?? this.price,
      postViews: postViews ?? this.postViews,
      currency: currency ?? this.currency,
      contactByMail: contactByMail ?? this.contactByMail,
      hasChat: hasChat ?? this.hasChat,
      contactByPhone: contactByPhone ?? this.contactByPhone,
      contactPhone: contactPhone ?? this.contactPhone,
      description: description ?? this.description,
      dirDescription: dirDescription ?? this.dirDescription,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      priceFormatted: priceFormatted ?? this.priceFormatted,
      metafields: metafields ?? this.metafields,
      userIsPro: userIsPro ?? this.userIsPro,
      count: count ?? this.count,
      since: since ?? this.since,
    );
  }

  @override
  String toString() {
    return 'AdDetailsModel{id: $id, images: $images, publicLink: $publicLink, longLink: $longLink, title: $title, postBy: $postBy, price: $price, postViews: $postViews, currency: $currency, contactByMail: $contactByMail, hasChat: $hasChat, contactByPhone: $contactByPhone, contactPhone: $contactPhone, description: $description, dirDescription: $dirDescription, category: $category, location: $location, date: $date, priceFormatted: $priceFormatted, metafields: $metafields, userIsPro: $userIsPro, count: $count, since: $since}';
  }
}
