// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RiderAssignController extends GetxController {
  static RiderAssignController get instance {
    return Get.find<RiderAssignController>();
  }

  var isLoad = false.obs;

  Future<http.Response> assignTaskToRider(
      String itemType, String itemId, String driver) async {
    isLoad.value = true;
    update();
    final body = {
      'item_type': itemType,
      'item_id': itemId,
      'driver': driver,
    };
    final url = Uri.parse('$baseURL/tasks/assignTaskToRider');
    print(body);
    print(url);
    final response = await http.post(url, headers: authHeader(), body: body);
    isLoad.value = false;
    update();
    print(response.statusCode);
    print(response.body);
    return response;
  }
}
