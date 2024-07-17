class AdsCount {
  final int count;
  final int countCat;
  final Map<String, dynamic> categories;

  AdsCount({required this.count, required this.countCat, required this.categories});

  factory AdsCount.fromJson(Map<String, dynamic> json) {
    return AdsCount(
      count: json['count'],
      countCat: json['count_cat'],
      categories: json['categories'] is List ? {} : json['categories'],
    );
  }

  @override
  String toString() {
    return 'AdsCount{count: $count, countCat: $countCat, categories: $categories}';
  }
}
