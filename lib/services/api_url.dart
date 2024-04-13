import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

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

//Vendor
  static const vendorMyList = "/agents/listAllMyVendors";
  static const thirdPartyMyVendorList = "/agents/listThirdPartyMyVendor";
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

  //Businesses
  static const getVendorBusinesses = "/agents/getVendorBusinesses/";
  static const agentCreateVendorBusiness = "/agents/agentCreateVendorBusiness/";

  //Products
  static const agentAddProductToVendorBusiness =
      "/agents/agentAddProductToVendorBusiness";
  static const changeProduct = "/products/changeProduct/";
  static const changeProductImage = "/products/updateProductImage/";
  static const deleteProduct = "/products/deleteProduct/";

  //order
  static const orderList = "/agents/getTotalNumberOfMyVendorsOrders/";
  static const changeOrderStatus = "/orders/vendorChangeStatus";
  static const vendorsOrderList = "/vendors/";

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
  static const getBanks = "/payments/list_banks/";
  static const withdrawalHistory = "/wallet/withdrawalHistory/";
  static const listWithdrawalHistories =
      "/withdrawalhistory/listWithdrawalHistories/";
  static const validateBankNumber = "/payments/validateBankNumbers/";
  static const saveBankDetails = "/payments/saveBankDetails";

  //Item Packages
  static const getPackageCategory = "/sendPackage/getPackageCategory/";
  static const getPackageWeight = "/sendPackage/getPackageWeight/";
  static const createItemPackage = "/sendPackage/createItemPackage/";
  static const dispatchPackage = "/sendPackage/changePackageStatus";
  static const reportPackage = "/clients/clientReportPackage/";

  //Payments
  static const getDeliveryFee = "/payments/getdeliveryfee/";

  //Push Notification
  static const createPushNotification = "/notifier/create_push_notification";
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
      ).timeout(const Duration(seconds: 20));
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future put() async {}
  static Future delete() async {}

  static Future<http.StreamedResponse?> streamAddVendor(
      url, token, SendCreateModel data, bool vendorClassifier) async {
    http.StreamedResponse? response;

    final filePhotoName = basename(data.profileImage!.path);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Content-Type": content,
      'authorization': 'Bearer $token',
    };

    request.files.add(http.MultipartFile(
      'image',
      data.profileImage!.readAsBytes().asStream(),
      await data.profileImage!.length(),
      filename: 'image.jpg',
      contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
    ));

    // var file = await http.MultipartFile.fromPath(
    //     'image', data.profileImage!.path,
    //     filename: filePhotoName);

    request.headers.addAll(headers);

    request.fields["email"] = data.email!.toString();
    request.fields["phone"] = data.phoneNumber!.toString();
    request.fields["address"] = data.address!.toString();

    request.fields["city"] = data.city!.toString();

    request.fields["first_name"] = data.firstName!.toString();
    request.fields["last_name"] = data.lastName!.toString();
    request.fields["gender"] = data.gender!.toString();
    request.fields["lga"] = data.lga!.toString();
    request.fields["personalId"] = data.personalID!.toString();
    request.fields["state"] = data.state!.toString();
    request.fields["country"] = data.country!.toString();
    request.fields["latitude"] = data.latitude!.toString();
    request.fields["longitude"] = data.longitude!.toString();
    request.fields["vendorClassifier"] = vendorClassifier.toString();
    // request.files.add(file);
    try {
      response = await request.send();
    } catch (e) {
      log(e.toString());
      response = null;
    }
    return response;
  }

  static Future<http.StreamedResponse?> streamAddThirdPartyVendor(
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

    request.fields["email"] = data.email!.toString();
    request.fields["phone"] = data.phoneNumber!.toString();
    request.fields["address"] = data.address!.toString();

    request.fields["first_name"] = data.firstName!.toString();
    request.fields["last_name"] = data.lastName!.toString();
    request.fields["gender"] = data.gender!.toString();
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

    request.fields["email"] = data.email!.toString();
    request.fields["phone"] = data.phoneNumber!.toString();
    request.fields["address"] = data.address!.toString();

    // request.fields["personalId"] = data.personaId!.toString();
    // request.fields["businessId"] = data.businessId!.toString();
    request.fields["city"] = data.city!.toString();

    request.fields["state"] = data.state!.toString();
    request.fields["country"] = data.country!.toString();
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
