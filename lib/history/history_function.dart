import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryFunction {
  static Storage storage = Storage();
  static Display display = Display();
  static Util util = Util();
}

class Storage {

  Future<int> saveImage(File file) async {
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) return -1;

      final ext = Util().getExtension(file.path);
      final newPath = "${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}$ext";
      await file.copy(newPath);

      return 1;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await FunctionUtil.storage.requestImagePermissionsPnAndroid();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final bytes = await file.readAsBytes();
        final ext = Util().getExtension(file.path);

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

  Future<void> saveImageAndShowPath(File file, ScaffoldMessengerState messenger, AppLocalizations? locale) async {
    
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(locale!.history_snackbar_saveFailed)),
        );

        return;
      }

      final ext = Util().getExtension(file.path);
      final newPath = "${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}$ext";
      await file.copy(newPath);
      messenger.showSnackBar(
        SnackBar(content: Text("${locale!.history_snackbar_saved}: $newPath")),
      );

      return;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await FunctionUtil.storage.requestImagePermissionsPnAndroid();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final bytes = await file.readAsBytes();
        final ext = Util().getExtension(file.path);

        final result = await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}$ext"
        );

        if (result['isSuccess']) {
          messenger.showSnackBar(
            SnackBar(content: Text("${locale!.history_snackbar_saved}: /Pictures")),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text(locale!.history_snackbar_saveFailed)),
          );
        }

        return;
      }

      return;
    }
  }
}

class Display {

  void showSnackBar(ScaffoldMessengerState message, int status, AppLocalizations? locale) {
    switch (status) {
      case 1:
        if (Platform.isLinux) {
          message.showSnackBar(
            SnackBar(content: Text("${locale!.history_snackbar_saved}: /Downloads")),
          );
        }
        if (Platform.isAndroid) {
          message.showSnackBar(
            SnackBar(content: Text("${locale!.history_snackbar_saved}: /Pictures")),
          );
        }
        break;

      case -1:
        message.showSnackBar(
          SnackBar(content: Text(locale!.history_snackbar_saveFailed)),
        );
        break;

      default:
        break;
    }
  }
}

class Util {

  String getExtension(String path) {
    return path.substring(path.lastIndexOf('.'));
  }
}