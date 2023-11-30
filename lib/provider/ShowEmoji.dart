import 'package:flutter/foundation.dart';

class ShowEmoji extends ChangeNotifier{
  late  bool _isShowEmoji=false;
  bool get isShowEmoji=>_isShowEmoji;
  void toggleChangeState1()
  {
    _isShowEmoji=true;
    notifyListeners();
  }
  void toggleChangeState2()
  {
    _isShowEmoji=false;
    notifyListeners();
  }
}