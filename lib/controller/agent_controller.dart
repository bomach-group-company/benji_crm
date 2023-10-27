// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/agent_model.dart';
import '../services/api_url.dart';
import 'user_controller.dart';

class AgentController extends GetxController {
  static AgentController get instance {
    return Get.find<AgentController>();
  }

  @override
  void onInit() {
    super.onInit();
    getAgentDetails();
  }

  var isLoading = false.obs;
  var agent = AgentModel.fromJson(null).obs;
  var agentId = UserController.instance.user.value.id;

  Future<void> getAgentDetails() async {
    isLoading.value = true;
    var url = "${Api.baseUrl}/agents/getAgent/{$agentId}";
    consoleLog(url.toString());

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> agentData = json.decode(response.body);
        agent.value = AgentModel.fromJson(agentData);
        consoleLog(agentData.toString());
        ApiProcessorController.successSnack(
          "Successfully Fetched agent's details",
        );
      } else {
        ApiProcessorController.errorSnack("Failed to fetch agent's details");
        throw Exception('Failed to fetch agent details');
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack(
        "Failed to fetch agent's details. \n ERROR: $e",
      );
      throw Exception('Failed to fetch agent details: $e');
    }
    isLoading.value = false;
  }

  Future<bool> updatedAgentProfile() async {
    return false;
  }
}
