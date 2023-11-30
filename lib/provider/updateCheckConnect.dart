import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../service/serviceDevice.dart';

class  UpdateCheckConnect extends ChangeNotifier{
  bool _connection=true;
  bool get connection =>_connection;

  void toggleChangeLostConnection()
  {
    _connection=false;
    notifyListeners();
  }
  void toggleChangeConnection()
  {
    _connection=true;
    notifyListeners();
  }
  checkInternet()
  {
    ServiceDevice.checkConnectivity().listen((ConnectivityResult connectivityResult) {
      // Thực hiện các hành động dựa trên giá trị từ Stream ở đây
      if (connectivityResult == ConnectivityResult.mobile) {
        toggleChangeConnection();
      } else if (connectivityResult == ConnectivityResult.wifi) {
       toggleChangeConnection();
      } else {
        toggleChangeLostConnection();
      }
    });
  }
}