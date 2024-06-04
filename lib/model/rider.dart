import 'dart:convert';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class Rider {
  final int id;
  final String phone;
  final String username;
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String latitude;
  final String longitude;

  const Rider({
    required this.id,
    required this.username,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Rider.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Rider(
      id: json['id'] ?? 0,
      phone: json['phone'] ?? notAvailable,
      username: json['username'] ?? notAvailable,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      gender: json['gender'] ?? notAvailable,
      address: json['address'] ?? notAvailable,
      latitude: json['latitude'] ?? "0",
      longitude: json['longitude'] ?? "0",
    );
  }
}

Rider modelRider(data) {
  return Rider.fromJson(jsonDecode(data));
}

Future<List<Rider>> getAvailableRiders() async {
  var url = "${Api.baseUrl}/tasks/listAvailableRidersForTask";
  String token = UserController.instance.user.value.token;
  http.Response? response = await HandleData.getApi(url, token);
  var responseData = await ApiProcessorController.errorState(response);
  print(response!.body);
  if (responseData == null) {
    return [];
  }
  List<Rider> data = [];
  try {
    data = (jsonDecode(response.body) as List)
        .map((e) => Rider.fromJson(e))
        .toList();
    print('the rider data');
    print(data);
  } catch (e) {}
  return data;
}

Future<http.Response> assignTaskToRider(
    String itemType, String itemId, String driver) async {
  Map body = {
    'item_type': itemType,
    'item_id': itemId,
    'driver': driver,
  };
  final response = await http.post(
      Uri.parse('$baseURL/tasks/assignTaskToRider'),
      headers: authHeader(),
      body: jsonEncode(body));
  return response;
}
