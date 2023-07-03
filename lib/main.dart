import 'package:appmess/firebase_options.dart';
import 'package:appmess/service/AuthGate.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
  MultiProvider(providers: [
     ChangeNotifierProvider(create: (_)=>AuthService())
  ],child: MaterialApp(
    home:const AuthGate(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        drawerTheme: const DrawerThemeData(
          scrimColor: Colors.transparent,
        )
    ),
  ))
    ) ;

}

