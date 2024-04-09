import 'package:get/get.dart';

class LatLngDetailController extends GetxController {
  static LatLngDetailController get instance {
    return Get.find<LatLngDetailController>();
  }

  var latLngDetail = [].obs;
  setLatLngdetail(List latLngDetailList) {
    latLngDetail.value = latLngDetailList;
    update();
  }

  setEmpty() {
    latLngDetail.removeRange(0, latLngDetail.length);
    latLngDetail.addAll(['', '', '']);
    update();
  }

  isNotEmpty() {
    for (var i = 0; i < latLngDetail.length; i++) {
      if ((latLngDetail[i] as String).isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
