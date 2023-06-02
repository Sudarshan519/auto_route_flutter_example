import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/const/strings.dart'; 
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  var loading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    void requestPermissionAndNavigate() async {
      var permissionStatus = await Permission.camera.request();
      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        controller.pageController
            .nextPage(duration: 300.milliseconds, curve: Curves.ease);
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      } else {
        requestPermissionAndNavigate();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 60.h,
                    child: Image.asset(
                      getassetPath('Mobile Frame.png'),
                      height: MediaQuery.of(context).size.height * .7,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: Center(
                      child: widget.title == AppStrings.BACK
                          ? BoundingBox(
                              image: widget.title == AppStrings.BACK
                                  ? "image 16.png"
                                  : "image 13-2.png")
                          : Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, .001)
                                ..rotateX(-45 / 180 * pi),
                              alignment: Alignment.center,
                              child: BoundingBox(
                                  image: widget.title == AppStrings.BACK
                                      ? "image 16.png"
                                      : "image 13-2.png")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: REdgeInsets.symmetric(horizontal: 30, vertical: 24),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.grey),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title == AppStrings.BACK
                  ? "Take a Photo -\n back side"
                  : widget.title == AppStrings.TILTED
                      ? """Take a Photo - 
Oblique (45 degree)"""
                      : """Take a Photo\n- Card Surface""",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              """Align your identity verification document with the specified position.""",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 24.h,
            ),
            SizedBox(
              width: Get.width,
              height: 44.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    requestPermissionAndNavigate();
                  },
                  child: Text(
                    "Launch Camera",
                    style: buttonStyle,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
