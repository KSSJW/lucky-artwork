import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionUtilOfStorage {

  Future<bool> isEnabledCacheAndHistory() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("enabled_cache_and_history") ?? true;
  }

  Future<Directory> getCacheDir() async {
    Directory cacheDir = await getTemporaryDirectory();
    
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      return Directory('$home/.cache/com.kssjw.lucky_artwork/images');
    }

    if (Platform.isAndroid) {
      final imagesDir = Directory("${cacheDir.path}/images");
      return imagesDir;
    }

    return cacheDir;  // Fallback
  }

  Future<Map<Permission, PermissionStatus>> requestImagePermissionsPnAndroid() async {
    return await [
      Permission.storage,
      Permission.photos,
    ].request();
  }

  String getExtensionOfContentType(String? contentType) {
    String extension = "raw";

    // 根据 content-type 决定扩展名
    if (contentType?.contains("png") ?? false) {
      extension = "png";
    } else if (contentType?.contains("jpeg") ?? false) {
      extension = "jpg";
    } else if (contentType?.contains("webp") ?? false) {
      extension = "webp";
    }

    return extension;
  }
}

class FunctionUtilOfDisplay {

  Future<double> getButtonSize() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getDouble("button_size") ?? 56.0;
  }

  Future<bool> isEnabledLatency() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_latency") ?? true;
  }

  Future<bool> isEnabledExitButton() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_exit_button") ?? false;
  }
}

class FunctionUtilOfNetwork {

  Future<String> getAPI() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString("api_url") ?? "https://manyacg.top/sese";  // Fallback
  }
}