// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quriosity/S-LOGINACC/LOGINACC.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class SPLSHSCR extends StatefulWidget {
  const SPLSHSCR({super.key});

  @override
  State<SPLSHSCR> createState() => _SPLSHSCRState();
}

class _SPLSHSCRState extends State<SPLSHSCR> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3, milliseconds: 333), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LOGINACC()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColor.PrimaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HelperMethods.ShowAsset(UAsset.LOGO_GIF,
              height: USize.Height / 5, width: USize.Height / 5),
              SizedBox(height: USize.Height/13,),
          UText("QURIOSITY", fontSize: 30, fontWeight: FontWeight.w800, googleFonts: true,),
              SizedBox(height: USize.Height/91,),
          UText("Your Questions,\nYour Community.", fontWeight: FontWeight.w500,),
        ],
      )),
    );
  }
}
