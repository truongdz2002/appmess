import 'package:flutter/foundation.dart';

class ClickItemOptionImage with ChangeNotifier {
  late bool _clickItem = true;
  int _count = 0;

  bool get clickItem => _clickItem;
  int get count => _count;

  void toggleOption1() {
    _clickItem = true;
    notifyListeners();
  }
  void toggleOption2() {
    _clickItem = false;
    notifyListeners();
  }

  void incrementCount() {
    _count++;
    notifyListeners();
  }
}
