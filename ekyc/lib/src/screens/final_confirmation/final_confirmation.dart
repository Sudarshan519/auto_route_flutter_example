import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/models/document_upload.dart';
import 'package:flutter_pkg/src/screens/final_confirmation/kyc_success_page.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DocumentConfirmation extends StatefulWidget {
  const DocumentConfirmation({
    Key? key,
    required this.cardNumber,
    required this.selectedCard,
  }) : super(key: key);
  final String cardNumber, selectedCard;
  @override
  State<DocumentConfirmation> createState() => _DocumentConfirmationState();
}

class _DocumentConfirmationState extends State<DocumentConfirmation> {
  MainController controller = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cstyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp);
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(
                                  "Exit eKyc",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 20.sp),
                                ),
                                content: Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Are you sure you want to exit ?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 20.sp),
                                      ),
                                      SizedBox(
                                        height: 18.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 40.h,
                                              child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                          foregroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text(
                                                    "Continue",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontSize: 14.sp),
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.h,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                                height: 40.h,
                                                child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            foregroundColor:
                                                                Colors.red),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      controller.logProvider.sendLog(
                                                          "Exit EKYC",
                                                          funcName:
                                                              "DocumentVerificationPage->submit()",
                                                          errorMsg:
                                                              "Ekyc quit by user");
                                                      Get.delete<
                                                          MainController>();

                                                      // Get.put(
                                                      //     MainController(widget.token));
                                                    },
                                                    child: Text(
                                                      "Exit",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontSize: 14.sp,
                                                              color:
                                                                  Colors.red),
                                                    ))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                      // Navigator.pop(context), Navigator.pop(context)
                    },
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10).r),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),

                ///
                SizedBox(
                  height: 40.h,
                ),

                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Confirmation",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9).r,
                      border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.2))),
                  child: Row(children: [
                    Expanded(
                      child: RPadding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              AppStrings
                                  .cards[int.parse(widget.selectedCard) - 1],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: const Color.fromRGBO(0, 0, 0, 0.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      width: 1.w,
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                      child: RPadding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card No.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              controller.kyclog.value.cardNumber ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: const Color.fromRGBO(0, 0, 0, 0.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 34.h,
                ),
                if (controller.kyclog.value.state != AppStrings.INIT &&
                    controller.kyclog.value.frontImage != '') ...[
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        StacketImageWidget(
                            onTap: () {
                              controller.isEdit(true);
                              controller.pageController.jumpToPage(1);
                            },
                            image: controller.kyclog.value.frontImage!),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Front of the Card",
                    style: cstyle,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(
                  height: 32.h,
                ),
                if (controller.kyclog.value.state != AppStrings.INIT &&
                    controller.kyclog.value.state != AppStrings.FRONT &&
                    controller.kyclog.value.tiltedImage != '') ...[
                  StacketImageWidget(
                      onTap: () {
                        controller.isEdit(true);
                        controller.pageController.jumpToPage(4);
                      },
                      image: controller.kyclog.value.tiltedImage ?? ""),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Oblique (45 degree)",
                    style: cstyle,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
                if (controller.kyclog.value.state != AppStrings.INIT &&
                    controller.kyclog.value.state != AppStrings.FRONT &&
                    controller.kyclog.value.state != AppStrings.TILTED &&
                    controller.kyclog.value.backImage != '') ...[
                  StacketImageWidget(
                      onTap: () {
                        controller.isEdit(true);
                        controller.pageController.jumpToPage(7);
                      },
                      image: controller.kyclog.value.backImage!),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Back of the Card", style: cstyle),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
                if (controller.kyclog.value.state != AppStrings.INIT &&
                    controller.kyclog.value.state != AppStrings.FRONT &&
                    controller.kyclog.value.state != AppStrings.TILTED &&
                    controller.kyclog.value.state != AppStrings.BACK &&
                    controller.kyclog.value.profileImage != '') ...[
                  Container(
                    width: double.infinity,
                    color: const Color.fromRGBO(212, 215, 220, 1),
                    child: StacketImageWidget(
                      image: controller.kyclog.value.profileImage!,
                      isSelfie: true,
                      onTap: () {
                        controller.isEdit(true);
                        controller.pageController.jumpToPage(10);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Selfie", style: cstyle),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
                if (controller.kyclog.value.state != AppStrings.INIT &&
                    controller.kyclog.value.state != AppStrings.FRONT &&
                    controller.kyclog.value.state != AppStrings.TILTED &&
                    controller.kyclog.value.state != AppStrings.BACK &&
                    controller.kyclog.value.state != AppStrings.SELFIE &&
                    controller.kyclog.value.blinkImage != '') ...[
                  Container(
                    width: double.infinity,
                    color: const Color.fromRGBO(212, 215, 220, 1),
                    child: StacketImageWidget(
                      isSelfie: true,
                      image: controller.kyclog.value.blinkImage!,
                      onTap: () {
                        controller.pageController.jumpToPage(12);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Blink", style: cstyle),
                ],
                SizedBox(
                  height: 40.r,
                ),
                Container(
                  margin: REdgeInsets.symmetric(horizontal: 22),
                  height: 40.h,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8).r),
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        if (controller.kyclog.value.state != AppStrings.INIT &&
                            controller.kyclog.value.state != AppStrings.FRONT &&
                            controller.kyclog.value.state !=
                                AppStrings.TILTED &&
                            controller.kyclog.value.state != AppStrings.BACK &&
                            controller.kyclog.value.state !=
                                AppStrings.SELFIE &&
                            controller.kyclog.value.blinkImage != "") {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Center(
                                            child: CircularProgressIndicator()),
                                      ],
                                    ),
                                  ));
                          final DocumentUpload documentUpload = DocumentUpload(
                              cardNumber: controller.kyclog.value.cardNumber,
                              kycType: controller.kyclog.value.kycType,
                              frontImage: controller.kyclog.value.frontImage,
                              backImage: controller.kyclog.value.backImage,
                              tiltedImage: controller.kyclog.value.tiltedImage,
                              profileImage:
                                  controller.kyclog.value.profileImage,
                              blinkImage: controller.kyclog.value.blinkImage);

                          try {
                            var result =
                                await controller.uploadImage(documentUpload);

                            if (result['status']) {
                              try {
                                await controller.updateFinishedKycState();
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const KycSuccessPage()));
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                                  SnackBar(content: Text(result.toString())));
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        } else {
                          switch (controller.kyclog.value.state) {
                            case AppStrings.FRONT:
                              controller.pageController.jumpToPage(4);
                              break;
                            case AppStrings.TILTED:
                              controller.pageController.jumpToPage(7);
                              break;
                            case AppStrings.BACK:
                              controller.pageController.jumpToPage(10);
                              break;
                            case AppStrings.SELFIE:
                              controller.pageController.jumpToPage(11);
                              break;
                            case AppStrings.BLINK:
                              if (controller.kyclog.value.blinkImage != "") {
                                controller.pageController.jumpToPage(14);
                              } else {
                                controller.pageController.jumpToPage(12);
                              }
                              break;

                            default:
                              controller.pageController.jumpToPage(0);
                              break;
                          }
                        }
                      },
                      child: Text(
                        controller.kyclog.value.state != AppStrings.INIT &&
                                controller.kyclog.value.state !=
                                    AppStrings.FRONT &&
                                controller.kyclog.value.state !=
                                    AppStrings.TILTED &&
                                controller.kyclog.value.state !=
                                    AppStrings.BACK &&
                                controller.kyclog.value.state !=
                                    AppStrings.SELFIE &&
                                controller.kyclog.value.blinkImage != ""
                            ? "Submit"
                            : "Continue",
                        style: buttonStyle,
                      )),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StacketImageWidget extends StatelessWidget {
  const StacketImageWidget(
      {Key? key,
      required this.image,
      required this.onTap,
      this.isSelfie = false})
      : super(key: key);

  final String image;
  final Function() onTap;
  final bool isSelfie;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245.h,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: image,
              // height: 225.h,
              width: double.infinity,
              fit: isSelfie ? BoxFit.fitHeight : BoxFit.cover,
            ),
          ),
          Positioned(
            right: 10.r,
            top: 10.r,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 30.r,
                width: 30.r,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    // border: Border.all(color: Colors.grey.shade400),
                    boxShadow: [BoxShadow(color: Colors.grey.shade400)]),
                child: Icon(
                  Icons.edit,
                  size: 20.r,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
