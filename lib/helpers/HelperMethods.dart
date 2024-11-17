// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';
import 'package:quriosity/api/ENV.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class HelperMethods {
  static Widget ShowAsset(String path, {double? height, double? width}) {
    return Image.asset(
      path,
      height: height ?? USize.Height,
      width: width ?? USize.Width,
      fit: BoxFit.fill,
    );
  }

  static String CalculateLastActivityTime(DateTime date) {
    Duration dif = DateTime.now().difference(date);

    if (dif.inDays > 0) {
      return dif.inDays > 30
          ? dif.inDays > 365
              ? "${dif.inDays ~/ 365}y"
              : "${dif.inDays ~/ 30}${Localizer.Get(Localizer.shortened_month)}"
          : "${dif.inDays}${Localizer.Get(Localizer.shortened_day)}";
    } else if (dif.inHours > 0) {
      return "${dif.inHours}${Localizer.Get(Localizer.shortened_hour)}";
    } else if (dif.inMinutes > 0) {
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

  static InsertData() async {
    var sp = await SharedPreferences.getInstance();

    sp.setString("uid", Pool.User.uid!);
    sp.setString("Username", Pool.User.Username!);
  }

  static DeleteData() async {
    var sp = await SharedPreferences.getInstance();

    await sp.remove("uid");
    await sp.remove("Username");
  }

  static Future<String> Getuid() async {
    var sp = await SharedPreferences.getInstance();

    return sp.getString("uid") ?? "";
  }

  static Future<String> GetUsername() async {
    var sp = await SharedPreferences.getInstance();

    return sp.getString("Username") ?? "";
  }

  static SetLastOpenedDate(String Type, String CommunityId, DateTime time) async {
    var sp = await SharedPreferences.getInstance();
    sp.setInt(Type+CommunityId, time.millisecondsSinceEpoch);
    return;
  }

  static Future<int> GetLastOpenedDate(String Type, String CommunityId) async {
    var sp = await SharedPreferences.getInstance();

    return sp.getInt(Type+CommunityId) ?? 0;
  }

  static Future<Database> DatabaseConnect() async {
    String dbPath = join(await getDatabasesPath(), ENV.DatabaseName);

      print(dbPath);
    if (!(await databaseExists(dbPath))) {
      ByteData data = await rootBundle.load("lib/localdb/${ENV.DatabaseName}");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(dbPath);
  }

  static InsertLocalDB(String tableName, Map<String, dynamic> data) async {
    Database db = await HelperMethods.DatabaseConnect();
    if (tableName == "MESSAGES") {
      data["MessageDate"] =
          (data["MessageDate"] as DateTime).millisecondsSinceEpoch;
    }
    else if (tableName == "QUESTIONS") {
      data["QuestionDate"] =
          (data["QuestionDate"] as DateTime).millisecondsSinceEpoch;
          String options = "";
          for (var item in data["Options"]) {
            options += item["option"]+"**//--**^^"+item["id"].toString()+"''%%/()/";
          }
          data["Options"] = options.substring(0, options.length-8);
          data.remove("InactiveUsers");
          data.remove("SenderUsername");
    }
    await db.insert(tableName, data);
  }

  static Future<List<Map<String, dynamic>>> SelectFromLocalDB(
      String query) async {
    Database db = await HelperMethods.DatabaseConnect();

    return await db.rawQuery(query);
  }

  static SetSnackBar(BuildContext context, String text,
      {bool errorBar = false,
      bool successBar = false,
      Duration duration = const Duration(seconds: 5)}) {
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
      HelperMethods.SetSnackBar(context, exception.toString().substring(11),
          errorBar: true);
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
                    color: UColor.SecondHeavyColor,
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
