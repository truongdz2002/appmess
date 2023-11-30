import 'package:flutter/foundation.dart';

class ProcessingListMessageSeen extends ChangeNotifier{
  List<Map<String, dynamic>> _listMessageSeen=[];
  List<Map<String, dynamic>> get listMessageSeen=>_listMessageSeen;
  void setDataListMessageSeen(List<Map<String, dynamic>> list)
  {

    Future.microtask(() {
      _listMessageSeen=list;
      notifyListeners();
    });
  }
  int indexMax()
  {
    return _listMessageSeen.isNotEmpty ? _listMessageSeen.length-1 : 0;
  }
  String contentMessageSeenIndexMax()
  {
    return indexMax() >0  ?_listMessageSeen[indexMax()]['message'].toString() :'';
  }
}