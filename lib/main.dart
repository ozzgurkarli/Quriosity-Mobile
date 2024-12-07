// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quriosity/S-SPLSHSCR/SPLSHSCR.dart';
import 'package:quriosity/api/ENV.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Localizer.index = await HelperMethods.GetIndex();

  await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (Platform.isIOS) {
    try {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        await _firebaseMessaging.getToken().then((value) {
          ENV.NotificationToken = value;
        });
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          await _firebaseMessaging.getToken().then((value) {
            ENV.NotificationToken = value;
          });
        }
      }
    } catch (e) {}
  } else {
    await _firebaseMessaging.getToken().then((value) {
      ENV.NotificationToken = value;
    });
  }

  if (ENV.NotificationToken != null) {
    Pool.User.NotificationToken = ENV.NotificationToken;
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {}
  });
  String uid = await HelperMethods.Getuid();
  String Username = await HelperMethods.GetUsername();

  if (uid.isNotEmpty && Username.isNotEmpty) {
    Pool.User.uid = uid;
    Pool.User.Username = Username;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String uid = await HelperMethods.Getuid();
  String Username = await HelperMethods.GetUsername();

  if (uid.isNotEmpty && Username.isNotEmpty) {
    Pool.User.uid = uid;
    Pool.User.Username = Username;
  }
}

void handleMessage(RemoteMessage? message) {
  if (message == null) {
    return;
  }

  Pool.NotificationMessage = message;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
