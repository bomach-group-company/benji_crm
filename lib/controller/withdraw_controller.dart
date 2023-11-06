import 'dart:convert';

import 'package:benji_aggregator/model/bank_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/api_url.dart';
import '../services/helper.dart';

class WithdrawController extends GetxController {
  static WithdrawController get instance {
    return Get.find<WithdrawController>();
  }

  bool? isFirst;
  WithdrawController({this.isFirst});
  var isLoad = false.obs;

  var listOfBanks = <BankModel>[].obs;

  listBanks() async {
    var url = "${Api.baseUrl}${Api.listBanks}?start=0&end=30";
    isLoad.value = true;
    update();
    final response = await http.get(Uri.parse(url), headers: authHeader());
    if (response.statusCode == 200) {
      consoleLog(response.body);
      listOfBanks.value = (jsonDecode(response.body) as List)
          .map((item) => BankModel.fromJson(item))
          .toList();
    } else {
      listOfBanks.value = [];
    }
    isLoad.value = false;

    update();
  }
}
