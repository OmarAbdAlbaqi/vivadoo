class AdDetailsModel {
  final List<Map<String, dynamic>> images;
  final String publicLink;
  final String longLink;
  final String title;
  // final int status;
  final String postBy;
  final String price;
  final int postViews;
  final String currency;
  final bool contactByMail;
  final bool hasChat;
  final bool contactByPhone;
  final String contactPhone;
  final String description;
  final String dirDescription;
  final String category;
  final String location;
  // final bool isMobile;
  final String date;
  final String priceFormatted;
  final List<Map<String, dynamic>> metafields;
  final int userIsPro;
  final int count;
  final String since;

  AdDetailsModel({
    required this.images,
    required this.publicLink,
    required this.longLink,
    required this.title,
    // required this.status,
    required this.postBy,
    required this.price,
    required this.postViews,
    required this.currency,
    required this.contactByMail,
    required this.hasChat,
    required this.contactByPhone,
    required this.contactPhone,
    required this.description,
    required this.dirDescription,
    required this.category,
    required this.location,
    // required this.isMobile,
    required this.date,
    required this.priceFormatted,
    required this.metafields,
    required this.userIsPro,
    required this.count,
    required this.since,
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
      // isMobile: json['isMobile'],
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
    return 'AdDetailsModel {publicLink: $publicLink,\nlongLink: $longLink, \ntitle: $title,\npostBy: $postBy,\nprice: $price,\npostViews: $postViews,\ncurrency: $currency,\ncontactByMail: $contactByMail,\nhasChat: $hasChat,\ncontactByPhone: $contactByPhone,\ncontactPhone: $contactPhone,\ndescription: $description,\ndirDescription: $dirDescription,\ncategory: $category,\nlocation: $location,\ndate: $date,\npriceFormatted: $priceFormatted,\nmetafields: $metafields,\nuserIsPro: $userIsPro,\ncount: $count,\nsince: $since }';
  }
}
