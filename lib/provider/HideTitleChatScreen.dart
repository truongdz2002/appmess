import 'package:flutter/foundation.dart';

class HideTitleChatScreen extends ChangeNotifier{
   bool  _hide=false;
   bool get hide =>_hide;

  void toggleHide()
  {
    _hide=true;
    notifyListeners();
  }
  void toggleShow()
  {
    _hide=false;
    notifyListeners();
  }
}