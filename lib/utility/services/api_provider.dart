import 'package:get/get.dart';

import '../helper/common_helper.dart';
import '../helper/snack_bar_utils.dart';

class ApiProvider extends GetConnect {
  static Future<dynamic> getMethod({
    required String url,
  }) async {
    List<dynamic> jsonResponse = [];
    GetConnect getConnect = GetConnect();
    getConnect.timeout = const Duration(seconds: 30);
    Response response = await getConnect.get(url);
    jsonResponse = [];
    CommonHelper.printDebug("$url\n${response.bodyString}");
    if (response.status.connectionError) {
      SnackBarUtils.errorSnackBar(
        title: 'Connection Timeout',
        message: 'Check your internet connection',
      );
      throw Exception("timeout");
    } else if (!response.status.hasError) {
      Map data = response.body;
      String? status = data["status"];
      Map<String, dynamic> statusMap = {"api_status": "$status"};
      if (data["Data"] != null) {
        for (int i = 0; i < data["Data"].length; i++) {
          Map<String, dynamic> maps = data["Data"][i];
          maps.update("api_status", (existingValue) => status, ifAbsent: () {
            maps.addIf(!maps.containsKey("api_status"), "api_status", status);
          });
          maps.update("api_status", (value) => status);
          jsonResponse.add(maps);
        }
      } else {
        jsonResponse.add(statusMap);
      }
    }
    return jsonResponse;
  }

  static Future<dynamic> postMethod({
    required String url,
    Map<String, dynamic>? obj,
    List<Map<String, dynamic>?>? objList,
    bool? hideSnackBars,
  }) async {
    List<dynamic> jsonResponse = [];
    GetConnect getConnect = GetConnect();
    getConnect.timeout = const Duration(minutes: 2);
    CommonHelper.printDebug("$url\n${(obj ?? objList).toString()}");
    final response = await getConnect.post(url, obj ?? objList);
    CommonHelper.printDebug("$url\n${response.bodyString}");
    jsonResponse = [];
    if (response.status.connectionError) {
      if (hideSnackBars != true) {
        SnackBarUtils.errorSnackBar(
          title: 'Connection Timeout',
          message: 'Check your internet connection',
        );
      }
      throw Exception("timeout");
    } else if (!response.status.hasError) {
      Map data = response.body;
      String? status = data["status"];
      Map<String, dynamic> statusMap = {"api_status": "$status"};
      if (data["Data"] != null) {
        for (int i = 0; i < data["Data"].length; i++) {
          Map<String, dynamic> maps = data["Data"][i];
          maps.update("api_status", (existingValue) => status, ifAbsent: () {
            maps.addIf(!maps.containsKey("api_status"), "api_status", status);
          });
          maps.update("api_status", (value) => status);
          jsonResponse.add(maps);
        }
      } else {
        jsonResponse.add(statusMap);
      }
      return jsonResponse;
    }
  }
}
