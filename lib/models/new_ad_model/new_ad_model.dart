
import 'package:hive_flutter/adapters.dart';

part "new_ad_model.g.dart";

@HiveType(typeId: 2)
class NewAdModel extends HiveObject{
  @HiveField(0)
  List<String>? photos;
  @HiveField(1)
  String? location;
  @HiveField(2)
  String? category;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? price;
  @HiveField(5)
  String? currency;
  @HiveField(6)
  String? description;
  @HiveField(7)
  String? name;
  @HiveField(8)
  String? email;
  @HiveField(9)
  String? phone;
  @HiveField(10)
  String? emailActive;
  @HiveField(11)
  String? phoneActive;
  @HiveField(12)
  String? metaFields;
  @HiveField(13)
  String? pseudo;
  @HiveField(14)
  String? categoryLink;
  @HiveField(15)
  String? locationLink;

  NewAdModel({
     this.photos,
     this.location,
     this.category,
     this.title,
     this.price,
     this.currency,
     this.description,
     this.name,
     this.email,
     this.phone,
     this.emailActive,
     this.phoneActive,
     this.metaFields,
     this.pseudo,
    this.categoryLink,
    this.locationLink,
  });

  @override
  String toString() {
    return 'NewAdModel{photos: ${photos?.length}, location: $location, category: $category, title: $title, price: $price, currency: $currency, description: $description, name: $name, email: $email, phone: $phone, emailActive: $emailActive, phoneActive: $phoneActive, metaFields: $metaFields, pseudo: $pseudo, categoryLink: $categoryLink, locationLink: $locationLink}';
  }
}