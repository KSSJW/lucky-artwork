import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/setting/api/api_setting.dart';
import 'package:lucky_artwork/setting/cache/cache_setting.dart';
import 'package:lucky_artwork/setting/developer_options/developer_options.dart';
import 'package:lucky_artwork/setting/display/display_setting.dart';
import 'package:lucky_artwork/setting/about/about.dart';
import 'package:lucky_artwork/setting/update/update_setting.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  double buttonSize = 56.0;
  late PackageInfo packageInfo;

  Future loadConfig() async {
    final results = await Future.wait([
      FunctionUtil.display.getButtonSize(),
    ]);

    setState(() {
      buttonSize = results[0];
    });
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [

                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(
                    Icons.api,
                    color: Colors.purpleAccent,
                  ),
                  title: const Text("API"),
                  subtitle: const Text("Set the source of the image."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const ApiSetting()),
                    );
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.display_settings,
                    color: Colors.cyan,
                  ),
                  title: const Text("Display"),
                  subtitle: const Text("Control the interface display of the software."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const DisplaySetting()),
                    );
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.storage,
                    color: Colors.orange,
                  ),
                  title: const Text("Cache"),
                  subtitle: const Text("Manage software cache."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const CacheSetting()),
                    );
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.arrow_circle_up,
                    color: Colors.green,
                  ),
                  title: const Text("Update"),
                  subtitle: const Text("Get software updates."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const UpdateSetting()),
                    );
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: Colors.teal,
                  ),
                  title: const Text("Developer Options"),
                  subtitle: const Text("Used for testing or advanced control."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const DeveloperOptions()),
                    );
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  title: const Text("About"),
                  subtitle: const Text("Information about this software."),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const About()),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: FloatingActionButton(
            heroTag: null,
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
                        const Text("Are you ready to restart?"),
                        const SizedBox(height: 8),
                        const Text("Restarting will take effect immediately,"),
                        const SizedBox(height: 8),
                        const Text(
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
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            child: Icon(
              Icons.restart_alt,
              size: buttonSize * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}