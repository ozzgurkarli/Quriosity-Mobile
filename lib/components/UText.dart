// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriosity/helpers/UColor.dart';

class UText extends StatelessWidget {
  String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  bool? googleFonts;

  UText(this.text, {super.key, this.color, this.fontSize, this.fontWeight, this.googleFonts});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: googleFonts == true ? GoogleFonts.rubikWetPaint(
          color: color ?? UColor.WhiteColor,
          fontSize: fontSize ?? 15,
          fontWeight: fontWeight ?? FontWeight.normal) : TextStyle(
          color: color ?? UColor.WhiteColor,
          fontSize: fontSize ?? 15,
          fontWeight: fontWeight ?? FontWeight.normal)
    );
  }
}
