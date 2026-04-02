import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSettingFunction {
  static Config config = Config();
  static Storage storage = Storage();
  static Item item = Item();
  static Util util = Util();
}

class Config {

  void saveCacheAndHistory(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("enabled_cache_and_history", value);
  }
}

class Storage {

  Future<int> getCacheSize() async {
    Directory cacheDir = await FunctionUtil.storage.getCacheDir();
    int size = 0;

    if (await cacheDir.exists()) {
      await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
        if (entity is File) size += await entity.length();
      }
    }

    return size;
  }

  void clearCache() async {
    Directory cacheDir = await FunctionUtil.storage.getCacheDir();

    if (await cacheDir.exists()) {
      await for (var file in cacheDir.list(recursive: true)) {
        if (file is File) await file.delete();
      }
    }
  }
}

class Item {

  Widget getFloatingActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "Restart",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Restart"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Are you ready to restart?"),
                      SizedBox(height: 8),
                      Text("Restarting will take effect immediately,"),
                      SizedBox(height: 8),
                      Text(
                        "If you have disabled caching, it is recommended that you save the necessary data before restarting.",
                        style: TextStyle(
                          color: Colors.orange
                        ),
                      )
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Phoenix.rebirth(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Restart"),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          tooltip: "Restart",
          icon: const Icon(Icons.restart_alt),
          label: const Text("Restart"),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ],
    );
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