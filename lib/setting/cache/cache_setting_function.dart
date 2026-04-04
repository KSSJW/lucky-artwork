import 'dart:io';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class CacheSettingFunction {
  static Config config = Config();
  static Storage storage = Storage();
  static Util util = Util();
}

class Config {

  void saveCacheAndHistory(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("enabled_cache_and_history", value);
  }
}

class Storage {

  Future<int> computeCacheSizeIsolate(String path) async {
    int size = 0;
    final dir = Directory(path);

    if (await dir.exists()) {
      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    }

    return size;
  }

  void clearCacheIsolate(String path) {
    final dir = Directory(path);

    if (dir.existsSync()) {
      for (var entity in dir.listSync(recursive: true, followLinks: false)) {
        try {
          entity.deleteSync();
        } catch (_) {}
      }
    }
  }
}

class Util {

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes == 0) return "0 B";
    const k = 1024;
    const sizes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(k)).floor();
    final value = (bytes / pow(k, i)).toStringAsFixed(decimals);
    return "$value ${sizes[i]}";
  }
}