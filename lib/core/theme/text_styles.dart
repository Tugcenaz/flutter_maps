import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle titleWhiteTextStyle1(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return GoogleFonts.alike(
        color: color ?? Colors.white,
        fontSize: fontSize ?? 24.sp,
        fontWeight: fontWeight ?? FontWeight.w700);
  }

  static TextStyle titleBlackTextStyle1(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return GoogleFonts.alike(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.w500);
  }
}
