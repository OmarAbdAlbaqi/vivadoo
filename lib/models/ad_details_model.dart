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
  });

  factory AdDetailsModel.fromJson(Map<String, dynamic> json) {
    return AdDetailsModel(
      images: List<Map<String, dynamic>>.from(json['images']),
      publicLink: json['public_link']??"",
      longLink: json['long_link']??"",
      title: json['title']??"",
      // status: json['status'],
      postBy: json['postBy']??"",
      price: json['price']??"",
      postViews: json['postViews'],
      currency: json['currency']??"",
      contactByMail: json['contactByMail'],
      hasChat: json['hasChat'],
      contactByPhone: json['contactByPhone'],
      contactPhone: json['contactPhone']??"",
      description: json['description']??"",
      dirDescription: json['dirDescription']??"",
      category: json['category']??"",
      location: json['location']??"",
      date: json['date'] ?? "",
      priceFormatted: json['priceFormated']??"",
      metafields: List<Map<String, dynamic>>.from(json['metafields']),
      userIsPro: json['userIsPro'],
      count: json['count'],
      since: json['since'] ?? "",
    );
  }

  @override
  String toString() {
    return 'AdDetailsModel{id: $id, title: $title}';
  }
}
