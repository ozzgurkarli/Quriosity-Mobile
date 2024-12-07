// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quriosity/dto/DTOUser.dart';

class Pool {
  static DTOUser User = DTOUser();
  static RemoteMessage? NotificationMessage;
}