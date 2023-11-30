import 'dart:io';

import 'package:appmess/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../api/Api.dart';
import '../models/ChatUser.dart';
import '../test_library/NotificationController.dart';
class ChatService extends ChangeNotifier {


  static Future<void> createRoomChat({required String receiverId,required bool statusSender,required bool statusReceiver})
  async{

    List<String> ids=[Apis.firebaseAuth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomId=ids.join("_");
    await Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('member').doc(chatRoomId).set(
        {
          'member': [Apis.firebaseAuth.currentUser!.uid, receiverId]
        }
    );
    await Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('statusUser').doc(chatRoomId).set(
        {
          Apis.firebaseAuth.currentUser!.uid:statusSender,
          receiverId:statusReceiver
        }
    );

  }

  static Future<void> sendMessage({required String receiverId, required List<String> message,required List<String> tokenDeviceReceivers,required String receiverName,required Type type,required List<String> tokenDeviceSender,required String senderName,required String senderId})
   async{
    final Timestamp timestamp=Timestamp.now();
    Message  messages= Message(senderId: senderId, receiverId: receiverId, message: message, timestamp: timestamp,seen:false,send: true, receiverName:receiverName, typeMessage:type, senderName: senderName, tokenDeviceSender: tokenDeviceSender, tokenDeviceReceiver:tokenDeviceReceivers, expression:'', id:Message.generateUniqueId(message[0]));

  List<String> ids=[senderId,receiverId];
  ids.sort();
  String chatRoomId=ids.join("_");
  await Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(messages.toMap()).whenComplete(()
  {
   NotificationController.sendAndroidNotification(tokenDeviceReceivers: tokenDeviceReceivers, senderName: senderName, message: messages.toJson());
  });
  }
  Stream<QuerySnapshot> getMessages(String userId,String otherUserId)
  {
    List<String> ids=[userId,otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");
    return Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp',descending: true).snapshots();
  }

   static void updateUserImage( String newImageUrl) async {
     // Khởi tạo Firestore instance
     FirebaseFirestore firestore = FirebaseFirestore.instance;

     // Tạo một tham chiếu đến tài liệu của người dùng với userId
     DocumentReference userRef = firestore.collection('users').doc(Apis.firebaseAuth.currentUser!.uid);

     // Lấy dữ liệu hiện tại của người dùng
     DocumentSnapshot userSnapshot = await userRef.get();

     if (userSnapshot.exists) {
       // Tạo một đối tượng User từ dữ liệu hiện tại
       ChatUser currentUser = ChatUser.fromJson(
           userSnapshot.data() as Map<String, dynamic>);

       // Cập nhật đường dẫn ảnh mới
       currentUser.image = newImageUrl;

       // Chuyển đổi đối tượng User thành dữ liệu JSON
       Map<String, dynamic> updatedUserData = currentUser.toJson();

       // Cập nhật dữ liệu người dùng trên Firestore
       await userRef.update(updatedUserData);
     }
   }

   static Future<bool> updateAvatar(AssetEntity asset)
   async {
     File? file = await asset.file;
     if (file != null) {
       String imagePath = file.path;
       List<String> pathParts = imagePath.split('/');
       String fileName = pathParts.last;
       Reference storageReference =
       FirebaseStorage.instance.ref().child('images/$fileName');
       try {
         // Tải ảnh lên Firebase Storage.
         UploadTask uploadTask = storageReference.putFile(file);

         // Lắng nghe sự kiện hoàn thành tải lên.
         await uploadTask.whenComplete(() async {
           // Lấy đường dẫn URL của ảnh đã tả
           String imageUrl = await storageReference.getDownloadURL();
           updateUserImage(imageUrl);
         });
         return true;
       } catch (e) {
         return false;
       }
     }
     return false;
   }

  static Future<bool> sendImage({
    required String receiverId,
    required List<String> tokenDeviceReceivers,
    required String receiverName,
    required List<AssetEntity> assets,
    required List<String> tokenDeviceSender,
    required String senderName,
    required senderId
  }) async {
    List<String> listImage = [];

    if (assets.isNotEmpty) {
      for (var asset in assets) {
        File? file = await asset.file;
        if (file != null) {
          String imagePath = file.path;
          List<String> pathParts = imagePath.split('/');
          String fileName = pathParts.last;
          Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

          // Tải ảnh lên Firebase Storage và chờ hoàn thành
          UploadTask uploadTask = storageReference.putFile(file);
          await uploadTask;

          // Lấy URL của ảnh
          String imageUrl = await storageReference.getDownloadURL();
          listImage.add(imageUrl);
        }
      }
      sendMessage(receiverId: receiverId, message: listImage, tokenDeviceReceivers: tokenDeviceReceivers, receiverName: receiverName, type: Type.image, tokenDeviceSender: tokenDeviceSender, senderName: senderName, senderId: senderId);
      return true;
    }

    return false;
  }


  static void updateMessageSeen( {required bool seen,required String userId,required String otherUserId}) async {
    List<String> ids=[userId,otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");
    final messageCollection =Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages');

    final querySnapshot = await messageCollection.get();
    querySnapshot.docs.forEach((document) async {
      final sender = document.data()['senderId'] as String;

      if (sender != userId) {
        await messageCollection.doc(document.id).update({
          'seen': seen,
        });
      }
    });
  }
  static void updateMessageExpression( {required String expression,required String userId,required String otherUserId,required Map<String, dynamic> message}) async {
    List<String> ids=[userId,otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");
    final messageCollection =Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages');

    final querySnapshot = await messageCollection.get();
    querySnapshot.docs.forEach((document) async {
      Map<String, dynamic> messageData = document.data();
      if(message['message'][0]==messageData['message'][0] && message['timestamp']==messageData['timestamp'] )
        {
          await messageCollection.doc(document.id).update({
            'expression': expression,
          });
        }
    });

  }static void removeMessageExpression( {required String expression,required String userId,required String otherUserId,required Map<String, dynamic> message}) async {
    List<String> ids=[userId,otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");
    final messageCollection =Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages');

    final querySnapshot = await messageCollection.get();
    querySnapshot.docs.forEach((document) async {
      Map<String, dynamic> messageData = document.data();
      if(message['message'][0]==messageData['message'][0] && message['timestamp']==messageData['timestamp'] )
        {
          await messageCollection.doc(document.id).update({
            'expression': '',
          });
        }
    });

  }
  static firstMessage({required String receiverId,})
  async {
    List<String> ids=[Apis.firebaseAuth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomId=ids.join("_");
    final Timestamp timestamp=Timestamp.now();
    Message  messages= Message(senderId:Apis.firebaseAuth.currentUser!.uid, receiverId:receiverId, message: ['Hãy cùng nhau trò chuyện'], timestamp:timestamp,seen:false,send: true, receiverName:'', typeMessage:Type.text, senderName: '', tokenDeviceSender: [], tokenDeviceReceiver:[], expression:'', id:Message.generateUniqueId('Hãy cùng nhau trò chuyện'));
    await Apis.firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(messages.toMap());
  }
}