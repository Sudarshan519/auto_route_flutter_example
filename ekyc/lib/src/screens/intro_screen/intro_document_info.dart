import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentInfo extends StatelessWidget {
  const DocumentInfo(
      {Key? key, required this.desc, required this.title, required this.image})
      : super(key: key);
  final String title;
  final String desc;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey.shade300, offset: const Offset(1, 1))
      ], color: Colors.white, borderRadius: BorderRadius.circular(9.r)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Image.asset(
                  image,
                  height: 80.h,
                  width: 125.w,
                )),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        desc,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(33, 33, 33, 0.87)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
