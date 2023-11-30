import 'dart:developer';

import 'package:appmess/requestPermission/RequestPermisstion.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageGalleryProvider extends ChangeNotifier {
  List<AssetEntity>? _assets;
  AssetEntity? _asset;
  List<AssetEntity>? get assets => _assets;

  Future<void> loadImages() async {
    final status = await RequestPermission.request();
    if (status.isGranted) {
      final assets = await PhotoManager.getAssetPathList(
        onlyAll: true,
      );
      if (assets.isNotEmpty) {
        final recentAssetPath = assets[0];
        final recentAssets = await recentAssetPath.getAssetListRange(
          start: 0,
          end: recentAssetPath.assetCount,
        );
        _assets = recentAssets;
        notifyListeners();
      }
    }
  }
}
