import 'dart:convert';
import 'dart:developer';

import 'package:appmess/service/ChatService.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/Message.dart';
import '../widgets/extension.dart';

class NotificationController {
static Message? messages;
  static ReceivedAction? initialAction;
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/iconappchat',
        [
          NotificationChannel(
              channelKey: 'chanel1',
              channelName: 'Chat',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              importance: NotificationImportance.High,
              channelShowBadge: false,
              onlyAlertOnce: true,
              locked: true,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }
  static Future<void> createNotification(String? title,Message messages) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey:'chanel1',
            title: title,
            body:messages.typeMessage==Type.text ? messages.message[0] : 'Đã gửi cho bạn một hình ảnh',
            category: NotificationCategory.Message,
            roundedLargeIcon:true,
            largeIcon: 'asset://assets/imagesgai.jpg',
            notificationLayout: NotificationLayout.Inbox,),
            actionButtons: [
              NotificationActionButton(
                key: 'reply_action',
                label: 'Trả lời',
                requireInputText: true,
                actionType: ActionType.SilentAction,
              ),
              NotificationActionButton(
                key: 'dismiss_action',
                label: 'Hủy',
                actionType: ActionType.DismissAction,
                isDangerousOption: true

              ),


      ],

    );
    // AwesomeNotifications().actionStream.listen((receivedNotification) async {
    //   if (receivedNotification.buttonKeyPressed == 'reply_action') {
    //     List<String> listMessage=[receivedNotification.buttonKeyInput];
    //     await ChatService.sendMessage(receiverId: message.senderId, message: listMessage, tokenDeviceReceivers: message.tokenDeviceSender, receiverName: message.senderName, type:Type.text, tokenDeviceSender:message.tokenDeviceReceiver, senderName:message.receiverName, senderId:message.receiverId);
    //     AwesomeNotifications().cancel(receivedNotification.id!);
    //
    //     // Tiếp tục xử lý tin nhắn hoặc thực hiện các tác vụ khác tùy chỉnh
    //   } else if (receivedNotification.buttonKeyPressed == 'dismiss_action') {
    //     AwesomeNotifications().cancel(receivedNotification.id!);
    //   }
    // });
     startListeningNotificationEvents();
  }
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod:onActionReceivedMethod);
  }
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction
      ) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      await ChatService.sendMessage(receiverId: messages!.senderId, message: [receivedAction.buttonKeyInput], tokenDeviceReceivers: messages!.tokenDeviceSender, receiverName: messages!.senderName, type:Type.text, tokenDeviceSender:messages!.tokenDeviceReceiver, senderName:messages!.receiverName, senderId:messages!.receiverId);
      AwesomeNotifications().cancel(receivedAction.id!);
      FlutterToastExtension.showToast('Đang gửi câu trả lời');
      //await ChatService.sendMessage(receiverId: message.senderId, message: [receivedAction.buttonKeyInput], tokenDeviceReceivers: message.tokenDeviceSender, receiverName: message.senderName, type:Type.text, tokenDeviceSender:message.tokenDeviceReceiver, senderName:message.receiverName, senderId:message.receiverId);
      }


    }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    String? title = message.data['title']; // Truy cập tiêu đề từ phần "data"
    String? body = message.data['body'];
    messages =Message.fromJson(jsonDecode(body!));
    NotificationController.createNotification(title,messages!);
  }

  static Future<void> sendAndroidNotification({required List<String> tokenDeviceReceivers,required String senderName,required String message}) async {
    try {
      final response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAAYjK7krc:APA91bHELFknmMBbSSMAAEVbmvalMLFHAi0DiI5BklS0P2F3VUUBYvVH_FCi_iOngGHbpLQ4UZzSk6NoC2-xq6NfLgPJZ7y4ebNhZ8ldsOCMImoG0TMG2i9f1RrXQmAWlIlsLut3v5Tx',
        },
        body: jsonEncode(
          <String, dynamic>{
            "registration_ids": tokenDeviceReceivers,
            'data': <String, dynamic>{  // Thay đổi từ 'notification' thành 'data'
              'body': message,
              'title': senderName,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
  // void configFcm()
  // {
  //   final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  //   firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //
  //     },
  //   );
  // }

  }


