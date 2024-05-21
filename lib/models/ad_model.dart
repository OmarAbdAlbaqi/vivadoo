class AdModel{
  int id;
  String long_link;
  String title;
  String thumb;
  String category;
  String location;
  String date;
  String price;
  int photos;
  bool contactByMail;
  bool hasChat;
  bool contactByPhone;
  String contactPhone;
  bool isMobile;
  bool isJob;
  int userIsPro;
  Map<String, dynamic> userPro;
  String externalLink;
  String typeAd;
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
    return 'AdModel{id: $id, long_link: $long_link, title: $title, thumb: $thumb, category: $category, location: $location, date: $date, price: $price, photos: $photos, contactByMail: $contactByMail, hasChat: $hasChat, contactByPhone: $contactByPhone, contactPhone: $contactPhone, isMobile: $isMobile, isJob: $isJob, externalLink: $externalLink, typeAd: $typeAd, adFeatured: $adFeatured}';
  }
}