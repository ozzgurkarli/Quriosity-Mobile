import 'package:flutter/material.dart';
import 'package:quriosity/S-SPLSHSCR/SPLSHSCR.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    USize.Height = MediaQuery.of(context).size.height;
    USize.Width = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: UColor.PrimaryColor),
        scaffoldBackgroundColor: UColor.PrimaryColor,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SPLSHSCR(),
    );
  }
}
