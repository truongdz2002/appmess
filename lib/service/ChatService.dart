
import 'package:appmess/PageChat/Entity/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<void> sendMessage(String receiverId,String message)
  async{
    final currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email.toString();
    final Timestamp timestamp=Timestamp.now();
   Message  messages= Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiverId, message: message, timestamp: timestamp,seen:false,send: false, tokenDevice: []);

  List<String> ids=[currentUserId,receiverId];
  ids.sort();
  String chatRoomId=ids.join("_");
  await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(messages.toMap());
  }
  Stream<QuerySnapshot> getMessages(String userId,String otherUserId)
  {
    List<String> ids=[userId,otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");
    return _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp',descending: false).snapshots();
  }



}