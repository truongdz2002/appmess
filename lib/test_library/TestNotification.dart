import 'dart:async';
import 'dart:convert';

import 'package:appmess/service/ChatService.dart';
import 'package:appmess/test_library/NotificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart';



class TestNotification extends StatefulWidget {
  const TestNotification({super.key});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {

  final NotificationController nt=NotificationController();
  @override
  void initState() {
    super.initState();
    nt.requestFirebaseToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? title= message.notification!.title;
      String? body= message.notification!.body;
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              // -1 is replaced by a random number
              channelKey: 'chanel 1',
              title: title,
              body: body,
              fullScreenIntent: true,
              wakeUpScreen: true,
              largeIcon:'asset://assets/imagesgai.jpg',
              notificationLayout: NotificationLayout.BigText,
              payload: {'notificationId': '1234567890'}),

          actionButtons: [
            NotificationActionButton(
                key: 'REPLY',
                label: 'Reply Message',
                requireInputText: true,
                actionType: ActionType.SilentAction,
                autoDismissible: true
            ),
            NotificationActionButton(
                key: 'DISMISS',
                label: 'Dismiss',
                actionType: ActionType.DismissAction,
                isDangerousOption: true)
          ]);

    });
  }
  // static void listenToMessages(String userId, String otherUserId) {
  //   ChatService chatService=ChatService();
  //   chatService.getMessages(userId, otherUserId).listen((QuerySnapshot snapshot) {
  //     List<DocumentSnapshot> messageDocs = snapshot.docs;
  //     List<String> newMessages = messageDocs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       bool seen = data['seen'] as bool;
  //       if(seen==false)
  //       {
  //         return data['message'] as String;
  //       }
  //       return '';
  //     }).toList();
  //     createNewNotification('Đỗ Đăng Trường','asset://assets/imagesgai.jpg',newMessages);
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //NotificationController.listenToMessages( 'cRhx9fhVHAhYGCyQrcUMV156hnC3','bDmnggVGPFM22DgdSRCKJbIUOX02');
            //showReplyNotification();
          },
          child: Text('Show Notification'),
        ),
      ),
    );
  }



}