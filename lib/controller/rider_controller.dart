// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/rider_list_model.dart';
import '../model/rifer_model.dart';
import '../services/pref.dart';

class RiderController extends GetxController {
  static RiderController get instance {
    return Get.find<RiderController>();
  }

  var isLoad = false.obs;
  var riderList = <RiderListModel>[].obs;
  var rider = RiderModel().obs;

  Future runTask() async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.riderList;
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = riderListModelFromJson(responseData);
      riderList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future getSpecificRider(id) async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.getSpecificRider + id.toString();
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = RiderModel.fromJson(responseData);
      rider.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future assignRiderTask(riderId, orderId) async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.assignRiderTask;
    var data = {"rider_id": "$riderId", "order_id": "$orderId"};
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    try {
      http.Response? response = await RequestData.postApi(url, token, data);
      var responseData = await ApiProcessorController.errorState(response);

      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
