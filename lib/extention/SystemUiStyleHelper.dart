import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiStyleHelper {
  static void setSystemUiOverlayStyle(Color backgroundColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backgroundColor, // Màu nền cho thanh trạng thái
      systemNavigationBarContrastEnforced: true,
      //statusBarIconBrightness:backgroundColor==Colors.black ? Brightness.light : Brightness.dark ,
      //systemNavigationBarIconBrightness:backgroundColor==Colors.black ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: backgroundColor, // Màu nền cho thanh điều hướng
    ));
  }
}
