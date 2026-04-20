import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/cache/cache_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class CacheSetting extends StatefulWidget {
  const CacheSetting({super.key});

  @override
  CacheSettingState createState() => CacheSettingState();
}

class CacheSettingState extends State<CacheSetting> {
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
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.cacheSetting_appbar_title)),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.storage,
                  size: 80,
                  color: Colors.orange,
                ),

                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.cacheSetting_desc_content1),
                    Text(AppLocalizations.of(context)!.cacheSetting_desc_content2)
                  ],
                ),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.cacheSetting_enableCacheAndHistory),
                        secondary: const Icon(Icons.history),
                        value: enabledCacheAndHistory,
                        onChanged: (value) {
                          setState(() {
                            enabledCacheAndHistory = value;
                            CacheSettingFunction.config.saveCacheAndHistory(value);
                          });
                        },
                      ),
                      const Divider(),

                      ListTile(
                        leading: const Icon(Icons.cleaning_services),
                        title: Text(AppLocalizations.of(context)!.cacheSetting_clearCache),
                        trailing: cacheSize == null ? const Text(
                          "...",
                          style: TextStyle(fontSize: 16.0),
                        ) : Text(
                          CacheSettingFunction.util.formatBytes(cacheSize!),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.cacheSetting_dialog_clearCache_title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations.of(context)!.cacheSetting_dialog_clearCache_content1),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalizations.of(context)!.cacheSetting_dialog_clearCache_content2,
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
                                        child: Text(AppLocalizations.of(context)!.cacheSetting_dialog_clearCache_cacnel),
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
                                        child: Text(AppLocalizations.of(context)!.cacheSetting_dialog_clearCache_clear),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),                      
                    ],
                  ),
                ),
              
                const SizedBox(height: 100)
              ],
            ),
            floatingActionButton: FunctionUtil.item.getRestartFloatingActionButton(context),
          );
        }
      },
    );
  }
}