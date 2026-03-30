import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSettingPage extends StatefulWidget {
  const CacheSettingPage({super.key});

  @override
  CacheSettingPageState createState() => CacheSettingPageState();
}

class CacheSettingPageState extends State<CacheSettingPage> {
  bool enabledCacheAndHistory = true;
  int cacheSize = 0;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledCacheAndHistory = prefs.getBool("enabled_cache_and_history") ?? true;
      getCacheSize();
    });

    return true;
  }

  void saveCacheAndHistoryConfig(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("enabled_cache_and_history", value);
  }

  void getCacheSize() async {
    Directory cacheDir = await FunctionUtilOfStorage().getCacheDir();
    int size = 0;

    if (await cacheDir.exists()) {
      await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
        if (entity is File) size += await entity.length();
      }
    }

    cacheSize = size;
  }

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes == 0) return "0 B";
    const k = 1024;
    const sizes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(k)).floor();
    final value = (bytes / pow(k, i)).toStringAsFixed(decimals);
    return "$value ${sizes[i]}";
  }

  void clearCache() async {
    Directory cacheDir = await FunctionUtilOfStorage().getCacheDir();

    if (await cacheDir.exists()) {
      await for (var file in cacheDir.list(recursive: true)) {
        if (file is File) await file.delete();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadConfig(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Cache Setting")),
            body: ListView(
              padding: EdgeInsets.all(8),
              children: [

                SizedBox(height: 8),
                Column(
                  children: [
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      SizedBox(height: 8),
                      SwitchListTile(
                        title: Text("Enable Cache and History"),
                        secondary: Icon(Icons.history),
                        value: enabledCacheAndHistory,
                        onChanged: (value) {
                          setState(() {
                            enabledCacheAndHistory = value;
                            saveCacheAndHistoryConfig(value);
                          });
                        },
                      ),
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.cleaning_services),
                        title: Text("Clear Cache"),
                        trailing: Text(
                          formatBytes(cacheSize),
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Clear Cache"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Are you sure you want to clear the cache?"),
                                    SizedBox(height: 8),
                                    Text(
                                      "You will be deleting the cache and history.",
                                      style: TextStyle(
                                        color: Colors.red
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      clearCache();
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Clear"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),              
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: "Restart",
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
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
            ),
          );
        }
      },
    );
  }
}