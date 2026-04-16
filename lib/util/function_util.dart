import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FunctionUtil {
  static Storage storage = Storage();
  static Network network = Network();
  static Display display = Display();
  static Item item = Item();
}

class Storage {

  Future<bool> isEnabledCacheAndHistory() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("enabled_cache_and_history") ?? true;
  }

  Future<Directory> getCacheDir() async {
    Directory cacheDir = await getTemporaryDirectory();
    
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      return Directory('$home/.cache/com.kssjw.lucky_artwork/images');
    }

    if (Platform.isAndroid) {
      final imagesDir = Directory("${cacheDir.path}/images");
      return imagesDir;
    }

    return cacheDir;  // Fallback
  }

  Future<Map<Permission, PermissionStatus>> requestImagePermissionsPnAndroid() async {
    return await [
      Permission.storage,
      Permission.photos,
    ].request();
  }

  String getExtensionOfContentType(String? contentType) {
    String extension = "raw";

    // 根据 content-type 决定扩展名
    if (contentType?.contains("png") ?? false) {
      extension = "png";
    } else if (contentType?.contains("jpeg") ?? false) {
      extension = "jpg";
    } else if (contentType?.contains("webp") ?? false) {
      extension = "webp";
    }

    return extension;
  }
}

class Network {

  Future<bool> isAutomaticUpdateCheck() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("automatic_update_check") ?? false;
  }

  Future<String> getAPI() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString("api_url") ?? "https://manyacg.top/sese";  // Fallback
  }
}

class Display {

  Future<Locale> getLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String str = prefs.getString("locale") ?? "en_US";

    final parts = str.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]); // 只有语言
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]); // 语言 + 国家/地区
    } else {
      throw FormatException("Invalid locale format: $str");
    }    
  }

  Future<int> getThemeMode() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getInt("theme_mode") ?? 0;
  }

  Future<int> getNavigationBarStyle() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getInt("navigation_bar_style") ?? 0;
  }

  Future<bool> isEnabledWakeLock() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("wake_lock") ?? false;
  }

  Future<double> getButtonSize() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getDouble("button_size") ?? 56.0;
  }

  Future<bool> isEnabledFadeInAnimationForImage() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("fade_in_animation_for_image") ?? true;
  }

  Future<bool> isEnabledLatency() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_latency") ?? true;
  }

  Future<bool> isEnabledExitButton() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_exit_button") ?? false;
  }

  Future<double> getImageColumns() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getDouble("image_columns") ?? 3.0;
  }

  Future<bool> isEnabledExploreButton() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_explore_button") ?? true;
  }
}

class Item {

  Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  Future<void> showAutoCheckUpdateMessenger(BuildContext context, bool isDark) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    final currentSemVer = Version.parse(currentVersion);

    try {
      final response = await http.get(
        Uri.parse("https://api.github.com/repos/KSSJW/lucky-artwork/releases/latest"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'];
        final latestSemVer = Version.parse(latestVersion);

        if (currentSemVer < latestSemVer && !latestSemVer.isPreRelease) {

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Row(
                children: [
                  Expanded(
                    child: Text(
                      "The new version $latestVersion is available!",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Get"),
                  ),
                ],
              ),
              backgroundColor: Colors.green[50],
            ),
          );
        }
      }
    } catch(e) {
      return;
    }
  }

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
                title: const Text("Get Updates"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update available: $currentVersion -> $latestVersion",
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
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"), mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Get"),
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
                title: const Text("Get Updates"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You are running the latest version."),
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
        }
      } else {
        throw Exception("Requests are too frequent or the version server cannot be connected.");
      }
    } catch(e) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Get Updates"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Failed to get updates.",
                  style: TextStyle(
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
                child: const Text("OK"),
              ),
            ],
          );
        }
      );
    }
  }

  Widget getRestartFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "Restart",
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
      icon: const Icon(Icons.restart_alt),
      label: const Text("Restart"),
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    );
  }
}