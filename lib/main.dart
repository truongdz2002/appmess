import 'dart:async';
import 'dart:convert';
import 'package:appmess/models/Message.dart';
import 'package:appmess/firebase_options.dart';
import 'package:appmess/provider/ClickItemOptionImage.dart';
import 'package:appmess/provider/HideTitleChatScreen.dart';
import 'package:appmess/provider/ShowEmoji.dart';
import 'package:appmess/provider/ShowImageGallery.dart';
import 'package:appmess/provider/ShowKeyBoard.dart';
import 'package:appmess/provider/ThemeModeProvider.dart';
import 'package:appmess/provider/processingListMessage.dart';
import 'package:appmess/provider/processingListMessageSeen.dart';
import 'package:appmess/provider/theme.dart';
import 'package:appmess/provider/updateCheckConnect.dart';
import 'package:appmess/screen/SplashScreen.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:appmess/test_library/NotificationController.dart';
import 'package:appmess/theme/dartTheme.dart';
import 'package:appmess/theme/lightTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/OptionImageSend.dart';
import 'provider/imageGalleryProvider.dart';
import 'provider/processGroupOption.dart';

late Size mq;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationController.initializeNotifications();
  AuthService.updateIsOnline(true);
  FirebaseMessaging.onBackgroundMessage(NotificationController.backgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    String? title = message.data['title']; // Truy cập tiêu đề từ phần "data"
    String? body = message.data['body'];
    NotificationController.messages=Message.fromJson(jsonDecode(body!));
    NotificationController.createNotification(title,NotificationController.messages!);
  });

  runApp(
  MultiProvider(providers: [
     ChangeNotifierProvider(create: (_)=>AuthService()),
    ChangeNotifierProvider(create: (_)=>ClickItemOptionImage()),
    ChangeNotifierProvider(create: (_)=>ImageGalleryProvider()),
    ChangeNotifierProvider(create: (_)=>OptionImageSend()),
    ChangeNotifierProvider(create: (_)=>ShowEmoji()),
    ChangeNotifierProvider(create: (_)=>ShowImageGallery()),
    ChangeNotifierProvider(create: (_)=>ProcessingListMessage()),
    ChangeNotifierProvider(create: (_)=>ProcessingListMessageSeen()),
    ChangeNotifierProvider(create: (_)=>ColorTheme()),
    ChangeNotifierProvider(create: (_)=>ThemeModeProvider()),
    ChangeNotifierProvider(create: (_)=>UpdateCheckConnect()),
    ChangeNotifierProvider(create: (_)=>ProcessGroupOption()),
    ChangeNotifierProvider(create: (_)=>ShowKeyBoard()),
    ChangeNotifierProvider(create: (_)=>HideTitleChatScreen()),
  ],child:const MyApp(),
    ));
}

 class MyApp extends StatelessWidget {
   const MyApp({super.key});
   @override
   Widget build(BuildContext context) {
     return  MaterialApp(
       home:  const SplashScreen(),
       debugShowCheckedModeBanner: false,
       theme: lightTheme,
       darkTheme: dartTheme,
     );
   }
 }




