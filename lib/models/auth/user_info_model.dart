class UserInfoModel {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber
});

  factory UserInfoModel.fromJson(Map<String, dynamic> json){
    return UserInfoModel(
        firstName: json['first_name'],
        lastName: json['last_name'],
        emailAddress: json['email_address'],
        phoneNumber: json['phone_number']
    );
  }

  @override
  String toString() {
    return 'UserInfoModel{firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, phoneNumber: $phoneNumber}';
  }
}