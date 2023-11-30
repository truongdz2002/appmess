import 'package:appmess/screen/auth/LoginScreen.dart';
import 'package:appmess/screen/auth/RegisterScreen.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage=true;
  void togglePages()
  {
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginScreen(onTap: togglePages,);
    }
    else
      {
        return RegisterScreen(onTap: togglePages,);
      }
  }
}
