


import 'package:flutter/material.dart';

        ThemeData dartTheme=ThemeData(
         brightness: Brightness.dark,

         appBarTheme: const AppBarTheme(
           color: Colors.transparent,
           iconTheme: IconThemeData(
             color:Colors.grey
           ),
           titleTextStyle: TextStyle(color: Colors.white,fontSize: 20)
         ),
         colorScheme:  ColorScheme.dark(
           background: Colors.black,
           primary: Colors.white,
           secondary: Colors.white,
             surface: Colors.grey.withOpacity(0.3)


         )
        );