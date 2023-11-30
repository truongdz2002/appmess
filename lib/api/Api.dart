import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  static FirebaseAuth firebaseAuth =FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  static Reference firebaseStorage=FirebaseStorage.instance.ref();
}