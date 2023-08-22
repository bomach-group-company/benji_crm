import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "https://benji-app.onrender.com";
  static const login = "/api/v1/auth/token";
  static const user = "/api/v1/auth/";
  static const notification = "/api/v1/agents/getAgentNotifications/";
//Vendor
  static const vendorList = "/api/v1/agents/listAllMyVendors";
  static const agentCreateVendor = "/api/v1/agents/agentCreateVendor";
  static const getSpecificVendor = "/api/v1/agents/getVendor/";
  static const getVendorProducts = "/api/v1/agents/listVendorProducts/";
  static const filterVendorProduct = "/api/v1/agents/filterVendorProductsBySubCategory";
  static const listVendorOrders = "/api/v1/agents/listVendorOrders/";
  static const getVendorRatings = "/api/v1/agents/getVendorAverageRating/";

  //Rider
    static const riderList = "/api/v1/agents/listAllRiders";
  static const getSpecificRider = "/api/v1/agents/getRider/";
  static const assignRiderTask = "/api/v1/agents/assignRiderTask";
}

String header = "application/json";
const content = "application/x-www-form-urlencoded";

class RequestData {
  static Future<http.Response?> postApi([
    String? url,
    String? token,
    dynamic body,
  ]) async {
    http.Response? response;
    try {
      if (token == null) {
        response = await http
            .post(
              Uri.parse(url!),
              headers: {
                HttpHeaders.contentTypeHeader: header,
                "Content-Type": content,
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20));
      } else {
        response = await http
            .post(
              Uri.parse(url!),
              headers: {
                HttpHeaders.contentTypeHeader: header,
                "Content-Type": content,
                HttpHeaders.authorizationHeader: "Bearer $token",
              },
              body: jsonEncode(body.toJson()),
            )
            .timeout(const Duration(seconds: 20));
      }

      consoleLog(response.body);
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future<http.Response?> getApi([
    String? url,
    String? token,
  ]) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(url!),
        headers: {
          HttpHeaders.contentTypeHeader: header,
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      consoleLog(response.body);
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future put() async {}

  static Future delete() async {}
}

void consoleLog(String val) {
  return debugPrint(val);
}
