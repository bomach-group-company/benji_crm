import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/create_vendor_model.dart';

// API URLS AND HTTP CALL FUNCTIONS
class Api {
  static const baseUrl = "https://benji-app.onrender.com";
  // static const baseUrl = "https://resource.bgbot.app/api/v1/docs#/";
  static const login = "/api/v1/auth/token";
  static const user = "/api/v1/auth/";
  static const notification = "/api/v1/agents/getAgentNotifications/";
//Vendor
  static const vendorList = "/api/v1/agents/listAllMyVendors";
  static const agentCreateVendor = "/api/v1/agents/agentCreateVendor";
  static const getSpecificVendor = "/api/v1/agents/getVendor/";
  static const getVendorProducts = "/api/v1/agents/listVendorProducts/";
  static const filterVendorProduct =
      "/api/v1/agents/filterVendorProductsBySubCategory";
  static const listVendorOrders = "/api/v1/agents/listVendorOrders/";
  static const getVendorRatings = "/api/v1/agents/getVendorAverageRating/";
  static const createVendor = "/api/v1/agents/agentCreateVendor/";

  //order
  static const orderList = "/api/v1/agents/getAllMyVendorsOrders/";

  //Rider
  static const riderList = "/api/v1/agents/listAllRiders";
  static const getSpecificRider = "/api/v1/agents/getRider/";
  static const assignRiderTask = "/api/v1/agents/assignOrdersToRider";
  static const riderHistory = "/api/v1/agents/ridersHistories/";

  //BusinessTypes
  static const businessType = "/api/v1/categories/list";
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
              body: jsonEncode(body),
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

      //  consoleLog(response.body);
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future put() async {}
  static Future delete() async {}

  static Future<http.StreamedResponse?> streamAddVCendor(
      url, token, SendCreateModel data, bool vendorClassifier) async {
    http.StreamedResponse? response;

    //  final filePhotoName = basename(data.image!.path);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Content-Type": content,
      'authorization': 'Bearer $token',
    };

    // var file = await http.MultipartFile.fromPath('image', data.image!.path,
    //     filename: filePhotoName);

    request.headers.addAll(headers);

    request.fields["email"] = data.businessEmail!.toString();
    request.fields["phone"] = data.businessPhone!.toString();
    request.fields["address"] = data.bussinessAddress!.toString();
    request.fields["shop_name"] = data.businessName!.toString();

    request.fields["shop_type"] = data.businessType!.toString();
    request.fields["weekOpeningHours"] = data.openHours!.toString();
    request.fields["weekClosingHours"] = data.closeHours!.toString();
    request.fields["satOpeningHours"] = data.satOpenHours!.toString();
    request.fields["satClosingHours"] = data.satCloseHours!.toString();
    request.fields["sunWeekOpeningHours"] = data.sunOpenHours!.toString();

    request.fields["sunWeekClosingHours"] = data.sunCloseHours!.toString();

    request.fields["personalId"] = data.personaId!.toString();
    request.fields["businessId"] = data.businessId!.toString();
    request.fields["businessBio"] = data.businessBio!.toString();
    request.fields["city"] = data.city!.toString();

    request.fields["state"] = data.state!.toString();
    request.fields["country"] = data.country!.toString();
    request.fields["vendorClassifier"] = vendorClassifier.toString();
    //  request.files.add(file);
    try {
      response = await request.send();
    } catch (e) {
      log(e.toString());
      response = null;
    }
    return response;
  }
}

void consoleLog(String val) {
  return debugPrint(val);
}
