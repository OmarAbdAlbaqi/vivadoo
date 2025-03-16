import 'package:hive_flutter/adapters.dart';
part "user_info_model.g.dart";

@HiveType(typeId: 1)
class UserInfoModel extends HiveObject{
  @HiveField(0)
  late final String firstName;
  @HiveField(1)
  late final String lastName;
  @HiveField(2)
  final String emailAddress;
  @HiveField(3)
  late final String phoneNumber;
  @HiveField(4)
  final String token;
  @HiveField(5)
  final String key;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.token,
    required this.key
});

  factory UserInfoModel.fromJson(Map<String, dynamic> json){
    return UserInfoModel(
        firstName: json['firstname'],
        lastName: json['lastname'],
        emailAddress: json['username'],
        phoneNumber: json['phone'] ?? "",
        token: json['token'],
        key: json['key']
    );
  }

  @override
  String toString() {
    return 'UserInfoModel{firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, phoneNumber: $phoneNumber, token: $token, key: $key}';
  }
}