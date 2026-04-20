import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget{
  const About({super.key});

  @override
  State<StatefulWidget> createState() => AboutState();
}

class AboutState extends State<About> {
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
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.about_appbar_title)),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.info_outline,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.about_desc),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.about_list_version,
                      style: const TextStyle(
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
                                title: Text(AppLocalizations.of(context)!.about_dialog_version_title),
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
                                    child: Text(AppLocalizations.of(context)!.about_dialog_version_ok),
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

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.about_list_environment,
                      style: const TextStyle(
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
                                title: Text(AppLocalizations.of(context)!.about_dialog_environment_title),
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
                                    child: Text(AppLocalizations.of(context)!.about_dialog_environment_ok),
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

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.about_list_project,
                      style: const TextStyle(
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
                        title: Text(AppLocalizations.of(context)!.about_project_page),
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
                        title: Text(AppLocalizations.of(context)!.about_project_bugs),
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

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.about_list_developer,
                      style: const TextStyle(
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

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.about_list_apiProviders,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(AppLocalizations.of(context)!.about_apiProviders_thanks),
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