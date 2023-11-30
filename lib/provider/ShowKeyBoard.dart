import 'package:flutter/foundation.dart';

class ShowKeyBoard extends ChangeNotifier{
  late  bool _isShowKeyBoard=false;
  bool get isShowKeyBoard=>_isShowKeyBoard;
  void toggleChangeState1()
  {
    _isShowKeyBoard=true;
    notifyListeners();
  }
  void toggleChangeState2()
  {
    _isShowKeyBoard=false;
    notifyListeners();
  }
}