import 'package:app/const/url.dart';
import 'package:app/helpers/print.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Map selectedOrder = {};

  Future<void> createOrder(order) async {
    try {
      Get.toNamed("/loading");
      await Dio().post(baseUrl + "/order", data: order);
      Get.toNamed("/customer-orders");
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("orderController()", e.response!.data);
      }
    }
  }

  Future<dynamic> getOrders({accountId, status, accountType}) async {
    try {
      final _getOrders = await Dio().get(
        baseUrl + "/order",
        queryParameters: {
          "accountId": accountId,
          "accountType": accountType,
          "status": status
        },
      );

      return _getOrders.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getOrders()", e.response!.data);
      }
    }
  }

  Future<void> updateOrderStatus({id, status}) async {
    await Dio().put(baseUrl + "/order", queryParameters: {
      "_id": id,
      "status": status,
    });
  }

  Future<void> deleteOrder(id) async {
    await Dio().delete(baseUrl + "/order/$id");
  }
}
