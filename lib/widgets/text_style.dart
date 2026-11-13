import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appTextStyle({
   String? font,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
  FontStyle? fontStyle,
  TextDecoration? decoration,
  TextOverflow? overflow,
  double? height,
}) {
  switch (font?.toLowerCase()) {
    case 'poppins':
      return GoogleFonts.poppins(
        textStyle: _buildTextStyle(
          color,
          fontSize?.sp, // 👈 Responsive font size
          fontWeight,
          letterSpacing?.w, // 👈 Responsive letter spacing
          fontStyle,
          decoration,
          overflow,
          height?.h, // 👈 Responsive line height
        ),
      );
    case 'lato':
      return GoogleFonts.lato(
        textStyle: _buildTextStyle(
          color,
          fontSize?.sp,
          fontWeight,
          letterSpacing?.w,
          fontStyle,
          decoration,
          overflow,
          height?.h,
        ),
      );
    case 'lexend':
      return GoogleFonts.lexend(
        textStyle: _buildTextStyle(
          color,
          fontSize?.sp,
          fontWeight,
          letterSpacing?.w,
          fontStyle,
          decoration,
          overflow,
          height?.h,
        ),
      );
    case 'montserrat':
    default:
      return GoogleFonts.lexend(
        textStyle: _buildTextStyle(
          color,
          fontSize?.sp,
          fontWeight,
          letterSpacing?.w,
          fontStyle,
          decoration,
          overflow,
          height?.h,
        ),
      );
  }
}

TextStyle _buildTextStyle(
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    TextOverflow? overflow,
    double? height,
    ) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    overflow: overflow,
    height: height,
  );
}
