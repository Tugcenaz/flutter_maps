import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback function;
  final Icon icon;
  final Widget text;
  final double? width;
  final double? height;

  const MyCustomButton(
      {super.key,
      required this.function,
      required this.icon,
      required this.text,this.height,this.width});

  @override
  Widget build(BuildContext context) {
    return Bounceable(onTap: (){
      function();
    },
      child: Container(
        width: width??110.w,
        height: height??35.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.2))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon,
            text,
          ],
        ),
      ),
    );
  }
}
