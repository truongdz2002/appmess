import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool seen;
  final bool send;
  final List<String> tokenDevice;
  const Message( {required this.tokenDevice,required this.senderId,required this.senderEmail,required this.receiverId,required this.message,required this.timestamp,required this.seen,required this.send});

  Map<String, dynamic> toMap() {
    return
        {
          'senderId':senderId,
          'senderEmail':senderEmail,
          'receiverId':receiverId,
          'message':message,
          'timestamp':timestamp,
          'seen':seen,
          'send':send,
          'tokenDevice':tokenDevice
        };
  }


}
