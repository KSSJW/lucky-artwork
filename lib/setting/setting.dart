import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/setting/api/api_setting.dart';
import 'package:lucky_artwork/setting/cache/cache_setting.dart';
import 'package:lucky_artwork/setting/display/display_setting.dart';
import 'package:lucky_artwork/setting/update/update_setting.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

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
      FunctionUtil.item.getPackageInfo()
    ]);

    setState(() {
      buttonSize = results[0] as double;
      packageInfo = results[1] as PackageInfo;
    });
  }

  TextSpan getVersion() {
    Version ver = Version.parse(packageInfo.version);
    return TextSpan(
      text: packageInfo.version,
      style: TextStyle(
        color: ver.isPreRelease ? (ver.preRelease.first == "alpha" ? Colors.red : Colors.orange) : Colors.green
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [

                SizedBox(height: 8),
                ListTile(
                  leading: Icon(
                    Icons.api,
                    color: Colors.purpleAccent,
                  ),
                  title: Text("API"),
                  subtitle: Text("Set the source of the image."),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApiSettingPage()),
                    );
                  },
                ),
                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.display_settings,
                    color: Colors.cyan,
                  ),
                  title: Text("Display"),
                  subtitle: Text("Control the interface display of the software."),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisplaySettingPage()),
                    );
                  },
                ),
                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.storage,
                    color: Colors.orange,
                  ),
                  title: Text("Cache"),
                  subtitle: Text("Manage software cache."),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CacheSettingPage()),
                    );
                  },
                ),
                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.arrow_circle_up,
                    color: Colors.green,
                  ),
                  title: Text("Update"),
                  subtitle: Text("Get software updates."),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateSettingPage()),
                    );
                  },
                ),
                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  title: Text("Info"),
                  subtitle: Text("Information about this software."),
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FunctionUtil.item.getInfoAlertDialog(isDark, getVersion(), Navigator.of(context));
                      },
                    )
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
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
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.restart_alt,
            size: buttonSize * 0.5,
          ),
        ),
      ),
    );
  }
}