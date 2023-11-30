import 'package:flutter/foundation.dart';

class ShowImageGallery extends ChangeNotifier{
  late  bool _isShowImageGallery=false;
  bool get isShowImageGallery=>_isShowImageGallery;
  void toggleChangeState1()
  {
    _isShowImageGallery=true;
    notifyListeners();
  }
  void toggleChangeState2()
  {
    _isShowImageGallery=false;
    notifyListeners();
  }
}