library flutter_pkg;

import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/models/state_log.dart';
import 'package:flutter_pkg/src/screens/capture/capture.dart';
import 'package:flutter_pkg/src/screens/confirmation/confirmation.dart';
import 'package:flutter_pkg/src/screens/final_confirmation/final_confirmation.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_pkg/src/screens/liveliness/face_detectionMLKit.dart';
import 'package:flutter_pkg/src/screens/liveliness/liveliness.dart';
import 'package:flutter_pkg/src/screens/tutorial/liveliness_tutorial.dart';
import 'package:flutter_pkg/src/screens/tutorial/selfie_tutorial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'screens/tutorial/tutorial.dart';

class DocumentVerification extends StatefulWidget {
  const DocumentVerification(
      {Key? key,
      required this.selectedCard,
      required this.cardNumber,
      required this.state,
      required this.showContinueDialog})
      : super(key: key);
  final String cardNumber;
  final String selectedCard;
  final KycStateLog state;
  final bool showContinueDialog;
  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  late MainController mainController;
  @override
  void initState() {
    super.initState();
    mainController = Get.put(MainController());
    mainController.kyclog(widget.state);
    mainController.pageController = PageController();
    if (widget.showContinueDialog) {
      if (widget.state != null) checkForSavedState();
    }
  }

  checkForSavedState() async {
    await mainController.uploadCardTypeAndCardNumber(
        widget.selectedCard, widget.cardNumber);
    await Future.delayed(Duration.zero);
    showLoading(context);
    var savedState = -1; //await mainController.loadState();

    Navigator.of(context).pop();
    if (widget.state?.state != "") {
      if (savedState == -1 || savedState != -1) {
        var result = false;
        try {
          result = await confirmRestartDialog();
        } catch (e) {}
        if (widget.state != null && result) {
          switch (widget.state?.state ?? "") {
            // case AppStrings.FRONT:
            //   mainController.pageController.jumpToPage(3);
            //   break;
            // case AppStrings.BACK:
            //   mainController.pageController.jumpToPage(6);
            //   break;
            // case AppStrings.TILTED:
            //   mainController.pageController.jumpToPage(9);
            //   break;
            // case AppStrings.SELFIE:
            //   mainController.pageController.jumpToPage(11);
            //   break;
            // case AppStrings.BLINK:
            //   mainController.pageController.jumpToPage(14);
            //   break;

            ///
            case "":
              mainController.pageController.jumpToPage(0);
              break;
            case AppStrings.INIT:
              // mainController.pageController.jumpToPage(0);
              mainController.pageController.jumpToPage(17);
              break;
            default:
              mainController.pageController.jumpToPage(17);
          }
        } else {}
      } else {
        if (savedState != -1) {
          var result = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(
                      "You have unfinished ekyc",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20.sp),
                    ),
                    content: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Do you want to continue ?",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 14.sp),
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
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        "Continue",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 14.sp),
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
                                        style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);

                                          mainController.ekycStateStorage
                                              .clearAllState();
                                        },
                                        child: Text(
                                          "Restart",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  color: Colors.red),
                                        ))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));

          if (result && result != null) {
            switch (savedState) {
              case 0:
                mainController.pageController.jumpToPage(3);
                break;
              case 1:
                mainController.pageController.jumpToPage(6);
                break;
              case 2:
                mainController.pageController.jumpToPage(9);
                break;
              case 3:
                mainController.pageController.jumpToPage(11);
                break;
              case 4:
                mainController.pageController.jumpToPage(13);
                break;
              case 5:
                mainController.pageController.jumpToPage(17);
                break;
              default:
                Navigator.of(context).pop();
                break;
            }
          } else {}
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      IntroScreen(
          cardNumber: widget.cardNumber, selectedCard: widget.selectedCard),
      const TutorialSecond(),
      const CaptureImage(type: AppStrings.FRONT),
      const Confirmation(type: AppStrings.FRONT),
      const Tutorial(title: AppStrings.TILTED),
      const CaptureImage(type: AppStrings.TILTED),
      const Confirmation(type: AppStrings.TILTED),
      const Tutorial(title: AppStrings.BACK),
      const CaptureImage(type: AppStrings.BACK),
      const Confirmation(type: AppStrings.BACK),
      const SelfieTutorial(),
      const FaceDetectionMlKit(),
      const Confirmation(type: AppStrings.SELFIE),
      const LivelinessTutorial(),
      const LivelinessMlKit(),
      const Confirmation(type: AppStrings.BLINK, isBlink: true),
      DocumentConfirmation(
          cardNumber: widget.cardNumber, selectedCard: widget.selectedCard)
    ];
    ScreenUtil.init(
      context,
      minTextAdapt: true,
      designSize: const Size(393, 852),
    );
    return PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: mainController.pageController,
        itemCount: pages.length,
        onPageChanged: (int page) {
          mainController.currentPage(page);
        },
        itemBuilder: (_, i) => WillPopScope(
            child: pages[i],
            onWillPop: () async {
              var willPop = await confirmExitDialog();
              return willPop ?? false;
            }));
  }

  confirmRestartDialog() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                "You have unfinished ekyc",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20.sp),
              ),
              content: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Do you want to continue ?",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.sp),
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
                                style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  "Continue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 14.sp),
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
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    mainController.ekycStateStorage
                                        .clearAllState();
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "Restart",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize: 14.sp, color: Colors.red),
                                  ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  confirmExitDialog() {
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
                                style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  "Continue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 14.sp),
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
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                    mainController.logProvider.sendLog(
                                        "Exit EKYC",
                                        funcName:
                                            "DocumentVerificationPage->submit()",
                                        errorMsg: "Ekyc quit by user");
                                    Get.delete<MainController>();

                                    // Get.put(
                                    //     MainController(widget.token));
                                  },
                                  child: Text(
                                    "Exit",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize: 14.sp, color: Colors.red),
                                  ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}

void showLoading(context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [CircularProgressIndicator()],
            ),
          ));
}
