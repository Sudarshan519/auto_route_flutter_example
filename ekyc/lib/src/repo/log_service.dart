import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiEndPoints {
  static const baseUrl = "https://rpsremit.truestreamz.com/api/v1/";
}

class EKycRepo extends GetConnect {
  late String token;
  late String device;

  @override
  void onInit() {
    super.onInit();

    initLog();
    httpClient.timeout = 300.seconds;
  }

  uploadDocument(documentUpload) async {
    //  TODO UPload
    final client = GetConnect(timeout: 500.seconds);
    try {
      var response = await client
          .post('https://rpsremit.truestreamz.com/api/v1/document',
              documentUpload,
              headers: token == ""
                  ? {}
                  : {
                      "Authorization": "Bearer $token",
                    },
              contentType: 'multipart/form-data')
          .timeout(const Duration(seconds: 500));

      Get.log(response.body.toString());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  initLog() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var data = sharedPreferences.getString("rpsUser");
    if (data != null) {
      token = jsonDecode(data)['access_token'];
    } else {
      token = "";
    }
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        device =
            ('Running on Android : ${androidInfo.model} with id =${androidInfo.id}'); // e.g. "Moto G (4)"
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        device =
            ('Running on IOS : ${iosInfo.name} ${iosInfo.model} ${iosInfo.utsname.machine}');
      }
    } catch (e) {
      device = "android : Failed to get info";
      sendLog("Unable to get Device Info", funcName: "initLog()");
    }
    if (!kDebugMode) sendLog("init log", funcName: "initLog()");
    Get.log("LOG INIT");
  }

  sendLog(
    String log, {
    String funcName = "init",
    String errorMsg = "init",
    String label = "EKYC LOG",
  }) async {
    var body = {
      "label": "EKYC",
      "platform": GetPlatform.isAndroid
          ? "android"
          : GetPlatform.isIOS
              ? "IOS"
              : "unkown",
      "error_message": errorMsg,
      "function_name": funcName,
      "device_id": device,
      "log": log + " " // + token
    };
    if (true) {
      var result = await post(
          'https://rpsremit.truestreamz.com/api/v1/api_report/', body,
          headers: token == "" ? {} : {"Authorization": "Bearer $token"});
      Get.log(result.body.toString());
      // ignore: dead_code
    } else {
      Get.log(body.toString());
    }
  }

  updateFormState(FormData formData) async {
    final client = GetConnect(timeout: 500.seconds);
    try {
      var response = await client
          .post('https://rpsremit.truestreamz.com/api/v1/statelog', formData,
              headers: token == ""
                  ? {}
                  : {
                      "Authorization": "Bearer $token",
                    },
              contentType: 'multipart/form-data')
          .timeout(const Duration(seconds: 500));

      Get.log(response.body.toString());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
