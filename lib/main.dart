import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/history/history.dart';
import 'package:lucky_artwork/home/home.dart';
import 'package:lucky_artwork/setting/setting.dart';
import 'package:lucky_artwork/user_agreement/user_agreement_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(
    Phoenix(
      child: App(),
    ),
  );
}

int themeMode = 0;

class App extends StatelessWidget {
  const App({super.key});

  Future<bool> loadThemeMode() async {
    var prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getInt("theme_mode") ?? 0;

    return true;
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
                child: UserAgreementContext().get(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text("Disagree"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await prefs.setBool("user_agreement", true);
                    setState(() {
                      agreed = true;
                      checked = true;
                      Navigator.of(context).pop();
                    });
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

  List<Widget> get pages => [
    Home(),
    History(key: historyKey),
    Setting()
  ];

  @override
  void initState() {
    super.initState();
    checkAgreement();
  }

  @override
  Widget build(BuildContext context) {
    if (!checked) {
      return const Scaffold(
        body: Text("Initializing ..."),
      );
    }

    if (agreed) {
      return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          Home(),
          History(key: historyKey),
          Setting(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.history), label: "History"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
    } else {
      return Scaffold(
        body: Text("Initializing ..."),
      );
    }
  }
}