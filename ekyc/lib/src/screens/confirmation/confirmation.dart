import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/flutter_pkg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({Key? key, required this.type, this.isBlink = false})
      : super(key: key);
  final String type;
  final bool isBlink;
  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final MainController controller = Get.find();
  var base64 = "";
  getBase64(path) {
    if (path != "") {
      base64 = convertToByte64(path);

      Get.log(widget.type);
      switch (widget.type) {
        case AppStrings.FRONT:
          controller.ekycStateStorage.frontImageByte = base64;
          break;
        case AppStrings.TILTED:
          controller.ekycStateStorage.tiltedByte = base64;
          break;
        case AppStrings.BACK:
          controller.ekycStateStorage.backImageByte = base64;
          break;
        case AppStrings.SELFIE:
          controller.ekycStateStorage.selfieByte = base64;
          break;
        case AppStrings.BLINK:
          controller.ekycStateStorage.blinkImageByte = base64;
          break;
        default:
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBase64(widget.type == AppStrings.FRONT
        ? controller.frontImage.value
        : widget.type == AppStrings.BACK
            ? controller.backImage.value
            : widget.type == AppStrings.TILTED
                ? controller.tilted.value
                : widget.type == AppStrings.SELFIE
                    ? controller.selfie.value
                    : controller.blink.value);
    widget.type == AppStrings.FRONT
        ? controller.frontImageByte(base64)
        : widget.type == AppStrings.BACK
            ? controller.backImageByte(base64)
            : widget.type == AppStrings.TILTED
                ? controller.tiltedByte(base64)
                : widget.type == AppStrings.SELFIE
                    ? controller.selfieByte(base64)
                    : controller.blinkByte(base64);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                leading: const SizedBox(),
                backgroundColor: const Color(0xffEFEFEF),
              ),
              if (base64 != "")
                Container(
                  width: double.infinity,
                  color: const Color(0xffD4D7DC),
                  child: Image.memory(
                    base64Decode(base64),
                    height: 245.h,
                    fit: BoxFit.fitHeight,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  color: const Color(0xffD4D7DC),
                  child: CachedNetworkImage(
                    imageUrl: widget.type == AppStrings.FRONT
                        ? controller.kyclog.value.frontImage ?? ""
                        : widget.type == AppStrings.BACK
                            ? controller.kyclog.value.backImage ?? ""
                            : widget.type == AppStrings.TILTED
                                ? controller.kyclog.value.tiltedImage ?? ""
                                : widget.type == AppStrings.SELFIE
                                    ? controller.kyclog.value.profileImage ?? ""
                                    : controller.kyclog.value.blinkImage ?? "",
                    height: 225,
                    fit: BoxFit.fitHeight,
                  ),
                ),

              // Image.file(
              //   File(
              //     widget.type == AppStrings.FRONT
              //         ? controller.frontImage.value
              //         : widget.type == AppStrings.BACK
              //             ? controller.backImage.value
              //             : widget.type == AppStrings.TILTED
              //                 ? controller.tilted.value
              //                 : controller.selfie.value,
              //   ),
              //   // fit: BoxFit.fitWidth,
              //   // width: 393,
              //   // height: 393,
              //   width: double.infinity,
              // ),
              SizedBox(
                height: 28.h,
              ),
              const RPadding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  """Check the following items and click Next button""",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 28.r,
              ),
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Image.asset(
                  "packages/flutter_pkg/assets/instructions.png",
                  // height: 386,
                ),
              ),

              SizedBox(
                height: Get.height * .25,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: REdgeInsets.symmetric(horizontal: 30.0, vertical: 34),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 44.h,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          primary: Theme.of(context).primaryColor),
                      onPressed: () async {
                        showLoading(context);

                        if (base64 != "") {
                          try {
                            /// is online
                            /// throws socket exception
                            var isConnected =
                                await InternetAddress.lookup('www.google.com');
                            var result =
                                await controller.updateState(widget.type);
                            controller.logProvider.sendLog(
                                "Saved ${widget.type}",
                                funcName: "Proceeding next",
                                label: "Completed ${widget.type}",
                                errorMsg: "Saved ${widget.type} image.");
                            Navigator.pop(context);
                            if (result != null) {
                              if (controller.isEdit.isTrue) {
                                controller.pageController.jumpToPage(17);
                                controller.isEdit(false);
                              } else {
                                controller.pageController.nextPage(
                                    duration: 300.milliseconds,
                                    curve: Curves.ease);
                              }
                            }
                          } on SocketException catch (_) {
                            Navigator.pop(context);
                            FlushbarHelper.createError(
                                    message:
                                        "Looks like you're not connected to the internet.")
                                .show(context);
                          } catch (e) {
                            Navigator.pop(context);
                            FlushbarHelper.createError(message: 'Server Error')
                                .show(context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text(e.toString())));
                          }
                        } else {
                          if (controller.isEdit.isTrue) {
                            controller.pageController.jumpToPage(17);
                            controller.isEdit(false);
                          } else {
                            controller.pageController.nextPage(
                                duration: 300.milliseconds, curve: Curves.ease);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        AppStrings.NEXT,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  height: 16.h,
                ),
                if (widget.isBlink == false)
                  SizedBox(
                    height: 44.h,
                    width: double.infinity,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromRGBO(116, 116, 116, 0.8)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8).r),
                            primary: Colors.black),
                        onPressed: () {
                          controller.logProvider.sendLog("Retake Picture",
                              funcName: "ConfirmationPage->retakePicture()",
                              label: "EKYC ${widget.type}",
                              errorMsg: "Recapture ${widget.type} image.");
                          controller.pageController.previousPage(
                              duration: 300.milliseconds, curve: Curves.ease);
                        },
                        child: Text(
                          AppStrings.RETAKE,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        )),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
