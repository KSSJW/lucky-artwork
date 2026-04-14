import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/display/display_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class DisplaySetting extends StatefulWidget {
  const DisplaySetting({super.key});

  @override
  DisplaySettingState createState() => DisplaySettingState();
}

class DisplaySettingState extends State<DisplaySetting> {
  late Future configLoadFuture;

  int themeMode = 0;
  int navigationBarStyle = 0;
  bool wakeLock = false;
  double buttonSize = 56.0;
  bool enabledFadeInAnimationForImage = true;
  bool showLatency = true;
  bool showExitButton = false;
  double imageColumns = 3;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      /* 0 */ FunctionUtil.display.getThemeMode(),
      /* 1 */ FunctionUtil.display.getNavigationBarStyle(),
      /* 2 */ FunctionUtil.display.isEnabledWakeLock(),
      /* 3 */ FunctionUtil.display.getButtonSize(),

      /* 4 */ FunctionUtil.display.isEnabledFadeInAnimationForImage(),
      /* 5 */ FunctionUtil.display.isEnabledLatency(),
      /* 6 */ FunctionUtil.display.isEnabledExitButton(),
      
      /* 7 */ FunctionUtil.display.getImageColumns()
    ]);

    double rawImageColumns = result[7] as double;

    if (rawImageColumns > 6) {
      DisplaySettingFunction.config.saveImageColumns(3);
      rawImageColumns = 3;
    }
    
    setState(() {
      themeMode = result[0] as int;
      navigationBarStyle = result[1] as int;
      wakeLock = result[2] as bool;
      buttonSize = result[3] as double;

      enabledFadeInAnimationForImage = result[4] as bool;
      showLatency = result[5] as bool;
      showExitButton = result[6] as bool;

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
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("Display Setting")),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.display_settings,
                  size: 80,
                  color: Colors.cyan,
                ),

                const SizedBox(height: 16),
                const Column(
                  children: [
                    Text("Control the interface display of the software."),
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                const SizedBox(height: 16),

                const Row(
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

                      const SizedBox(height: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case "system":
                              setState(() {
                                themeMode = 0;
                              });
                              DisplaySettingFunction.config.saveTheme(0);
                              break;
                            
                            case "light":
                              setState(() {
                                themeMode = 1;
                              });
                              DisplaySettingFunction.config.saveTheme(1);
                              break;

                            case "dark":
                              setState(() {
                                themeMode = 2;
                              });
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
                          leading: isDark ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
                          title: const Text("Theme Mode"),
                          subtitle: Text(DisplaySettingFunction.config.getSelectedTheme(themeMode)),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text("Navigation Bar Style"),
                        leading: Icon(Icons.view_sidebar_rounded),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton(
                        segments: [
                          const ButtonSegment(
                            value: 0,
                            label: Text("Bottom"),
                          ),
                          const ButtonSegment(
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
                      const SizedBox(height: 16),
                      const Divider(),
                      SwitchListTile(
                        title: const Text("Wake Lock"),
                        secondary: const Icon(Icons.lightbulb),
                        value: wakeLock,
                        onChanged: (value) {
                          setState(() {
                            wakeLock = value;
                          });

                          DisplaySettingFunction.config.saveWakeLock(value);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Button Size"),
                        leading: const Icon(Icons.open_in_full),
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
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Row(
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

                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text("Fade-In Animation For Image"),
                        secondary: const Icon(Icons.photo_library),
                        value: enabledFadeInAnimationForImage,
                        onChanged: (value) {
                          setState(() {
                            enabledFadeInAnimationForImage = value;
                          });

                          DisplaySettingFunction.config.saveFadeInAnimationForImage(value);
                        },
                      ),
                      const Divider(),

                      SwitchListTile(
                        title: const Text("Show Latency"),
                        secondary: const Icon(Icons.speed),
                        value: showLatency,
                        onChanged: (value) {
                          setState(() {
                            showLatency = value;
                          });

                          DisplaySettingFunction.config.saveLatency(value);
                        },
                      ),
                      const Divider(),

                      SwitchListTile(
                        title: const Text("Show Exit Button"),
                        secondary: const Icon(Icons.power_settings_new),
                        value: showExitButton,
                        onChanged: (value) {
                          setState(() {
                            showExitButton = value;
                          });

                          DisplaySettingFunction.config.saveExitButton(value);
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

                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text("Image Columns"),
                        leading: const Icon(Icons.view_column),
                        trailing: Text(
                          imageColumns.toInt().toString(),
                          style: const TextStyle(fontSize: 16),
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
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 100)
              ],
            ),
            floatingActionButton: FunctionUtil.item.getRestartFloatingActionButton(context),
          );
        }
      },
    );
  }
}