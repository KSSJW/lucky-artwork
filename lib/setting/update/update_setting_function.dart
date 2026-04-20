import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateSettingFunction {
  static Config config = Config();
  static Item item = Item();
}

class Config {

  void saveAutomaticUpdateCheck(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("automatic_update_check", value);
  }
}

class Item {

  Future<void> showUpdateAlertDialog(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    final currentSemVer = Version.parse(currentVersion);

    try {
      final response = await http.get(
        Uri.parse("https://api.github.com/repos/KSSJW/lucky-artwork/releases/latest"),
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'];
        final changelog = data['body'];
        final latestSemVer = Version.parse(latestVersion);

        if (currentSemVer < latestSemVer && !latestSemVer.isPreRelease) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_title),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_available}: $currentVersion -> $latestVersion",
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("$changelog")
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"), mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_get),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_runningTheLatest),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_ok),
                  ),
                ],
              );  
            },
          );
        }
      } else {
        throw Exception(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_tooFrequent);
      }
    } catch(e) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_failed,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text("$e")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.updateSetting_dialog_getUpdate_ok),
              ),
            ],
          );
        }
      );
    }
  }
}