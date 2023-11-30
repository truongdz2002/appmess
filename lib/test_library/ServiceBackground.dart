// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:appmess/main.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
//
// import '../firebase_options.dart';
// import 'NotificationController.dart';
// class BackgroundService {
//   static Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//
//     /// OPTIONAL, using custom notification channel id
//
//
//     if (Platform.isIOS || Platform.isAndroid) {
//       NotificationController.initializeNotifications();
//     }
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         onStart: onStart,
//         // auto start service
//         autoStart: true,
//         isForegroundMode: false,
//         notificationChannelId: 'alerts',
//       ),
//       iosConfiguration: IosConfiguration(
//         // auto start service
//         autoStart: true,
//         // this will be executed when app is in foreground in separated isolate
//         onForeground: onStart,
//         // you have to enable background fetch capability on xcode project
//         onBackground: onIosBackground,
//       ),
//     );
//
//     service.startService();
//   }
// }
//   @pragma('vm:entry-point')
//   Future<bool> onIosBackground(ServiceInstance service) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     DartPluginRegistrant.ensureInitialized();
//     return true;
//   }
//   @pragma('vm:entry-point')
//   void onStart(ServiceInstance service) async {
//     // Only available for flutter 3.0.0 and later
//     DartPluginRegistrant.ensureInitialized();
//
//     // For flutter prior to version 3.0.0
//     // We have to register the plugin manually
//     /// OPTIONAL when use custom notification
//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });
//
//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }
//
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//
//     // bring to foreground
//     Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (service is AndroidServiceInstance) {
//         //if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         //  NotificationController.listenToMessages( 'cRhx9fhVHAhYGCyQrcUMV156hnC3','bDmnggVGPFM22DgdSRCKJbIUOX02');
//         //}
//       }
//
//       /// you can see this log in logcat
//
//       // test using external plugin
//       final deviceInfo = DeviceInfoPlugin();
//       String? device;
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         device = androidInfo.model;
//       }
//
//       if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         device = iosInfo.model;
//       }
//
//       // service.invoke(
//       //   'update',
//       //   {
//       //     "current_date": DateTime.now().toIso8601String(),
//       //     "device": device,
//       //   },
//       // );
//     });
//   }
