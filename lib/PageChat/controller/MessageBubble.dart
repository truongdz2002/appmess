import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'BubbleBackground.dart';

@immutable
class MessageBubble extends StatelessWidget {
  final DocumentSnapshot document;
  final List<Color> colorLeft;
  final List<Color> colorRight;
  const MessageBubble({
    super.key, required this.document, required this.colorLeft, required this.colorRight});


  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> data=document.data() as Map<String,dynamic>;
    final messageAlignment =
    (data['senderId']!=FirebaseAuth.instance.currentUser!.uid) ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors:
              (data['senderId']!=FirebaseAuth.instance.currentUser!.uid)
                  ?colorLeft
                  :colorRight ,
              context: context,
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:Text(data['message']),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}