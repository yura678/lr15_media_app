import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted || status.isLimited;
  }

  Future<bool> requestGalleryPermission() async {
    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;
    final storage = await Permission.storage.request();
    return storage.isGranted || storage.isLimited;
  }
}
