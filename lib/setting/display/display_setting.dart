import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  DisplaySettingPageState createState() => DisplaySettingPageState();
}

class DisplaySettingPageState extends State<DisplaySettingPage> {
  bool showLatency = true;
  
  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showLatency = prefs.getBool("show_latency") ?? true;
    });

    return true;
  }

  Future<void> saveConfig(bool bool) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_latency", bool);
  }

  Future<bool> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("show_latency") ?? true;
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadConfig(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Display Setting")),
            body: ListView(
              children: [
                SwitchListTile(
                  title: Text("Show Latency"),
                  value: showLatency,
                  onChanged: (value) {
                    setState(() {
                      showLatency = value;
                      saveConfig(value);
                    });
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}