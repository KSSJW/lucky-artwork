import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/display/display_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  DisplaySettingPageState createState() => DisplaySettingPageState();
}

class DisplaySettingPageState extends State<DisplaySettingPage> {
  late Future configLoadFuture;

  int themeMode = 0;
  int navigationBarStyle = 0;
  bool wakeLock = false;
  double buttonSize = 56.0;
  bool showLatency = true;
  bool showExitButton = false;
  double imageColumns = 3;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    double rawImageColumns = prefs.getDouble("image_columns") ?? 3;

    if (rawImageColumns > 6) {
      DisplaySettingFunction.config.saveImageColumns(3);
      rawImageColumns = 3;
    }
    
    setState(() {
      themeMode = prefs.getInt("theme_mode") ?? 0;
      navigationBarStyle = prefs.getInt("navigation_bar_style") ?? 0;
      wakeLock = prefs.getBool("wake_lock") ?? false;
      buttonSize = prefs.getDouble("button_size") ?? 56.0;
      showLatency = prefs.getBool("show_latency") ?? true;
      showExitButton = prefs.getBool("show_exit_button") ?? false;
      imageColumns = rawImageColumns;
    });

    return true;
  }

  @override
  void initState() {
    super.initState();

    configLoadFuture = loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder(
      future: configLoadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Display Setting")),
            body: ListView(
              padding: EdgeInsets.all(8),
              children: [

                Icon(
                  Icons.display_settings,
                  size: 80,
                  color: Colors.cyan,
                ),

                SizedBox(height: 16),
                Column(
                  children: [
                    Text("Control the interface display of the software."),
                    Text("Some features require a restart to take effect.")
                  ],
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
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case "system":
                              DisplaySettingFunction.config.saveTheme(0);
                              break;
                            
                            case "light":
                              DisplaySettingFunction.config.saveTheme(1);
                              break;

                            case "dark":
                              DisplaySettingFunction.config.saveTheme(2);
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
                          subtitle: Text(DisplaySettingFunction.config.getSelectedTheme(themeMode)),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Navigation Bar Style"),
                        leading: Icon(Icons.view_sidebar_rounded),
                      ),
                      SizedBox(height: 8),
                      SegmentedButton(
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: Text("Bottom"),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: Text("Left"),
                          ),
                        ],
                        selected: {
                          navigationBarStyle,
                        },
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            navigationBarStyle = newSelection.first;
                          });
                          
                          DisplaySettingFunction.config.saveNavigationBarStyle(newSelection.first);
                        },
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SwitchListTile(
                        title: Text("Wake Lock"),
                        secondary: Icon(Icons.lightbulb),
                        value: wakeLock,
                        onChanged: (value) {
                          setState(() {
                            wakeLock = value;
                          });

                          DisplaySettingFunction.config.saveWakeLock(value);
                        },
                      ),
                      Divider(),
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
                          });

                          DisplaySettingFunction.config.saveButtonSize(value);
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
                      SwitchListTile(
                        title: Text("Show Latency"),
                        secondary: Icon(Icons.speed),
                        value: showLatency,
                        onChanged: (value) {
                          setState(() {
                            showLatency = value;
                          });

                          DisplaySettingFunction.config.saveLatency(value);
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
                          });

                          DisplaySettingFunction.config.saveExitButton(value);
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
                        max: 6.0,
                        divisions: 5,
                        label: imageColumns.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            imageColumns = value;
                          });

                          DisplaySettingFunction.config.saveImageColumns(value);
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                SizedBox(height: 100)
              ],
            ),
            floatingActionButton: FunctionUtil.item.getRestartFloatingActionButton(context),
          );
        }
      },
    );
  }
}