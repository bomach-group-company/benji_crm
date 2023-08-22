import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/model/vendor_list_model.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/pref.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VendorController extends GetxController {
  static VendorController get instance {
    return Get.find<VendorController>();
  }

  var isLoad = false.obs;
  var vendorList = <VendorListModel>[].obs;
  var vendorProductList = <VendorListModel>[].obs;
  var vendor = VendorModel().obs;
  Future runTask() async {
    isLoad.value = true;
    late String token;
    update();
    var url = Api.baseUrl + Api.riderList;
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    consoleLog(KeyStore.getToken.toString());
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = vendorListModelFromJson(responseData);
      vendorList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future getSpecificVendor(id) async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.getSpecificVendor + id.toString();
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = VendorModel.fromJson(responseData);
      vendor.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future listVendorProduct(id) async {
    isLoad.value = true;
    late String token;
    update();
    var url = Api.baseUrl + Api.getVendorProducts + id.toString();
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = vendorListModelFromJson(responseData);
      vendorProductList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future filterProductBySubCat(vendorId, subCatId) async {
    isLoad.value = true;
    late String token;
    update();
    var url = Api.baseUrl + Api.getVendorProducts + "";
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = vendorListModelFromJson(responseData);
      vendorProductList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
