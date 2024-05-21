
import 'package:hive_flutter/adapters.dart';

part "local_area_model.g.dart";

@HiveType(typeId: 0)
class LocalAreaModel extends HiveObject{
  @HiveField(0)
  int code;
  @HiveField(1)
  bool hasNext;
  @HiveField(2)
  String label;
  @HiveField(3)
  String parentLabel;
  @HiveField(4)
  String link;

  LocalAreaModel({
    required this.code,
    required this.hasNext,
    required this.label,
    required this.parentLabel,
    required this.link,
  });


  factory LocalAreaModel.fromJson(Map<String , dynamic> json){
    return LocalAreaModel(
        code: json['code'],
        hasNext: json['hasNext'],
        label: json['label'],
        parentLabel: json['parentLabel'],
        link: json['link'],
    );
  }

}