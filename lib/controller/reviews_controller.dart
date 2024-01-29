// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/rating_model.dart';
import '../services/api_url.dart';
import '../services/helper.dart';
import 'user_controller.dart';

class ReviewsController extends GetxController {
  static ReviewsController get instance {
    return Get.find<ReviewsController>();
  }

  var isLoad = false.obs;
  var ratingValue = 0.obs;
  var avgRating = 0.0.obs;
  var total = 0.obs;
  var reviews = <RatingModel>[].obs;

  Future<void> scrollListener(scrollController, [int value = 0]) async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setRatingValue(value);
    }
  }

  getAvgRating() async {
    int id = UserController.instance.user.value.id;

    final response = await http.get(
      Uri.parse('${Api.baseUrl}/vendors/$id/getVendorAverageRating'),
      headers: authHeader(),
    );
    if (response.statusCode == 200) {
      avgRating.value = double.parse(response.body);
    } else {
      avgRating.value = 0.0;
    }
    update();
  }

  Future setRatingValue([int value = 0]) async {
    ratingValue.value = value;
    reviews.value = [];
    update();
    await getReviews();
  }

  Future getReviews([int? value]) async {
    isLoad.value = true;

    try {
      reviews.value =
          await getRatingsByVendorIdAndOrRating(value ?? ratingValue.value);
    } catch (e) {
      consoleLog(e.toString());
    }
    isLoad.value = false;
    update();
  }

  Future<List<RatingModel>> getRatingsByVendorIdAndOrRating(int rating,
      {start = 0, end = 100}) async {
    int id = UserController.instance.user.value.id;

    // url to be changed to vendor endpoint
    late http.Response response;
    if (rating != 0) {
      response = await http.get(
        Uri.parse(
            '$baseURL/clients/filterVendorReviewsByRating/$id?rating_value=$rating'),
        headers: authHeader(),
      );
      if (response.statusCode == 200) {
        List data = (jsonDecode(response.body) as List);
        total.value = data.length;
        update();

        return (data).map((item) => RatingModel.fromJson(item)).toList();
      } else {
        total.value = 0;
        update();

        return [];
      }
    } else {
      response = await http.get(
        Uri.parse(
            '$baseURL/vendors/$id/getAllVendorRatings?start=$start&end=$end'),
        headers: authHeader(),
      );

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        total.value = data['total'];
        update();

        return (data['items'] as List)
            .map((item) => RatingModel.fromJson(item))
            .toList();
      } else {
        total.value = 0;
        update();

        return [];
      }
    }
  }
}
