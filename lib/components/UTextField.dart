// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class UTextField extends StatelessWidget {
  TextEditingController controller;
  TextInputType? keyboardType;
  double? width;
  bool? obsecureText;
  Function(String)? onChanged;
  Function(String)? onSubmitted1;
  Function(PointerDownEvent)? onSubmitted2;
  Function()? onTap;
  bool? readOnly;
  String? hintText;
  Widget? prefixIcon;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry? contentPadding;
  BoxConstraints? constraints;
  TextCapitalization? textCapitalization;
  Color? prefixColor;
  Color? fillColor;
  Widget? suffixIcon;
  double? fontSize;
  String? errorText;
  int? maxLength;
  UTextField(
      {required this.controller,
      this.keyboardType,
      super.key,
      this.obsecureText,
      this.width,
      this.readOnly,
      this.hintText,
      this.prefixColor,
      this.textCapitalization,
      this.onChanged,
      this.prefixIcon,
      this.fillColor,
      this.fontSize,
      this.onSubmitted1,
      this.contentPadding,
      this.constraints,
      this.onSubmitted2,
      this.errorText,
      this.inputFormatters,
      this.onTap,
      this.suffixIcon,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? USize.Width * 0.7,
      child: TextField(
        maxLength: maxLength,
        onChanged: onChanged,
        controller: controller,
        onTap: onTap,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        style: TextStyle(fontSize: fontSize ?? 15, fontWeight: FontWeight.w500),
        obscureText: obsecureText ?? false,
        onSubmitted: onSubmitted1,
        onTapOutside: onSubmitted2,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(12, 16, 12, 8),
          constraints: constraints,
            filled: fillColor != null,
            isDense: true,
            fillColor: errorText != null ? UColor.RedLightColor : fillColor,
            hintText: hintText,
            alignLabelWithHint: true,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: USize.Width * 0.05),
              child: prefixIcon,
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
            errorStyle: const TextStyle(
                color: UColor.RedHeavyColor,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(color: UColor.RedHeavyColor, width: 3)),
            prefixIconColor:
                errorText != null ? UColor.RedHeavyColor : prefixColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
