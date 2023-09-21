import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> sigInWithEmailPassWord(String email,
      String passWord) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: passWord);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> sigUpWithEmailPassWord(String email, String passWord,
      String nameUser) async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: passWord);

      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'name': nameUser,
            'token device':[token]
          }
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  Future<void> singOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}