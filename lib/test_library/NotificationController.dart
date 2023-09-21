import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotificationController {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'chanel chat',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
  }

  Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
        print('==================FCM Token==================');
        print(token);
        print('======================================');
        return token;
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }

  static Future<void> createNotification(String? title, List<String> messageList) async {
   List<String> messageListnew = ["Tin nhắn 1", "Tin nhắn 2", "Tin nhắn 3"];
    String messageText = messageListnew.join('\n');
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            // -1 is replaced by a random number
            channelKey: 'chanel chat',
            title: title,
            body: messageText,
            largeIcon: 'asset://assets/imagesgai.jpg',
            notificationLayout: NotificationLayout.Inbox,
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
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    String? title = message.notification!.title;
    String? body = message.notification!.body;
    List<String> messageList=[];
    messageList.add(body!);
    createNotification(title, messageList);
  }
   static Future<void> sendAndroidNotification(String nameUser,String message,String token) async {
    try {
      final response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAAYjK7krc:APA91bHELFknmMBbSSMAAEVbmvalMLFHAi0DiI5BklS0P2F3VUUBYvVH_FCi_iOngGHbpLQ4UZzSk6NoC2-xq6NfLgPJZ7y4ebNhZ8ldsOCMImoG0TMG2i9f1RrXQmAWlIlsLut3v5Tx',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': message,
              'title': nameUser,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to':token,
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
}