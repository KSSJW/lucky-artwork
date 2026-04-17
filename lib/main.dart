import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/history/history.dart';
import 'package:lucky_artwork/home/home.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/developer_options/developer_options_function.dart';
import 'package:lucky_artwork/setting/setting.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:lucky_artwork/util/context_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(
    Phoenix(
      child: const App(),
    ),
  );
}

int themeMode = 0;
Locale locale = Locale("en", "US");
bool navigationBarLables = true;

class App extends StatelessWidget {
  const App({super.key});

  Future<void> loadConfig() async {
    themeMode = await FunctionUtil.display.getThemeMode();
    locale = await FunctionUtil.display.getLocale();
    navigationBarLables = await FunctionUtil.display.isEnabledNavigationBarLabels();
  }

  ThemeMode getThemeMode() {
    switch (themeMode) {
      case 0:
        return ThemeMode.system;

      case 1:
        return ThemeMode.light;

      case 2:
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadConfig(),
      builder: (context, snapshot) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          locale: locale,
          themeMode: getThemeMode(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MainPage(),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool checked = false;
  bool agreed = false;
  bool automaticUpdateCheck = false;
  int navigationBarStyle = 0;

  bool promptedUpdate = false;
  int selectedIndex = 0;
  final PageController pageController = PageController();

  Future<void> checkAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    agreed = prefs.getBool("user_agreement") ?? false;

    if (!agreed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false, // 不允许点击外部关闭
          builder: (context) {
            return AlertDialog(
              title: const Text("User Agreement 1.0.0"),
              content: SingleChildScrollView(
                child: ContextUtil().getUserAgreement(),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: const Text("Disagree"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        NavigatorState navigatorState = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        await prefs.setBool("user_agreement", true);

                        setState(() {
                          agreed = true;
                          checked = true;
                        });

                        navigatorState.pop();
                        messenger.showSnackBar(
                          const SnackBar(content: Text("You have agreed to the User Agreement")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green
                      ),
                      child: const Text("Agree"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      });
    } else {
      setState(() {
        agreed = true;
        checked = true;
      });
    }
  }

  Future<void> loadConfig() async {
    final result = await Future.wait([
      /* 0 */ FunctionUtil.display.getNavigationBarStyle(),
      /* 1 */ FunctionUtil.network.isAutomaticUpdateCheck(),
      /* 2 */ FunctionUtil.display.isEnabledWakeLock(),
      /* 3 */ DeveloperOptionsFunction.config.isLimitCaching()
    ]);

    bool wakeLock = result[2] as bool;
    bool limitCaching = result[3] as bool;

    if (wakeLock) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    if (limitCaching) {
      PaintingBinding.instance.imageCache.maximumSize = 50;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;
    }

    setState(() {
      navigationBarStyle = result[0]as int;
      automaticUpdateCheck = result[1] as bool;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 1) {
        historyKey.currentState?.refreshHistory();
      }
    });
    
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final GlobalKey<HistoryState> historyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    checkAgreement();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    if (!checked) {
      return const Scaffold(
        body: Text("Initializing ..."),
      );
    }

    if (agreed) {

      bool isDark = Theme.of(context).brightness == Brightness.dark;

      if (automaticUpdateCheck && !promptedUpdate) {
        FunctionUtil.item.showAutoCheckUpdateMessenger(context, isDark);
        promptedUpdate = true;
      }

      // 底部导航栏
      if (navigationBarStyle == 0) {
        return Scaffold(
          extendBody: true,
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
                if (index == 1) {
                  historyKey.currentState?.refreshHistory();
                }
              });
            },
            children: [
              const Home(),
              History(key: historyKey),
              const Setting(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0 + MediaQuery.of(context).padding.bottom),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: MediaQuery.of(context).padding.bottom == 0.0 ? 1.0 : 0.75, // 只显示上半部分
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withAlpha(36),
                          Colors.white.withAlpha(12)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: NavigationBar(
                      height: navigationBarLables ? null : 45.0,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.white,
                      selectedIndex: selectedIndex,
                      onDestinationSelected: onItemTapped,
                      labelBehavior: navigationBarLables ? NavigationDestinationLabelBehavior.onlyShowSelected : NavigationDestinationLabelBehavior.alwaysHide,
                      labelTextStyle: WidgetStateProperty.all(
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                      destinations: [
                        NavigationDestination(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.navigation_home),
                        NavigationDestination(icon: const Icon(Icons.history), label: AppLocalizations.of(context)!.navigation_history),
                        NavigationDestination(icon: const Icon(Icons.settings), label: AppLocalizations.of(context)!.navigation_setting),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // 右侧导航栏
      if (navigationBarStyle == 1) {
        return Scaffold(
          body: Stack(
            children: [

              // 主内容区域
              Positioned.fill(
                child: PageView(
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                      if (index == 1) {
                        historyKey.currentState?.refreshHistory();
                      }
                    });
                  },
                  children: [
                    const Home(),
                    History(key: historyKey),
                    const Setting(),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: navigationBarLables ? 350.0 : 320.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24), // 圆角
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // 毛玻璃模糊
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withAlpha(36),
                              Colors.white.withAlpha(12)
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: NavigationRail(
                          backgroundColor: Colors.transparent,
                          selectedIndex: selectedIndex,
                          onDestinationSelected: onItemTapped,
                          labelType: navigationBarLables ? NavigationRailLabelType.all : NavigationRailLabelType.none,
                          groupAlignment: 0.0,
                          destinations: [
                            NavigationRailDestination(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              icon: const Icon(Icons.home),
                              label: Text(AppLocalizations.of(context)!.navigation_home),
                            ),
                            NavigationRailDestination(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              icon: const Icon(Icons.history),
                              label: Text(AppLocalizations.of(context)!.navigation_history),
                            ),
                            NavigationRailDestination(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              icon: const Icon(Icons.settings),
                              label: Text(AppLocalizations.of(context)!.navigation_setting),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }

      // Fallback
      return const Scaffold(
        body: Text("NavigationBar Error"),
      );
    } else {
      return const Scaffold(
        body: Text("Initializing ..."),
      );
    }
  }
}