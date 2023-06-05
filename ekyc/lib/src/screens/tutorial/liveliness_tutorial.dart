import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LivelinessTutorial extends StatelessWidget {
  const LivelinessTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    return Scaffold(
      body: RPadding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              getassetPath('Blink.png'),
              height: 278.h,
            ),
            SizedBox(
              height: 35.h,
            ),
            Text(
              "Blink twice 2X",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 20.h),
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                "Take selfie and blink twice (2x) and make sure your whole face is visible.",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.7)),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Get.width,
              height: 55.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    controller.pageController.nextPage(
                        duration: 300.milliseconds, curve: Curves.ease);
                  },
                  child: Text(
                    "Take Selfie",
                    style: buttonStyle,
                  )),
            ),
            SizedBox(
              height: 37.h,
            )
          ],
        ),
      ),
    );
  }
}
