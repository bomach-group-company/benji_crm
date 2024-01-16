class CountryModel {
  String name;
  String code;

  CountryModel({
    required this.name,
    required this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CountryModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }

  static List<CountryModel> listFromJson(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => CountryModel.fromJson(json)).toList();
  }
}
