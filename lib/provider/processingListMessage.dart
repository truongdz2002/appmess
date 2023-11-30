import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/Message.dart';

class ProcessingListMessage extends ChangeNotifier{
  List<Map<String,dynamic>> _messages=[];
  List<Map<String,dynamic>> get messages => _messages;

  void toggleAddData(List<Map<String,dynamic>> list)
  {
    Future.microtask(() {
      _messages = list;
      notifyListeners();
    });
  }
  void addFakeMessage({required String receiverId, required List<String> message,required List<String> tokenDeviceReceivers,required String receiverName,required Type type,required List<String> tokenDeviceSender,required String senderName,required String senderId,required String expression})
  {
    final Timestamp timestamp=Timestamp.now();
    Message  messages= Message(senderId: senderId, receiverId: receiverId, message: message, timestamp: timestamp,seen:false,send:false, receiverName:receiverName, typeMessage:type, senderName: senderName, tokenDeviceSender: tokenDeviceSender, tokenDeviceReceiver:tokenDeviceReceivers, expression:expression, id:Message.generateUniqueId(message[0]));
    _messages.insert(0,messages.toMap());
    notifyListeners();
  }

}