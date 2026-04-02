import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingFunction {
  static Config config = Config();
  static Item item = Item();
}

class Config {

  void saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme_mode", value);
  }

  void saveLatency(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_latency", value);
  }

  void saveExitButton(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_exit_button", value);
  }  

  void saveButtonSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("button_size", value);
  }

  void saveWakeLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("wake_lock", value);
  }

  void saveImageColumns(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("image_columns", value);
  }

  String getSelectedTheme(int themeMode) {
    switch (themeMode) {
      case 0:
        return "System";
      
      case 1:
        return "Light";

      case 2:
        return "Dark";

      default:
        return "Null";
    }
  }
}

class Item {

  Widget getFloatingActionButton(BuildContext context) {
    return Row(
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
                );
              },
            );
          },
          tooltip: "Restart",
          icon: const Icon(Icons.restart_alt),
          label: const Text("Restart"),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}