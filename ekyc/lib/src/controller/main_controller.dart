import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:flutter_pkg/src/models/document_upload.dart';
import 'package:flutter_pkg/src/models/state_log.dart';
import 'package:flutter_pkg/src/repo/log_service.dart';
import 'package:flutter_pkg/src/repo/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MainController extends GetxController {
  var lagel = "INITIALIZING".obs;
  final EkycPreferences ekycStateStorage = EkycPreferences()..init();
  final EKycRepo logProvider = EKycRepo()..initLog();
  var kyclog = KycStateLog().obs;
  var base64Image = "".obs;
  var predictions = [].obs;
  var imagebytes = "".obs;
  var confidence = "".obs;
  var image = "".obs;
  var currentPage = 0.obs;
  late PageController pageController;

  var blinks = 0.obs;

  ///images
  var frontImage = "".obs;
  var backImage = "".obs;
  var tilted = "".obs;
  var selfie = "".obs;

  var blink = "".obs;
  var blinkByte = "".obs;
  var frontImageByte = "".obs;
  var backImageByte = "".obs;
  var tiltedByte = "".obs;
  var selfieByte = "".obs;

  ///
  ///
  /// for editing case
  var isEdit = false.obs;
  @override
  void onInit() {
    super.onInit();

    pageController = PageController();
    // loadState();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  nextPage() {
    pageController.nextPage(duration: 200.milliseconds, curve: Curves.ease);
  }

  /// previous page
  previousPage() {
    if (currentPage.value > 3) {
      pageController.animateToPage(currentPage.value - 2,
          duration: 200.milliseconds, curve: Curves.ease);
    }
  }

  convertImage() {
    frontImageByte(convertToByte64(frontImage.value));
    backImageByte(convertToByte64(backImage.value));
    tiltedByte(convertToByte64(tilted.value));
    selfieByte(convertToByte64(selfie.value));
  }

  loadState() async {
    await Future.delayed(const Duration(seconds: 2));

    var stateData = ekycStateStorage.getEkycState();

    var currentState = stateData[0] ?? -1;

    if (stateData[1] != []) {
      if (stateData[1].length > 0) {
        if (currentState >= 0) frontImageByte.value = (stateData[1][0]);
        if (currentState >= 1) tiltedByte.value = stateData[1][1];
        if (currentState >= 2) backImageByte.value = stateData[1][2];
        if (currentState >= 3) selfieByte.value = stateData[1][3];
        if (currentState >= 4) blinkByte.value = stateData[1][4];
      } else {
        currentState = -1;
      }
    }
    if (frontImage.value.isEmpty) {
      await setupFileToUpload();
    }

    return currentState;
  }

  setupFileToUpload() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    /// FRONT IMAGE
    var frontFile = File(
        "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
    frontFile.writeAsBytesSync(base64Decode(frontImageByte.value));

    /// TILTED IMAGE
    var tiltedFile = File(
        "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
    tiltedFile.writeAsBytesSync(base64Decode(tiltedByte.value));

    /// BACK IMAGE
    var backFile = File(
        "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
    backFile.writeAsBytesSync(base64Decode(backImageByte.value));

    /// SELFIE IMAGE

    var selfieFile = File(
        "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");

    selfieFile.writeAsBytesSync(base64Decode(selfieByte.value));

    // Get.log("BLINK IMAGE");

    /// BLINK IMAGE
    ///
    var blinkFile = File(
        "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
    blinkFile.writeAsBytesSync(base64Decode(blinkByte.value));

    frontImage(frontFile.path);

    backImage(backFile.path);
    tilted(tiltedFile.path);
    selfie(selfieFile.path);
    blink(blinkFile.path);
  }

  uploadImage(DocumentUpload documentUpload) async {
    final FormData formData = FormData(documentUpload.toJson());

    // formData.files.add(MapEntry(
    //     'front_image',
    //     MultipartFile(File(frontImage.value),
    //         filename: selfie.value.split('/').last)));
    // formData.files.add(MapEntry(
    //     'back_image',
    //     MultipartFile(File(backImage.value),
    //         filename: backImage.value.split('/').last)));

    // formData.files.add(MapEntry(
    //     'tilted_image',
    //     MultipartFile(File(tilted.value),
    //         filename: tilted.value.split('/').last)));

    // formData.files.add(MapEntry(
    //     'profile_image',
    //     MultipartFile(File(selfie.value),
    //         filename: selfie.value.split('/').last)));
    // formData.files.add(MapEntry(
    //     'blink_image',
    //     MultipartFile(File(blink.value),
    //         filename: blink.value.split('/').last)));
    try {
      return await logProvider.uploadDocument(formData);
    } catch (e) {
      rethrow;
    }
    // return true;
  }

  updateState(String state) async {
    final FormData formData =
        FormData({"state": isEdit.isTrue ? kyclog.value.state ?? "" : state});
    // var size = File(frontImage.value).lengthSync();
    // log(frontImage.value);
    // log(size.toString() + "FILE SIZE");
    switch (state) {
      case AppStrings.FRONT:
        formData.files.add(MapEntry(
            'front_image',
            MultipartFile(File(frontImage.value),
                filename: frontImage.value.split('/').last)));

        break;
      case AppStrings.BACK:
        formData.files.add(MapEntry(
            'back_image',
            MultipartFile(File(backImage.value),
                filename: backImage.value.split('/').last)));
        break;
      case AppStrings.TILTED:
        formData.files.add(MapEntry(
            'tilted_image',
            MultipartFile(File(tilted.value),
                filename: tilted.value.split('/').last)));
        break;
      case AppStrings.SELFIE:
        formData.files.add(MapEntry(
            'profile_image',
            MultipartFile(File(selfie.value),
                filename: selfie.value.split('/').last)));
        break;
      case AppStrings.BLINK:
        formData.files.add(MapEntry(
            'blink_image',
            MultipartFile(File(blink.value),
                filename: blink.value.split('/').last)));
        break;
      default:
    }

    var result = await logProvider.updateFormState(formData);

    try {
      if (result != null) {
        kyclog(KycStateLogResponse.fromJson(result).data!);
      } else {
        return result;
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  uploadCardTypeAndCardNumber(String cardType, String cardNumber) {
    final FormData formData = FormData({
      "state": AppStrings.INIT,
      "kyc_type": cardType,
      "card_number": cardNumber
    });

    logProvider.updateFormState(formData);
  }

  updateFinishedKycState() async {
    final FormData formData =
        FormData({"state": AppStrings.DOCUMENT_VERIFICATION});
    try {
      return await logProvider.updateFormState(formData);
    } catch (e) {
      rethrow;
    }
  }
}

convertToByte64(image) {
  var bytes = File(image).readAsBytesSync();
  var base64 = base64Encode(bytes);
  return base64;
}
