import 'package:permission_handler/permission_handler.dart';

class RequestPermission{
  static Future<PermissionStatus> request() async {
    PermissionStatus status = await Permission.storage.request();
    return status;
  }
}