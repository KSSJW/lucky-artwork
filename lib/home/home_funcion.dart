import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeFuncion {
  static Storage storage = Storage();
}

class Storage {

  Future<void> cacheImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    String extension = FunctionUtil.storage.getExtensionOfContentType(contentType);
    Directory cacheDir = await FunctionUtil.storage.getCacheDir();

    if (!cacheDir.existsSync()) cacheDir.createSync(recursive: true);

    final file = File("${cacheDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.$extension");
    await file.writeAsBytes(response.bodyBytes);
  }

  Future<void> saveImageAndShowPath(http.Response response, ScaffoldMessengerState messenger) async {
    final contentType = response.headers['content-type'];
    String extension = FunctionUtil.storage.getExtensionOfContentType(contentType);
    
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) {
        messenger.showSnackBar(
          SnackBar(content: Text("Failed to save image")),
        );

        return;
      }

      final file = File("${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}.$extension");
      await file.writeAsBytes(response.bodyBytes);
      messenger.showSnackBar(
        SnackBar(content: Text("Image saved to: ${file.path}")),
      );

      return;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await FunctionUtil.storage.requestImagePermissionsPnAndroid();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final result = await ImageGallerySaverPlus.saveImage(
          response.bodyBytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}.$extension"
        );

        if (result['isSuccess']) {
          messenger.showSnackBar(
            SnackBar(content: Text("Image saved to: /Pictures")),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("Failed to save image")),
          );
        }

        return;
      }
    }
  }
}