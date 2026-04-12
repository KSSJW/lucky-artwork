import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget{
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  late Future configLoadFuture;

  late PackageInfo packageInfo;

  Future loadConfig() async {
    final results = await Future.wait([
      FunctionUtil.item.getPackageInfo()
    ]);

    setState(() {
      packageInfo = results[0];
    });

    return true;
  }

  Text getVersion() {
    Version ver = Version.parse(packageInfo.version);
    return Text(
      packageInfo.version,
      style: TextStyle(
        color: ver.isPreRelease ? (ver.preRelease.first == "alpha" ? Colors.red : Colors.orange) : Colors.green
      ),
    );
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
            appBar: AppBar(title: const Text("About")),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.info_outline,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 16),
                const Column(
                  children: [
                    Text("Information about this software."),
                  ],
                ),
                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Version",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.tag),
                        title: getVersion(),
                        subtitle: Text(Version.parse(packageInfo.version).isPreRelease ? Version.parse(packageInfo.version).preRelease.first.toString() : "stable"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Version"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(packageInfo.toString())
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
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

                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Environment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.developer_board),
                        title: Text(Platform.operatingSystem),
                        subtitle: Text(Platform.operatingSystemVersion),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Environment"),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(Platform.operatingSystemVersion),
                                      SizedBox(height: 8.0),
                                      Text(Platform.environment.toString())
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
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

                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Project",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: const Text("Project Page"),
                        subtitle: Text("GitHub"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://github.com/KSSJW/lucky-artwork"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: const Icon(Icons.bug_report),
                        title: const Text("Report Bugs"),
                        subtitle: Text("GitHub"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://github.com/KSSJW/lucky-artwork/issues"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Developer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: const Text("KSSJW"),
                        subtitle: Text("GitHub"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://github.com/KSSJW"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "API Providers",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: Text("Thanks to the API providers, who provided the soul of this software."),
                    ),
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.api),
                        title: const Text("ManyACG"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://manyacg.top"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: const Icon(Icons.api),
                        title: const Text("Yuki"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://blog.yuki.sh"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: const Icon(Icons.api),
                        title: const Text("ZiChenACG"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://app.zichen.zone/api/acg"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: const Icon(Icons.api),
                        title: const Text("樱花二次元图片"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://www.dmoe.cc"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: const Icon(Icons.api),
                        title: const Text("东方Project随机图片"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://img.paulzzh.com"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          );
        }
      }
    );
  }
}