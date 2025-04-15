class UserProModel {
  final String? companyName;
  final String? companyLogo;
  final String? companyCover;
  final String? companyRatings;
  final int? companyRatingsCount;
  final int? userId;
  final String? companyPhone;
  final String? companyWebsite;
  final String? companyAddress;
  final String? companyCity;
  final String? companyFacebook;
  final String? companyGoogle;
  final String? companyTwitter;
  final String? companyLinkedin;

  UserProModel({
    this.companyName,
    this.companyLogo,
    this.companyCover,
    this.companyRatings,
    this.companyRatingsCount,
    this.userId,
    this.companyPhone,
    this.companyWebsite,
    this.companyAddress,
    this.companyCity,
    this.companyFacebook,
    this.companyGoogle,
    this.companyTwitter,
    this.companyLinkedin,
  });

  factory UserProModel.fromJson(Map<String, dynamic> json) {
    return UserProModel(
      companyName: json['company_name'],
      companyLogo: json['company_logo'],
      companyCover: json['company_cover'],
      companyRatings: json['company_ratings'],
      companyRatingsCount: json['company_ratings_count'],
      userId: json['user_id'],
      companyPhone: json['company_phone'],
      companyWebsite: json['company_website'],
      companyAddress: json['company_address'],
      companyCity: json['company_city'],
      companyFacebook: json['company_facebook'],
      companyGoogle: json['company_google'],
      companyTwitter: json['company_twitter'],
      companyLinkedin: json['company_linkedin'],
    );
  }
}
