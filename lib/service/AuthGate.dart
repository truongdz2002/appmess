import 'package:appmess/api/Api.dart';
import 'package:appmess/screen/HomeScreen.dart';
import 'package:appmess/service/LoginOrRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
          stream: Apis.firebaseAuth.authStateChanges(),
          builder: (context,snapshot){
        if(snapshot.hasData)
          {
            return const HomeScreen();
          }
        else
          {
            return const LoginOrRegister();
          }
      }),
    );
  }
}

