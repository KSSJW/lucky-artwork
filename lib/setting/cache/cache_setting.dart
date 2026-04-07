import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/cache/cache_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class CacheSettingPage extends StatefulWidget {
  const CacheSettingPage({super.key});

  @override
  CacheSettingPageState createState() => CacheSettingPageState();
}

class CacheSettingPageState extends State<CacheSettingPage> {
  late Future configLoadFuture;

  bool enabledCacheAndHistory = true;
  int? cacheSize;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      FunctionUtil.storage.isEnabledCacheAndHistory(),
    ]);

    setState(() {
      enabledCacheAndHistory = result[0];
    });

    if (cacheSize == null) loadCacheSize();

    return true;
  }

  void loadCacheSize() async {
    final cacheDir = await FunctionUtil.storage.getCacheDir();
    
    setState(() => cacheSize = null); // 先显示 loading

    final size = await compute(CacheSettingFunction.storage.computeCacheSizeIsolate, cacheDir.path); // 在后台 isolate 计算

    if (!mounted) return;
    
    setState(() {
      cacheSize = size;
    });
  }

  @override
  void initState() {
    super.initState();

    configLoadFuture = loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configLoadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Cache Setting")),
            body: ListView(
              padding: EdgeInsets.all(8),
              children: [

                Icon(
                  Icons.storage,
                  size: 80,
                  color: Colors.orange,
                ),

                SizedBox(height: 16),
                Column(
                  children: [
                    Text("Manage software cache."),
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
                        trailing: cacheSize == null ? Text(
                          "computing ...",
                          style: TextStyle(fontSize: 16.0),
                        ) : Text(
                          CacheSettingFunction.util.formatBytes(cacheSize!),
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
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
                                        onPressed: () async {
                                          NavigatorState navigatorState = Navigator.of(context);
                                          final cacheDir = await FunctionUtil.storage.getCacheDir();

                                          await compute(CacheSettingFunction.storage.clearCacheIsolate, cacheDir.path);
                                          navigatorState.pop();

                                          loadCacheSize();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text("Clear"),
                                      ),
                                    ],
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
              
                SizedBox(height: 100)
              ],
            ),
            floatingActionButton: FunctionUtil.item.getRestartFloatingActionButton(context),
          );
        }
      },
    );
  }
}