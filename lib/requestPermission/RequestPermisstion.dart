import 'package:permission_handler/permission_handler.dart';

class RequestPermission{
  Future<PermissionStatus> request() async {
    PermissionStatus status = await Permission.storage.request();
    return status;
  }
}