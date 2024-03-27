import 'dart:convert';

import 'package:benji_aggregator/src/providers/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

Future<List> parseLatLng(String newLocation) async {
  if (kIsWeb) {
    Uri uri = Uri.https("maps.googleapis.com", '/maps/api/geocode/json',
        {"address": newLocation, "key": googlePlacesApiKey});

    var resp = await http.get(uri);
    Map<String, dynamic> decodedResponse = jsonDecode(resp.body);

    if (decodedResponse['status'] == 'OK') {
      List<dynamic> results = decodedResponse['results'];

      if (results.isNotEmpty) {
        Map<String, dynamic> location = results[0]['geometry']['location'];

        double latitude = location['lat'];
        double longitude = location['lng'];

        return [latitude.toString(), longitude.toString()];
      } else {
        return [null, null];
      }
    } else {
      return [null, null];
    }
  } else {
    List<Location> location = await locationFromAddress(newLocation);
    String latitude = location[0].latitude.toString();
    String longitude = location[0].longitude.toString();
    return [latitude.toString(), longitude.toString()];
  }
}
