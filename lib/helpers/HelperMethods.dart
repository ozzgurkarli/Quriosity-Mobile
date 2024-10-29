// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:gap/gap.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class HelperMethods {

  static Widget ShowAsset(String path, {double? height, double? width}) {
    return Image.asset(
      path,
      height: height ?? USize.Height,
      width: width ?? USize.Width,
      fit: BoxFit.fill,
    );
  }

  static String CalculateLastActivityTime(DateTime date){
    Duration dif = DateTime.now().difference(date);

    if(dif.inDays > 0){
      return dif.inDays > 30 ? dif.inDays > 365 ? "${dif.inDays~/365}y" : "${dif.inDays~/30}${Localizer.Get(Localizer.shortened_month)}" : "${dif.inDays}${Localizer.Get(Localizer.shortened_day)}";
    }
    else if(dif.inHours > 0){
      return "${dif.inHours}${Localizer.Get(Localizer.shortened_hour)}";
    }
    else if(dif.inMinutes > 0){
      return "${dif.inMinutes}${Localizer.Get(Localizer.shortened_minute)}";
    }
    
    return "${dif.inSeconds}${Localizer.Get(Localizer.shortened_second)}";
  }

  static SetLoadingScreen(BuildContext context) {
    showDialog<void>(
      barrierColor: UColor.BarrierColor,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: HelperMethods.ShowAsset(UAsset.LOADING,
              height: USize.Height / 17, width: USize.Height / 17),
        );
      },
    );
  }

  // static InsertData(String fullName, String identityNo) async {
  //   var sp = await SharedPreferences.getInstance();

  //   sp.setString("IdentityNo", identityNo);
  //   sp.setString("FullName", fullName);
  // }

  // static DeleteData() async {
  //   var sp = await SharedPreferences.getInstance();

  //   await sp.remove("IdentityNo");
  //   await sp.remove("FullName");
  // }

  // static Future<String?> GetIdentityNo() async {
  //   var sp = await SharedPreferences.getInstance();

  //   return sp.getString("IdentityNo") ?? "";
  // }

  // static Future<String?> GetFullName() async {
  //   var sp = await SharedPreferences.getInstance();

  //   return sp.getString("FullName") ?? "";
  // }

  static SetSnackBar(BuildContext context, String text,
      {bool errorBar = false,
      bool successBar = false,
      Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(USize.Height / 20),
      content: Align(alignment: Alignment.center, child: UText(text)),
      duration: duration,
      backgroundColor: errorBar
          ? UColor.RedHeavyColor
          : successBar
              ? UColor.GreenHeavyColor
              : UColor.ThirdColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      showCloseIcon: true,
      closeIconColor:
          errorBar || successBar ? UColor.WhiteColor : UColor.SecondColor,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // static SetBottomSheet(BuildContext context, String bodyText, String asset,
  //     String labelText, Widget button) {
  //   showModalBottomSheet(
  //     context: context,
  //     barrierColor: UColor.BarrierColor,
  //     backgroundColor: Colors.black,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(45), topRight: Radius.circular(45))),
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //             color: UColor.WhiteColor,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(45), topRight: Radius.circular(45))),
  //         height: USize.Height / 2.2,
  //         child: Center(
  //           child: Column(
  //             children: [
  //               Gap(USize.Height / 44),
  //               UText(
  //                 labelText,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 26,
  //               ),
  //               Gap(USize.Height / 25),
  //               HelperMethods.ShowAsset(
  //                 asset,
  //                 height: USize.Height / 8,
  //                 width: USize.Height / 8,
  //               ),
  //               Gap(USize.Height / 44),
  //               Container(
  //                   width: USize.Width * 0.75,
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     bodyText,
  //                     textAlign: TextAlign.center,
  //                   )),
  //               Gap(USize.Height / 17),
  //               button
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  static ApiException(BuildContext context, Object exception,
      {int? popUntil, GlobalKey<ShakeWidgetState>? key}) {
    if (exception is! DioException) {
      HelperMethods.SetSnackBar(context, exception.toString().substring(11), errorBar: true);
      Navigator.pop(context);
      if (key != null) {
        key.currentState?.shake();
      }
      return;
    }
    showModalBottomSheet(
      context: context,
      barrierColor: UColor.BarrierColor,
      backgroundColor: Colors.black,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: UColor.WhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45))),
          height: USize.Height / 3.3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(USize.Height / 67),
                UText(
                  Localizer.Get(Localizer.Error),
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                HelperMethods.ShowAsset(
                  UAsset.ERROR_404,
                  height: USize.Height / 8,
                  width: USize.Height / 8,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: UText(
                      exception.toString().substring(11),
                      color: Colors.black,
                    ),
                  ),
                ),
                UButton(
                    primaryButton: true,
                    onPressed: () {
                      int count = 0;
                      popUntil = popUntil ?? 2;
                      Navigator.of(context)
                          .popUntil((_) => count++ >= popUntil!);
                    },
                    child: UText(
                      Localizer.Get(Localizer.ok),
                      color: UColor.WhiteColor,
                    )),
                Gap(USize.Height / 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
