import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/history/history.dart';
import 'package:lucky_artwork/home/home.dart';
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

class App extends StatelessWidget {
  const App({super.key});

  Future<void> loadThemeMode() async {
    var prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getInt("theme_mode") ?? 0;
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
      future: loadThemeMode(),
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
          themeMode: getThemeMode(),
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
  bool automaticUpdateCheck = true;
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

  Future<void> loadNavigationBarStyle() async {
    navigationBarStyle = await FunctionUtil.display.getNavigationBarStyle();
  }

  Future<void> loadAutomaticUpdateCheck() async {
    automaticUpdateCheck = await FunctionUtil.network.isAutomaticUpdateCheck();
  }

  Future<void> checkWakeLock() async {
    await FunctionUtil.display.isEnabledWakeLock() ? WakelockPlus.enable() : WakelockPlus.disable();
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
    loadNavigationBarStyle();
    loadAutomaticUpdateCheck();
    checkWakeLock();
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
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onItemTapped,
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              const NavigationDestination(icon: Icon(Icons.history), label: "History"),
              const NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
            ],
          ),
        );
      }

      // 左侧导航栏
      if (navigationBarStyle == 1) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onItemTapped,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  const NavigationRailDestination(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  const NavigationRailDestination(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    icon: Icon(Icons.history),
                    label: Text("History"),
                  ),
                  const NavigationRailDestination(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    icon: Icon(Icons.settings),
                    label: Text("Setting"),
                  ),
                ],
              ),

              // 主内容区域
              Expanded(
                child: Column(
                  children: [
                    Expanded(
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
                  ],
                ),
              ),
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