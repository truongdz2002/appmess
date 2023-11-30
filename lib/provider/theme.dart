
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ColorTheme extends ChangeNotifier{
  late String _colorTheme;
  final Color _colorIconAppBarChatScreen=Colors.purple;
  Color get colorIconAppBarChatScreen=>_colorIconAppBarChatScreen;
  String  get colorTheme=>_colorTheme;
  void toggleChangeColorTheme(String colorChange)
  {
    _colorTheme=colorChange;
    notifyListeners();
  }

}