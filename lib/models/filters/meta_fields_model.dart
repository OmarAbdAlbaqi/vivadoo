class MetaFieldsModel{
  int id;
  String type;
  bool is_required;
  bool is_unique;
  bool is_searchable;
  List<dynamic> range;
  String name;
  List<dynamic> options;
  List<dynamic> categories;

  MetaFieldsModel({
      required this.id,
      required this.type,
      required this.is_required,
      required this.is_unique,
      required this.is_searchable,
      required this.range,
      required this.name,
      required this.options,
      required this.categories,
  });
  factory MetaFieldsModel.fromJson(Map<String , dynamic> json){
    return MetaFieldsModel(
        id: json['id'],
        type: json['type'],
        is_required: json['is_required'],
        is_unique: json['is_unique'],
        is_searchable: json['is_searchable'],
        range: json['range'],
        name: json['name'],
        options: json['options'],
        categories: json['categories'],
    );}

  @override
  String toString() {
    return 'MetaFieldsModel{name: $name, categories: $categories}';
  }
}