import 'package:flutter/foundation.dart';

class FakeMessage extends ChangeNotifier{
  bool _isSent =false;
  bool get isSent =>_isSent;
  void toggleChangeStateSent(bool isSentFromApi)
  {
    _isSent=isSentFromApi;
  }
}