import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/cache/cache_setting_function.dart';
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
                            CacheSettingFunction.config.saveCacheAndHistory(value);
                          });
                        },
                      ),
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.cleaning_services),
                        title: Text("Clear Cache"),
                        trailing: Text(
                          CacheSettingFunction.util.formatBytes(cacheSize),
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
                                      CacheSettingFunction.util.clearCache();
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
            floatingActionButton: CacheSettingFunction.item.getFloatingActionButton(context),
          );
        }
      },
    );
  }
}