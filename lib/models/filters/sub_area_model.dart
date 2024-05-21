class SubAreaModel{
  int code;
  bool hasNext;
  String label;
  String link;
  String parentLabel;

  SubAreaModel({
    required this.code,
    required this.hasNext,
    required this.label,
    required this.link,
    required this.parentLabel});

  factory SubAreaModel.fromJson(Map<String , dynamic> json){
    return SubAreaModel(
        code: json['code'],
        hasNext: json['hasNext'],
        label: json['label'],
        link: json['link'],
        parentLabel: json['parentLabel']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['hasNext'] = hasNext;
    data['label'] = label;
    data['link'] = link;
    data['parentLabel'] = parentLabel;
    return data;
  }

  @override
  String toString() {
    return 'SubAreaModel{label: $label}';
  }
}