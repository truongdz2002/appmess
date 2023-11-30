import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ServiceDevice {
  static Stream<ConnectivityResult> checkConnectivity() {
    return Connectivity().onConnectivityChanged;
  }
  static Stream<Brightness> themeChangeStream(BuildContext context) {
    return Stream.fromFuture(Future.value(MediaQuery.of(context).platformBrightness));
  }
}
