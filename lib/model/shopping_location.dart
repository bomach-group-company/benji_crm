class ShoppingLocationCountry {
  final int id;
  final String countryName;
  final String countryCode;

  ShoppingLocationCountry({
    required this.id,
    required this.countryName,
    required this.countryCode,
  });

  factory ShoppingLocationCountry.fromJson(Map<String, dynamic>? json) {
    json ??= {'countryCode':{}};
    return ShoppingLocationCountry(
      id: json['id'] ?? 0,
      countryName: json['countryCode']['name'] ?? '',
      countryCode: json['countryCode']['code'] ?? '',
    );
  }
}

class ShoppingLocationState {
  final String stateName;
  final String stateCode;

  ShoppingLocationState({
    required this.stateName,
    required this.stateCode,
  });

  factory ShoppingLocationState.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ShoppingLocationState(
      stateName: json['stateName'] ?? '',
      stateCode: json['stateCode'] ?? '',
    );
  }
}


class ShoppingLocationCity {
  final String cityName;
  final String cityCode;

  ShoppingLocationCity({
    required this.cityName,
    required this.cityCode,
  });

  factory ShoppingLocationCity.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ShoppingLocationCity(
      cityName: json['cityName'] ?? '',
      cityCode: json['cityCode'] ?? '',
    );
  }
}
