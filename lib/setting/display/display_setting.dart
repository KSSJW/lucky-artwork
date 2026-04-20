import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/display/display_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class DisplaySetting extends StatefulWidget {
  const DisplaySetting({super.key});

  @override
  DisplaySettingState createState() => DisplaySettingState();
}

class DisplaySettingState extends State<DisplaySetting> {
  late Future configLoadFuture;

  Locale locale = Locale("en", "US");
  int themeMode = 0;
  int navigationBarStyle = 0;
  bool navigationBarLables = true;
  bool wakeLock = false;
  double buttonSize = 56.0;

  bool fadeInAnimationForImage = true;
  bool showLatency = true;
  bool exitButton = false;

  double imageColumns = 3;
  bool exploreButton = true;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      /* 0 */ FunctionUtil.display.getLocale(),
      /* 1 */ FunctionUtil.display.getThemeMode(),
      /* 2 */ FunctionUtil.display.getNavigationBarStyle(),
      /* 3 */ FunctionUtil.display.isEnabledNavigationBarLabels(),
      /* 4 */ FunctionUtil.display.isEnabledWakeLock(),
      /* 5 */ FunctionUtil.display.getButtonSize(),

      /* 6 */ FunctionUtil.display.isEnabledFadeInAnimationForImage(),
      /* 7 */ FunctionUtil.display.isEnabledLatency(),
      /* 8 */ FunctionUtil.display.isEnabledExitButton(),

      /* 9 */ FunctionUtil.display.getImageColumns(),
      /* 10 */ FunctionUtil.display.isEnabledExploreButton()
    ]);

    double rawImageColumns = result[9] as double;

    if (rawImageColumns > 6) {
      DisplaySettingFunction.config.saveImageColumns(3);
      rawImageColumns = 3;
    }
    
    setState(() {
      locale = result[0] as Locale;
      themeMode = result[1] as int;
      navigationBarStyle = result[2] as int;
      navigationBarLables = result[3] as bool;
      wakeLock = result[4] as bool;
      buttonSize = result[5] as double;

      fadeInAnimationForImage = result[6] as bool;
      showLatency = result[7] as bool;
      exitButton = result[8] as bool;

      imageColumns = rawImageColumns;
      exploreButton = result[10] as bool;
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
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.displaySetting_appbar_title)),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.display_settings,
                  size: 80,
                  color: Colors.cyan,
                ),

                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.displaySetting_desc_content1),
                    Text(AppLocalizations.of(context)!.displaySetting_desc_content2)
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.displaySetting_list_global,
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
                      PopupMenuButton<Locale>(
                        onSelected: (value) {
                          setState(() {
                            locale = value;
                          });

                          DisplaySettingFunction.config.saveLocale(value.toString());
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                          const PopupMenuItem<Locale>(
                            value: Locale("en", "US"),
                            child: Text("English (US)"),
                          ),
                          const PopupMenuItem<Locale>(
                            value: Locale("zh", "CN"),
                            child: Text("简体中文 (中国大陆)"),
                          ),
                          const PopupMenuItem<Locale>(
                            value: Locale("zh", "HK"),
                            child: Text("繁體中文 (香港)"),
                          ),
                          const PopupMenuItem<Locale>(
                            value: Locale("zh", "TW"),
                            child: Text("繁體中文 (台灣)"),
                          ),
                        ],
                        child: ListTile(
                          leading: Icon(Icons.language),
                          title: Text(AppLocalizations.of(context)!.displaySetting_global_language),
                          subtitle: Text(locale.toString()),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      const Divider(),
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
                          PopupMenuItem(
                            value: "system",
                            child: Text(AppLocalizations.of(context)!.displaySetting_global_themeMode_system),
                          ),
                          PopupMenuItem(
                            value: "light",
                            child: Text(AppLocalizations.of(context)!.displaySetting_global_themeMode_light),
                          ),
                          PopupMenuItem(
                            value: "dark",
                            child: Text(AppLocalizations.of(context)!.displaySetting_global_themeMode_dark),
                          ),
                        ],
                        child: ListTile(
                          leading: isDark ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
                          title: Text(AppLocalizations.of(context)!.displaySetting_global_themeMode),
                          subtitle: Text(DisplaySettingFunction.config.getSelectedTheme(themeMode, context)),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.displaySetting_global_navigationBarStyle),
                        leading: const Icon(Icons.view_sidebar_rounded),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton(
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: Text(AppLocalizations.of(context)!.displaySetting_global_navigationBarStyle_auto),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: Text(AppLocalizations.of(context)!.displaySetting_global_navigationBarStyle_button),
                          ),
                          ButtonSegment(
                            value: 2,
                            label: Text(AppLocalizations.of(context)!.displaySetting_global_navigationBarStyle_right),
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
                        title: Text(AppLocalizations.of(context)!.displaySetting_global_navigationBarLabels),
                        secondary: const Icon(Icons.label),
                        value: navigationBarLables,
                        onChanged: (value) {
                          setState(() {
                            navigationBarLables = value;
                          });

                          DisplaySettingFunction.config.saveNavigationBarLabels(value);
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.displaySetting_global_wakeLock),
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
                        title: Text(AppLocalizations.of(context)!.displaySetting_global_buttonSize),
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

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.displaySetting_list_home,
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
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.displaySetting_home_fadeInAnimationForImage),
                        secondary: const Icon(Icons.photo_library),
                        value: fadeInAnimationForImage,
                        onChanged: (value) {
                          setState(() {
                            fadeInAnimationForImage = value;
                          });

                          DisplaySettingFunction.config.saveFadeInAnimationForImage(value);
                        },
                      ),
                      const Divider(),

                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.displaySetting_home_showLatency),
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
                        title: Text(AppLocalizations.of(context)!.displaySetting_home_exitButton),
                        secondary: const Icon(Icons.power_settings_new),
                        value: exitButton,
                        onChanged: (value) {
                          setState(() {
                            exitButton = value;
                          });

                          DisplaySettingFunction.config.saveExitButton(value);
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
                      AppLocalizations.of(context)!.displaySetting_list_history,
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
                        title: Text(AppLocalizations.of(context)!.displaySetting_history_imageColumns),
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

                      const Divider(),

                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.displaySetting_history_exploreButton),
                        secondary: const Icon(Icons.explore),
                        value: exploreButton,
                        onChanged: (value) {
                          setState(() {
                            exploreButton = value;
                          });

                          DisplaySettingFunction.config.saveExploreButton(value);
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