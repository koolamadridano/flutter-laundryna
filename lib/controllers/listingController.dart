import 'package:app/const/url.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/print.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ListingController extends GetxController {
  Future<void> addListing({title, price}) async {
    try {
      Get.toNamed("/loading");
      final accountId = Get.put(UserController()).userLoginData["accountId"];
      await Dio().post(
        baseUrl + "/laundry/listing",
        data: {
          "accountId": accountId,
          "title": title,
          "price": price,
          "availability": true
        },
      );
      Get.toNamed("/laundry-manage");
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("addListing()", e.response!.data);
      }
    }
  }

  Future<void> getListings({required bool availability}) async {
    try {
      final accountId = Get.put(UserController()).userLoginData["accountId"];
      var _listingsResponse = await Dio().get(
        baseUrl + "/laundry/listing",
        queryParameters: {
          "accountId": accountId,
          "availability": availability,
        },
      );
      return _listingsResponse.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getListings()", e.response!.data);
      }
    }
  }

  Future<void> getLaundryListings({required availability, accountId}) async {
    try {
      var _listingsResponse = await Dio().get(
        baseUrl + "/laundry/listing",
        queryParameters: {
          "accountId": accountId,
          "availability": availability,
        },
      );
      return _listingsResponse.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getListings()", e.response!.data);
      }
    }
  }

  Future<void> deleteListing(id) async {
    await Dio().delete(baseUrl + "/laundry/listing/$id");
  }
}
