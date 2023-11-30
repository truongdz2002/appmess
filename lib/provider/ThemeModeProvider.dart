import 'package:flutter/material.dart';

class ThemeModeProvider with ChangeNotifier {
 late bool _modeDart=true;
 late Color _colorText=Colors.white;
 late Color _colorBackground=Colors.white;
 late Color _colorIcon=Colors.white;
  final Color _colorIconAppBarChatScreen=Colors.purple;
 bool get modeDart=>_modeDart;
 Color get colorText=>_colorText;
 Color get colorBackground=>_colorBackground;
 Color get colorIcon=>_colorIcon;
 Color get colorIconAppBarChatScreen=>_colorIconAppBarChatScreen;
 void toggleChangeModeDart(bool change)
 {
   _modeDart=change;
   notifyListeners();
 }
 void toggleChangeColor()
 {
   if(_modeDart)
     {
       _colorIcon=Colors.white;
       _colorText=Colors.white;
       _colorBackground=Colors.black;
     }
   else
     {
       _colorIcon=Colors.grey;
       _colorText=Colors.black;
       _colorBackground=Colors.white;
     }
   notifyListeners();
 }
}
