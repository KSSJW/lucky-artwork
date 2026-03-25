import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSettingPage extends StatefulWidget {
  const CacheSettingPage({super.key});

  @override
  CacheSettingPageState createState() => CacheSettingPageState();
}

class CacheSettingPageState extends State<CacheSettingPage> {
  bool enabledCacheAndHistory = true;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledCacheAndHistory = prefs.getBool("enabled_cache_and_history") ?? true;
    });

    return true;
  }

  void saveCacheAndHistoryConfig(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("enabled_cache_and_history", value);
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
              children: [
                Column(
                  children: [
                    Text("Some features require a restart to take effect.")
                  ],
                ),
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
                              Text(
                                "but will clear the page cache.",
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
                                Phoenix.rebirth(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}