import 'dart:async';
import 'package:appmess/firebase_options.dart';
import 'package:appmess/service/AuthGate.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:appmess/test_library/NotificationController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationController.initializeNotifications();
  FirebaseMessaging.onBackgroundMessage(NotificationController.backgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    String? title = message.notification!.title;
    String? body =  message.notification!.body;
    List<String> messageList=[];
    messageList.add(body!);
    NotificationController.createNotification(title, messageList);
  });
  runApp(
  MultiProvider(providers: [
     ChangeNotifierProvider(create: (_)=>AuthService())
  ],child: MaterialApp(
    home: const AuthGate(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        drawerTheme: const DrawerThemeData(
          scrimColor: Colors.transparent,
        )
    ),
  ))
    ) ;
}



