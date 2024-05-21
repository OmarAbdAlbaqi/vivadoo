import 'package:vivadoo/models/filters/sub_category_model.dart';

class CategoryModel {
  int id;
  String cat_link;
  String name;
  String color;
  String icon;
  String label;
  String cat_type;
  List<SubCategoryModel> subCategoryModel;

  CategoryModel({
    required this.id,
    required this.cat_link,
    required this.name,
    required this.color,
    required this.icon,
    required this.label,
    required this.cat_type,
    required this.subCategoryModel,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> subCategoryJsonList = json['children'];
    List<SubCategoryModel> subCategoryModelList = subCategoryJsonList.map((subJson) => SubCategoryModel.fromJson(subJson)).toList();

    return CategoryModel(
      id: json['id'],
      cat_link: json['cat_link'],
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      label: json['label'],
      cat_type: json['cat_type'],
      subCategoryModel: subCategoryModelList,
    );
  }
}
