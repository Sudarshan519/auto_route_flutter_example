import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/flutter_pkg.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_document_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

getassetPath(t) => 'packages/flutter_pkg/assets/$t';
TextStyle buttonStyle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);

class IntroScreen extends StatefulWidget {
  const IntroScreen(
      {Key? key, required this.cardNumber, required this.selectedCard})
      : super(key: key);
  final String cardNumber;
  final String selectedCard;
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
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
              SizedBox(height: 16.h),
              Text(
                "Three types of identity verification documents will be taken.",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),
              DocumentInfo(
                  image: getassetPath('front.png'),
                  title: "Surface",
                  desc: "instructions goes here"),
              SizedBox(height: 16.h),
              DocumentInfo(
                  image: getassetPath('front.png'),
                  title: "Oblique\n(45 degree)",
                  desc: "instructions goes here"),
              SizedBox(height: 16.h),
              DocumentInfo(
                  image: getassetPath('back.png'),
                  title: "Back",
                  desc: "instructions goes here"),
              SizedBox(height: 16.h),
              Text(
                "* Photographed from an angle to capture the thickness of the document.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
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
                      showLoading(context);

                      // await controller.uploadCardTypeAndCardNumber(
                      //     widget.selectedCard, widget.cardNumber);
                      Navigator.pop(context);
                      controller.pageController.nextPage(
                          duration: 300.milliseconds, curve: Curves.ease);
                    },
                    child: Text(
                      "Start KYC Verification",
                      style: buttonStyle,
                    )),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialSecond extends StatelessWidget {
  const TutorialSecond({Key? key}) : super(key: key);

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
                      height: MediaQuery.of(context).size.height * .6,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: const Center(
                      child: BoundingBox(image: "image 13-2.png"),
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
        // height: 250,
        // width: 393,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              """Take a Photo\n- Card Surface""",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 16,
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
                          borderRadius: BorderRadius.circular(10.r)),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    requestPermissionAndNavigate();
                    // List<CameraDescription> cameras = await availableCameras();
                    // controller.pageController.nextPage(
                    //     duration: 300.milliseconds, curve: Curves.ease);
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

class BoundingBox extends StatelessWidget {
  const BoundingBox(
      {Key? key,
      this.color = Colors.black,
      this.hasChild = true,
      this.image,
      this.height,
      this.width})
      : super(key: key);
  final Color color;
  final bool hasChild;
  final double? height;
  final double? width;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (hasChild ? 120.h : 180.h),
      width: width ?? (hasChild ? 160.h : Get.width - 60.w),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              child: Image.asset(
                  getassetPath(
                    'Frame-4.png',
                  ),
                  color: color,
                  height: 20.r,
                  width: 20.r)),
          Positioned(
              top: 0,
              child: Image.asset(
                  getassetPath(
                    'Frame-2.png',
                  ),
                  color: color,
                  height: 20.r,
                  width: 20.r)),
          Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                  getassetPath(
                    'Frame-3.png',
                  ),
                  color: color,
                  height: 20.r,
                  width: 20.r)),
          Positioned(
              bottom: 0,
              child: Image.asset(
                  getassetPath(
                    'box.png',
                  ),
                  color: color,
                  height: 20.r,
                  width: 20.r)),
          if (hasChild)
            Center(
              child: RPadding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  getassetPath(image),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
