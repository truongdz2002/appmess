


import 'package:flutter/material.dart';

ThemeData lightTheme=ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20)
    ),
    colorScheme: ColorScheme.light(
      background: Colors.white,
      primary: Colors.black,
      secondary: Colors.black,
      surface: Colors.grey.withOpacity(0.5)


    )
);