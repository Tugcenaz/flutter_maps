import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomButton extends StatelessWidget {
  VoidCallback function;
  Icon icon;
  Widget text;

  MyCustomButton(
      {super.key,
      required this.function,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      height: 35.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2))),
      child: Row(
        children: [
          IconButton(
            iconSize: 24.sp,
            onPressed: () {
              function();
            },
            icon: icon,
          ),
          text,
        ],
      ),
    );
  }
}
