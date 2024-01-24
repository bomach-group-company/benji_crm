// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FormController extends GetxController {
  static FormController get instance {
    return Get.find<FormController>();
  }

  var isLoad = false.obs;
  var status = 0.obs;
  var responseObject = {}.obs;

  Future postAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully",
      bool encodeIt = false]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      headers: authHeader(),
      body: encodeIt ? jsonEncode(data) : data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }

  Future deleteAuth(String url, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.delete(
      Uri.parse(url),
      headers: authHeader(),
    );
    status.value = response.statusCode;
    update([tag]);
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    update([tag]);
  }

  Future patchAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update();
    update([tag]);
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: authHeader(),
        body: jsonEncode(data),
      );
      status.value = response.statusCode;
      consoleLog(response.body);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode != 200) {
        ApiProcessorController.errorSnack(errorMsg);
        isLoad.value = false;
        update();
        update([tag]);
        return;
      } else {
        if (responseBody is String) {
          ApiProcessorController.successSnack(successMsg);
          isLoad.value = false;
          update();
          update([tag]);
        } else if (responseBody is Map) {
          responseObject.value = (responseBody);
          ApiProcessorController.successSnack(successMsg);
          isLoad.value = false;
          update();
          update([tag]);
        }
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      consoleLog(e.toString());
      ApiProcessorController.errorSnack(errorMsg);
    }

    isLoad.value = false;
    update();
    update([tag]);
  }

  Future postNoAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }

  Future postAuthstream(
      String url, Map data, Map<String, File?> files, String tag,
      [String errorMsg = "An error occurred",
      String successMsg = "Submitted successfully"]) async {
    http.StreamedResponse? response;

    isLoad.value = true;
    update();
    update([tag]);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    Map<String, String> headers = authHeader();

    for (String key in files.keys) {
      if (files[key] == null) {
        continue;
      }
      request.files
          .add(await http.MultipartFile.fromPath(key, files[key]!.path));
    }

    request.headers.addAll(headers);

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    log('first stream response: $response');
    try {
      response = await request.send();
      log('second stream response body: ${response.statusCode}');
      final normalResp = await http.Response.fromStream(response);
      log('third stream response body: ${normalResp.body}');
      status.value = response.statusCode;
      if (response.statusCode == 200) {
        ApiProcessorController.successSnack(successMsg);
        log('Got here!');
        isLoad.value = false;
        update();
        update([tag]);
        return;
      } else {
        ApiProcessorController.errorSnack(errorMsg);
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      isLoad.value = false;
      update();
      update([tag]);
      return;
    } catch (e) {
      ApiProcessorController.errorSnack("An error occured. \nERROR: $e");
      log("An error occured. \nERROR: $e");
      response = null;
      isLoad.value = false;
      update();
      update([tag]);
      return;
    }

    ApiProcessorController.errorSnack(errorMsg);
    isLoad.value = false;
    update([tag]);
    return;
  }
}
