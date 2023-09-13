import 'dart:convert';
import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/vendor_list_model.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/pref.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/business_trype_model.dart';
import '../model/create_vendor_model.dart';
import '../model/my_vendor.dart';
import '../model/sub_category_model.dart';
import '../model/upload_prod_model.dart';
import '../model/vendor_orders_model.dart';
import '../model/vendor_product_model.dart';

class VendorController extends GetxController {
  static VendorController get instance {
    return Get.find<VendorController>();
  }

  bool? isFirst;
  VendorController({this.isFirst});
  var isLoad = false.obs;
  var isLoadMyVendor = false.obs;
  var isLoadCreate = false.obs;
  var isLoadAdd = false.obs;
  var isLoadCat = false.obs;
  var vendorList = <VendorListModel>[].obs;
  var subCategoryList = <SubCategoryModel>[].obs;
  var myVendorList = <MyVendorModel>[].obs;
  var businessType = <BusinessType>[].obs;
  var vendorProductList = <Item>[].obs;
  var vendorOrderList = <DataItem>[].obs;
  var vendor = VendorModel().obs;
  var subCatSelected = "Select".obs;
  var subCategoryListString = <String>[].obs;

  @override
  void onInit() {
    runTask();
    // TODO: implement onInit
    super.onInit();
  }

  Future runTask() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    //update();
    var url = Api.baseUrl + Api.vendorList + "?agent_id=$id";
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    consoleLog(token);
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      var save = vendorListModelFromJson(responseData);
      vendorList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future getMyVendor() async {
    isLoadMyVendor.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    //update();
    var url = Api.baseUrl + Api.myVendor + "?agent_id=$id";
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    // consoleLog(token);
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      //    consoleLog(responseData.toString());
      var save = myVendorModelFromJson(responseData);
      // consoleLog(save.length.toString());

      myVendorList.value = save;
//consoleLog(myVendorList.length.toString());
      update();
    } catch (e) {
      consoleLog(e.toString());
    }
    isLoadMyVendor.value = false;
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

  Future listVendorProduct(id, [int? end]) async {
    isLoad.value = true;
    late String token;
    update();
    var url = Api.baseUrl +
        Api.getVendorProducts +
        id.toString() +
        "?start=1&end=${end ?? 1}";
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      if (responseData == null) {
        return;
      }
      try {
        var save = VendorProductListModel.fromJson(jsonDecode(responseData));
        vendorProductList.value = save.items!;
      } catch (e) {
        print(e);
      }
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future listVendorOrder(id, [int? end]) async {
    isLoad.value = true;
    late String token;
    update();
    var url = Api.baseUrl +
        Api.listVendorOrders +
        id.toString() +
        "?start=1&end=${end ?? 1}";
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      if (responseData == null) {
        return;
      }
      try {
        var save = VendorOrderModel.fromJson(jsonDecode(responseData));
        vendorOrderList.value = save.items!;
      } catch (e) {
        print(e);
      }
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future getBusinessTypes() async {
    isLoad.value = true;
    late String token;

    var url = Api.baseUrl + Api.businessType;
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.Response? response = await RequestData.getApi(url, token);
      try {
        var responseData =
            await ApiProcessorController.errorState(response, isFirst ?? true);
        if (responseData == null) {
          return;
        }
        var save = businessTypeFromJson(responseData);
        businessType.value = save;
      } catch (e) {
        consoleLog('from $e');
      }
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future createVendor(SendCreateModel data, bool classify) async {
    isLoadCreate.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.createVendor + id;
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.StreamedResponse? response =
          await RequestData.streamAddVCendor(url, token, data, classify);
      if (response == null) {
        isLoadCreate.value = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(jsonData);
        consoleLog(jsonData);
        isLoadCreate.value = false;
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        //    var jsonData = jsonDecode(res.body);
        consoleLog(res.body.toString());
        isLoadCreate.value = false;
      }
      isLoadCreate.value = false;

      update();
    } catch (e) {}
    isLoadCreate.value = false;
    update();
  }

  Future addProductToVendor(UploadProduct data) async {
    isLoadAdd.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.addProductToVendor;
    await KeyStore.getToken().then((element) {
      token = element!;
    });

    try {
      http.StreamedResponse? response =
          await RequestData.streamAddProductToVendor(url, token, data);
      if (response == null) {
        isLoadAdd.value = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(jsonData);
        consoleLog(jsonData);
        isLoadAdd.value = false;
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        //    var jsonData = jsonDecode(res.body);
        consoleLog(res.body.toString());
        isLoadAdd.value = false;
      }
      isLoadAdd.value = false;

      update();
    } catch (e) {}
    isLoadAdd.value = false;
    update();
  }

  Future getSubCat() async {
    isLoadCat.value = true;
    late String token;
    //update();
    var url = Api.baseUrl + Api.subCategory;
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    consoleLog(token);
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      var save = subCategoryModelFromJson(responseData);
      subCategoryList.value = save;
      save.forEach((element) {
        subCategoryListString.add("${element.name}|${element.id}");
      });
      update();
    } catch (e) {}
    isLoadCat.value = false;
    update();
  }

  Future addSubCat(String val) async {
    subCatSelected.value = val;
    update();
  }
}
