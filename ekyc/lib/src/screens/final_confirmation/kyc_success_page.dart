import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KycSuccessPage extends StatefulWidget {
  const KycSuccessPage({Key? key}) : super(key: key);

  @override
  State<KycSuccessPage> createState() => _KycSuccessPageState();
}

class _KycSuccessPageState extends State<KycSuccessPage> {
  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 45.r,
            backgroundColor: const Color(0xffE4F6F0),
            child: Icon(
              Icons.check_circle,
              size: 80.r,
              color: const Color(0xff32C993),
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          Text(
            """Online identity verification 
have been completed.""",
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 120.h,
          ),
          Container(
            margin: REdgeInsets.symmetric(horizontal: 66),
            width: double.infinity,
            height: 55.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8).r),
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop({
                  "front": controller
                      .kyclog.value.frontImage, // controller.frontImage.value,
                  "tilted": controller
                      .kyclog.value.tiltedImage, // controller.tilted.value,
                  "back": controller
                      .kyclog.value.backImage, //controller.backImage.value,
                  "liveliness": true,
                  "selfie": controller
                      .kyclog.value.profileImage, //controller.selfie.value,
                  "statelog": controller.kyclog.value
                });
              },
              child: const Text("Proceed"),
            ),
          ),
        ],
      ),
    );
  }
}
