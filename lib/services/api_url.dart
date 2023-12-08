import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/create_vendor_model.dart';

// API URLS AND HTTP CALL FUNCTIONS
const baseURL = "https://resource.bgbot.app/api/v1";
const baseImage = "https://resource.bgbot.app";

class Api {
  static const baseUrl = "https://resource.bgbot.app/api/v1";
  static const login = "/auth/token";
  static const getAgent = "/agents/getAgent/";
  static const user = "/auth/";
  static const notification = "/agents/getAgentNotifications/";
  static const changePassword = "/auth/changeNewPassword/";
  static const validateBankNumber = "/payments/validateBankNumbers/";

//Vendor
  static const vendorList = "/agents/listAllMyVendors";
  static const vendorMyList = "/agents/listThirdPartyMyVendor";
  static const agentCreateVendor = "/agents/agentCreateVendor";
  static const getSpecificVendor = "/agents/getVendor/";
  static const getVendorProducts = "/agents/listVendorProducts/";
  static const filterVendorProduct =
      "/agents/filterVendorProductsBySubCategory";
  static const listVendorOrders = "/agents/listVendorOrders/";
  static const getVendorRatings = "/agents/getVendorAverageRating/";
  static const createVendor = "/agents/agentCreateVendor/";
  static const createVendorOtherBusiness =
      "/vendors/createVendorOtherBusiness/";

  static const agentAddProductToVendor = '/agents/agentAddProductToVendor';

  static const createThirdPartyVendor = "/agents/agentCreateThirdPartyVendor/";

  //order
  static const orderList = "/agents/getAllMyVendorsOrders/";

  //Rider
  static const riderList = "/agents/listAllRiders";
  static const getSpecificRider = "/agents/getRider/";
  static const assignRiderTask = "/agents/assignOrdersToRider";
  static const riderHistory = "/agents/ridersHistories/";
  static const category = "/categories/list";
  static const report = "/report/CreateReport";

  //BusinessTypes
  static const businessType = "/categories/list";

  //Wallet
  static const listBanks = "/wallet/list_banks/";
  static const withdrawalHistory = "/wallet/withdrawalHistory/";
  static const listWithdrawalHistories =
      "/withdrawalhistory/listWithdrawalHistories/";
}

String header = "application/json";
const content = "application/x-www-form-urlencoded";

class HandleData {
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
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    print(response?.body);
    print(url);
    return response;
  }

  static Future put() async {}
  static Future delete() async {}

  static Future<http.StreamedResponse?> streamAddVendor(
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

  static Future<http.StreamedResponse?> streamAddThirdPartyVendor(
      url, token, SendCreateModel data) async {
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

    // request.fields["personalId"] = data.personaId!.toString();
    // request.fields["businessId"] = data.businessId!.toString();
    request.fields["businessBio"] = data.businessBio!.toString();

    request.fields["city"] = data.city!.toString();
    request.fields["state"] = data.state!.toString();
    request.fields["country"] = data.country!.toString();
    request.fields["latitude"] = data.latitude!.toString();
    request.fields["longitude"] = data.longitude!.toString();
    print(request.fields);
    //  request.files.add(file);
    try {
      response = await request.send();
    } catch (e) {
      log(e.toString());
      response = null;
    }
    return response;
  }

  static Future<http.StreamedResponse?> streamAddToVendor(
      url, token, SendCreateModel data) async {
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

    // request.fields["personalId"] = data.personaId!.toString();
    // request.fields["businessId"] = data.businessId!.toString();
    request.fields["businessBio"] = data.businessBio!.toString();
    request.fields["city"] = data.city!.toString();

    request.fields["state"] = data.state!.toString();
    request.fields["country"] = data.country!.toString();
    print(request.fields);
    //  request.files.add(file);
    try {
      response = await request.send();
    } catch (e) {
      consoleLog(e.toString());
      response = null;
    }
    return response;
  }
}

consoleLog(String val) {
  return debugPrint(val);
}
