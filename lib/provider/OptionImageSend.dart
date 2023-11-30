import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class OptionImageSend extends ChangeNotifier{
   final List<AssetEntity> _indexItemClick = [];

   List<AssetEntity> get clickItem =>_indexItemClick;

  void toggleOption(AssetEntity index) {
    _indexItemClick.add(index);
    notifyListeners();
  }
   void toggleUnSelect(AssetEntity index) {
     _indexItemClick.remove(index);
     notifyListeners();
   }


}