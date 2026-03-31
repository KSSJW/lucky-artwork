import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryFunction {

  String getExtension(String path) {
    return path.substring(path.lastIndexOf('.'));
  }

  Future<int> saveImage(File file) async {
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) return -1;

      final ext = getExtension(file.path);
      final newPath = "${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}$ext";
      await file.copy(newPath);

      return 1;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await FunctionUtilOfStorage().requestImagePermissionsPnAndroid();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final bytes = await file.readAsBytes();
        final ext = getExtension(file.path);

        final result = await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}$ext"
        );

        if (result['isSuccess']) {
          return 1;
        } else {
          return -1;
        }
      }
    }

    return -1; // Fallback
  }

  void showSnackBar(ScaffoldMessengerState message, int status) {
    switch (status) {
      case 1:
        if (Platform.isLinux) {
          message.showSnackBar(
            SnackBar(content: Text("Images saved to: /Downloads")),
          );
        }
        if (Platform.isAndroid) {
          message.showSnackBar(
            SnackBar(content: Text("Images saved to: /Pictures")),
          );
        }
        break;

      case -1:
        message.showSnackBar(
          SnackBar(content: Text("Failed to save images")),
        );
        break;

      default:
        break;
    }
  }

  Future<void> saveImageAndShowPath(BuildContext context, File file) async {
    final messenger = ScaffoldMessenger.of(context);
    
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) {
        messenger.showSnackBar(
          SnackBar(content: Text("Failed to save image")),
        );

        return;
      }

      final ext = getExtension(file.path);
      final newPath = "${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}$ext";
      await file.copy(newPath);
      messenger.showSnackBar(
        SnackBar(content: Text("Image saved to: $newPath")),
      );

      return;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await FunctionUtilOfStorage().requestImagePermissionsPnAndroid();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final bytes = await file.readAsBytes();
        final ext = getExtension(file.path);

        final result = await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}$ext"
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

      return;
    }
  }
}