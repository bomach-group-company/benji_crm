import 'dart:convert';

import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class RatingModel {
  final String id;
  final double ratingValue;
  final String comment;
  final DateTime created;
  final UserModel client;

  RatingModel({
    required this.id,
    required this.ratingValue,
    required this.comment,
    required this.created,
    required this.client,
  });

  factory RatingModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return RatingModel(
      id: json['id'] ?? notAvailable,
      ratingValue: json['rating_value'] ?? 0.0,
      comment: json['comment'] ?? notAvailable,
      created: json['created'] == null
          ? DateTime.now()
          : DateTime.parse(json['created']),
      client: UserModel.fromJson(json['client']),
    );
  }
}

Future<List<RatingModel>> getRatingsByVendorId(int id,
    {start = 0, end = 10}) async {
  // url to be changed to agent endpoint
  final response = await http.get(
    Uri.parse('$baseURL/vendors/$id/getAllVendorRatings?start=$start&end=$end'),
    headers: authHeader(),
  );
  (jsonDecode(response.body)['items'] as List)
      .map((item) => RatingModel.fromJson(item))
      .toList();
  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => RatingModel.fromJson(item))
        .toList();
  } else {
    return [];
  }
}

Future<List<RatingModel>> getRatingsByVendorIdAndRating(int id, int rating,
    {start = 0, end = 10}) async {
  // url to be changed to agent endpoint

  final response = await http.get(
    Uri.parse(
        '$baseURL/clients/filterVendorReviewsByRating/$id?rating_value=$rating'),
    headers: authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => RatingModel.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
