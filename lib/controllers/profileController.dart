import 'package:app/const/url.dart';
import 'package:app/helpers/print.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Map profile = {};

  Future<void> getProfile(String id) async {
    try {
      final _getProfileResponse = await Dio().get(baseUrl + "/profile/$id");
      profile = _getProfileResponse.data;

      prettyPrint("DATA_PROFILE", _getProfileResponse.data);
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }

  Future<dynamic> getLaundries() async {
    try {
      final _getLaundriesResponse = await Dio().get(
        baseUrl + "/profile?accountType=laundry",
      );
      prettyPrint("DATA_LAUNDRIES", _getLaundriesResponse.data);

      return _getLaundriesResponse.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }
}
