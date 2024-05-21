class SubCategoryModel{
  int id;
  String cat_link;
  String cat_link_parent;
  String name;
  int parent;
  String color;
  String label;
  List<dynamic>? children;

  SubCategoryModel({
      required this.id,
      required this.cat_link,
      required this.cat_link_parent,
      required this.name,
      required this.parent,
      required this.color,
      required this.label,
      this.children,
      });

  factory SubCategoryModel.fromJson(Map<String , dynamic> json){
    return SubCategoryModel(
        id: json['id'],
        cat_link: json['cat_link'],
        cat_link_parent: json['cat_link_parent'],
        name: json['name'],
        parent: json['parent'],
        color: json['color'],
        label: json['color'],
        children: json['children'] ?? [],
    );
  }

  @override
  String toString() {
    return 'SubCategoryModel{id: $id, cat_link: $cat_link, cat_link_parent: $cat_link_parent, name: $name, parent: $parent, color: $color, label: $label, children: $children}';
  }
}