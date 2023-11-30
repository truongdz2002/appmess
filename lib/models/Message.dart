import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final List<String> message;
  final Timestamp timestamp;
  final bool seen;
  final bool send;
  final List<String> tokenDeviceSender;
  final List<String> tokenDeviceReceiver;
  final String receiverName;
  final Type typeMessage;
  final String expression;
  const Message ({required this.id,required this.senderId,required this.senderName,required this.receiverId,required this.message,required this.timestamp,required this.seen,required this.send,required this.receiverName,required this.typeMessage,required this.tokenDeviceSender,required this.tokenDeviceReceiver,required this.expression});
  Map<String, dynamic> toMap() {
    return
        {
          'id':id,
          'senderId':senderId,
          'senderEmail':senderName,
          'receiverId':receiverId,
          'message':message,
          'timestamp':timestamp,
          'seen':seen,
          'send':send,
          'tokenDeviceSender':tokenDeviceSender,
          'tokenDeviceReceiver':tokenDeviceReceiver,
          'receiverName':receiverName,
          'typeMessage':typeMessage.name,
          'expression':expression
        };
  }
  String toJson() {
    return jsonEncode({'senderId':senderId,
         'id':id,
        'senderName':senderName,
        'receiverId':receiverId,
        'message':message,
        'seen':seen,
        'send':send,
      'tokenDeviceSender':tokenDeviceSender,
      'tokenDeviceReceiver':tokenDeviceReceiver,
        'receiverName':receiverName,
      'typeMessage':typeMessage.name,
      'expression':expression,
        });
  }
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] as String,
        senderName: json['senderName'] as String,
      receiverId: json['receiverId'] as String,
      message: (json['message'] as List<dynamic>).cast<String>(),
      seen: json['seen'] as bool,
      send: json['send'] as bool,
      tokenDeviceReceiver: (json['tokenDeviceReceiver'] as List<dynamic>).cast<String>(),
      timestamp: Timestamp.now(),
      receiverName: json['receiverName'] as String,
      typeMessage: json['typeMessage'].toString() == Type.image.name ? Type.image : Type.text,
      tokenDeviceSender: (json['tokenDeviceSender'] as List<dynamic>).cast<String>(),
      expression: json['expression'] as String,
      id:json['id'] as String,

    );
  }
  static String generateUniqueId(String messageContent) {
    // Kết hợp thông tin độc nhất, chẳng hạn nội dung tin nhắn và thời gian gửi
    String uniqueInfo = messageContent + DateTime.now().toString();

    // Tạo MD5 hash từ thông tin độc nhất
    var bytes = utf8.encode(uniqueInfo);
    var digest = md5.convert(bytes);

    // Chuyển đổi MD5 hash thành chuỗi ID
    String uniqueId = digest.toString();

    return uniqueId;
  }

}
enum Type {text,image}
