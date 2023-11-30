
import 'dart:developer';

import 'package:appmess/api/Api.dart';
import 'package:appmess/models/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {

  Future<UserCredential> sigInWithEmailPassWord(String email,
      String passWord) async {
    try {
      UserCredential userCredential = await Apis.firebaseAuth.signInWithEmailAndPassword(email: email, password: passWord).whenComplete(() async {
        String? token = await Apis.firebaseMessaging.getToken();
        updateUserTokenDevice(token!);
        updateIsOnline(true);
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> sigUpWithEmailPassWord(String email, String passWord,
      String nameUser) async {
    List<String> listTokens=[];
    String? token = await Apis.firebaseMessaging.getToken();
    listTokens.add(token!);
    try {
      UserCredential userCredential = await Apis.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: passWord);
      ChatUser chatUser=ChatUser(about: '', createdAt: '', uid:Apis.firebaseAuth.currentUser!.uid, email: email, image: '', isOnline: true, lastActive:false, name: nameUser, deviceTokens: listTokens);
      Apis.firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(chatUser.toJson());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  Future<void> singOut() async {
    updateIsOnline(false);
    return await Apis.firebaseAuth.signOut();
  }
  static void updateUserTokenDevice( String newTokenDevice) async {
    // Khởi tạo Firestore instance
    List<String>? listNewTokenDevice=[];
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
      listNewTokenDevice.add(newTokenDevice);
      currentUser.deviceTokens = listNewTokenDevice;

      // Chuyển đổi đối tượng User thành dữ liệu JSON
      Map<String, dynamic> updatedUserData = currentUser.toJson();

      // Cập nhật dữ liệu người dùng trên Firestore
      await userRef.update(updatedUserData);
    }
  }
  static void updateIsOnline( bool isOnline) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Tạo một tham chiếu đến tài liệu của người dùng với userId
    DocumentReference userRef = firestore.collection('users').doc(Apis.firebaseAuth.currentUser!.uid);

    // Lấy dữ liệu hiện tại của người dùng
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Tạo một đối tượng User từ dữ liệu hiện tại
      ChatUser currentUser = ChatUser.fromJson(
          userSnapshot.data() as Map<String, dynamic>);

      currentUser.isOnline = isOnline;

      // Chuyển đổi đối tượng User thành dữ liệu JSON
      Map<String, dynamic> updatedUserData = currentUser.toJson();

      // Cập nhật dữ liệu người dùng trên Firestore
      await userRef.update(updatedUserData);
    }
  }
}