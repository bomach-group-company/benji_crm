import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class AppVersion {
  final String version;
  final String app;
  final String link;
  final String details;
  final String releaseDate;

  AppVersion({
    required this.version,
    required this.app,
    required this.link,
    required this.details,
    required this.releaseDate,
  });

  factory AppVersion.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return AppVersion(
      version: json['version'] ?? "0",
      app: json['app'] ?? notAvailable,
      link: json['link'] ?? notAvailable,
      details: json['details'] ?? notAvailable,
      releaseDate: json['release_date'] ?? notAvailable,
    );
  }
}

Future<AppVersion> getAppLatestVersion() async {
  String os = "";
  String app = "crm";
  if (Platform.isAndroid) {
    os = "android";
  } else if (Platform.isIOS) {
    os = "ios";
  } else {
    return AppVersion.fromJson(null);
  }

  var url = "${Api.baseUrl}/app-version/getLatestAppVersion/$os/$app";
  print(url);
  try {
    http.Response response =
        await http.get(Uri.parse(url), headers: authHeader());
    print(response.body);
    return AppVersion.fromJson(jsonDecode(response.body));
  } catch (e) {
    print(e);
  }
  return AppVersion.fromJson(null);
}
