import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  DisplaySettingPageState createState() => DisplaySettingPageState();
}

class DisplaySettingPageState extends State<DisplaySettingPage> {
  int themeMode = 0;
  bool showLatency = true;
  bool showExitButton = false;
  double buttonSize = 56.0;
  double imageColumns = 3;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeMode = prefs.getInt("theme_mode") ?? 0;
      showLatency = prefs.getBool("show_latency") ?? true;
      showExitButton = prefs.getBool("show_exit_button") ?? false;
      buttonSize = prefs.getDouble("button_size") ?? 56.0;
      imageColumns = prefs.getDouble("image_columns") ?? 3;
    });

    return true;
  }

  void saveThemeConfig(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme_mode", value);
  }

  void saveLatencyConfig(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_latency", value);
  }

  void saveExitButtonConfig(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_exit_button", value);
  }  

  void saveButtonSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("button_size", value);
  }

  void saveImageColumns(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("image_columns", value);
  }

  String getSelectedTheme() {
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

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder(
      future: loadConfig(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Display Setting")),
            body: ListView(
              padding: EdgeInsets.all(8),
              children: [

                SizedBox(height: 8),
                Column(
                  children: [
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Home",
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

                      SizedBox(height: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case "system":
                              saveThemeConfig(0);
                              break;
                            
                            case "light":
                              saveThemeConfig(1);
                              break;

                            case "dark":
                              saveThemeConfig(2);
                              break;
                            
                            default:
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "system",
                            child: Text("System"),
                          ),
                          const PopupMenuItem(
                            value: "light",
                            child: Text("Light"),
                          ),
                          const PopupMenuItem(
                            value: "dark",
                            child: Text("Dark"),
                          ),
                        ],
                        child: ListTile(
                          leading: isDark ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                          title: const Text("Theme Mode"),
                          subtitle: Text(getSelectedTheme()),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      Divider(),

                      SwitchListTile(
                        title: Text("Show Latency"),
                        secondary: Icon(Icons.network_check),
                        value: showLatency,
                        onChanged: (value) {
                          setState(() {
                            showLatency = value;
                            saveLatencyConfig(value);
                          });
                        },
                      ),
                      Divider(),

                      SwitchListTile(
                        title: Text("Show Exit Button"),
                        secondary: Icon(Icons.power_settings_new),
                        value: showExitButton,
                        onChanged: (value) {
                          setState(() {
                            showExitButton = value;
                            saveExitButtonConfig(value);
                          });
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "History",
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

                      SizedBox(height: 8),
                      ListTile(
                        title: Text("Image Columns"),
                        leading: Icon(Icons.view_column),
                        trailing: Text(
                          imageColumns.toInt().toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Slider(
                        value: imageColumns,
                        min: 1.0,
                        max: 12.0,
                        divisions: 11,
                        label: imageColumns.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            imageColumns = value;
                            saveImageColumns(value);
                          });
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Global",
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

                      SizedBox(height: 8),
                      ListTile(
                        title: Text("Button Size"),
                        leading: Icon(Icons.open_in_full),
                        trailing: Text(
                          buttonSize.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Slider(
                        value: buttonSize,
                        min: 28.0,
                        max: 112.0,
                        divisions: 84,
                        label: buttonSize.toString(),
                        onChanged: (value) {
                          setState(() {
                            buttonSize = value;
                            saveButtonSize(value);
                          });
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                SizedBox(height: 100)
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
            ),
          );
        }
      },
    );
  }
}