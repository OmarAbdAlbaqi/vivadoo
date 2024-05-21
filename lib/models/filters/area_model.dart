class AreaModel{
  int code;
  bool hasNext;
  String label;
  String link;
  String parentLabel;

  AreaModel({
    required this.code,
    required this.hasNext,
    required this.label,
    required this.link,
    required this.parentLabel,
  });
  factory AreaModel.fromJson(Map<String , dynamic> json){
    return AreaModel(
        code: json['code'],
        hasNext: json['hasNext'],
        label: json['label'],
        link: json['link'],
        parentLabel: json['parentLabel']);
  }

  @override
  String toString() {
    return 'AreaModel{code: $code, hasNext: $hasNext, label: $label, parentLabel: $parentLabel}';
  }
}