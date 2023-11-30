import 'package:flutter/foundation.dart';

class ProcessGroupOption extends ChangeNotifier{
  final List<String> _listNameOption=['Tin nhắn','Hoạt động','Nhóm','Khác','Gần đây'];
  late   int _indexSelect=0;
  List<String> get listNameOption=>_listNameOption;
int get indexSelect=>_indexSelect;

  void toggleChangeOption(int index)
  {
    _indexSelect=index;
    notifyListeners();
  }
}