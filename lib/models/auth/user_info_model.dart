import 'package:hive_flutter/adapters.dart';
part "user_info_model.g.dart";

@HiveType(typeId: 1)
class UserInfoModel extends HiveObject{
  @HiveField(0)
  final String firstName;
  @HiveField(1)
  final String lastName;
  @HiveField(2)
  final String emailAddress;
  @HiveField(3)
  final String phoneNumber;
  @HiveField(4)
  final String token;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.token
});

  factory UserInfoModel.fromJson(Map<String, dynamic> json){
    return UserInfoModel(
        firstName: json['firstname'],
        lastName: json['lastname'],
        emailAddress: json['talebfadi@gmail.com'],
        phoneNumber: json['phone'],
        token: json['token']
    );
  }

  @override
  String toString() {
    return 'UserInfoModel{firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, phoneNumber: $phoneNumber, token: $token}';
  }
}