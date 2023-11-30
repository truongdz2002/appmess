import 'dart:async';

import 'package:appmess/provider/ThemeModeProvider.dart';
import 'package:appmess/service/AuthGate.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../extention/SystemUiStyleHelper.dart';
import '../provider/updateCheckConnect.dart';
import '../service/serviceDevice.dart';
import '../utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // for(var color in ColorRoomChat.pastelColors)
    //   {
    //     ChatService.addColorRoomChatToFirestore(color);
    //   }
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      AuthService.updateIsOnline(true);

    } else if (state == AppLifecycleState.paused) {
     AuthService.updateIsOnline(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemUiStyleHelper.setSystemUiOverlayStyle(Theme.of(context).colorScheme.background);
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const AuthGate()));
      });
    });
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background ,
      body: Stack(
        children: [
          Positioned(
            top:Responsive.marginTopElementLogo(context),
            width:Responsive.widthElementLogo(context),
            right: Responsive.marginRightElementLogo(context),
              child: Image.asset('assets/iconappchat.png'),),
          Positioned(
              bottom:Responsive.heightTextIntro(context),
              width: Responsive.getWidth(context),
              child:  Text('MAKE IN INDIA WITH ❤️❤️❤️❤️❤️❤️❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:Theme.of(context).colorScheme.secondary ,
                fontSize: 16,
                letterSpacing: .5
              ),)),
        ],
      ),
    );
  }

}
