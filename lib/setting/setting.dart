import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/api/api_setting.dart';
import 'package:lucky_artwork/setting/cache/cache_setting.dart';
import 'package:lucky_artwork/setting/display/display_setting.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  
  TextSpan getVersion() {
    return TextSpan(
      text: "1.2.0-alpha.1",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.api),
            title: Text("API"),
            subtitle: Text("API ..."),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApiSettingPage()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.display_settings),
            title: Text("Display"),
            subtitle: Text("Display ..."),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplaySettingPage()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Cache"),
            subtitle: Text("Cache ..."),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CacheSettingPage())
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.update),
            title: Text("Update"),
            subtitle: Text("Update ..."),
            onTap: () => {
              launchUrl(Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"), mode: LaunchMode.externalApplication)
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("Info"),
            subtitle: Text("Info ..."),
            onTap: () => {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog (
                    title: Text("Lucky Artwork"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Version: ",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black
                                ),
                              ),
                              getVersion(),
                              TextSpan(text: "\n\n"),

                              TextSpan(
                                text: "Project: ",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black
                                ),
                              ),
                              TextSpan(
                                text: "lucky-artwork",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://github.com/KSSJW/lucky-artwork"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: "Author: ",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black
                                ),
                              ),
                              TextSpan(
                                text: "KSSJW",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://github.com/KSSJW"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n\n"),

                              TextSpan(
                                text: "Thanks to the API providers, who provided the soul of this software.",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black
                                ),
                              ),
                              TextSpan(text: "\n\n"),

                              TextSpan(
                                text: "ManyACG",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://manyacg.top"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: "ZiChenACG",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse('https://app.zichen.zone/api/acg'),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: "樱花二次元图片",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse('https://www.dmoe.cc'),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: "东方Project随机图片",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse('https://img.paulzzh.com'),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              )
            },
          ),
        ]
      )
    );
  }
}