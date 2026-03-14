import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/home/home.dart';
import 'package:lucky_artwork/setting/setting.dart';
import 'package:lucky_artwork/user_agreement/user_agreement_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
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
    });
  }

  final List<Widget> pages = [
    Home(),
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
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting")
          ]
        ),
      ); 
    } else {
      return Scaffold(
        body: Text("Initializing ..."),
      );
    }
  }
}