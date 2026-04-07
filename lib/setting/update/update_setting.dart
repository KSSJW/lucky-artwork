import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/update/update_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateSettingPage extends StatefulWidget {
  const UpdateSettingPage({super.key});

  @override
  State<StatefulWidget> createState() => UpdateSettingPageState();
}

class UpdateSettingPageState extends State<UpdateSettingPage> {
  late Future configLoadFuture;

  bool automaticUpdateCheck = true;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    bool rawAutomaticUpdateCheck = prefs.getBool("automatic_update_check") ?? true;

    setState(() {
      automaticUpdateCheck = rawAutomaticUpdateCheck;
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
    return FutureBuilder(
      future: configLoadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("Update Setting")),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.arrow_circle_up,
                  size: 80,
                  color: Colors.green,
                ),

                const SizedBox(height: 16),
                const Column(
                  children: [
                    Text("Get software updates."),
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Update Inspector",
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
                        title: const Text("Automatic Update Check"),
                        secondary: const Icon(Icons.tips_and_updates),
                        value: automaticUpdateCheck,
                        onChanged: (value) {
                          setState(() {
                            automaticUpdateCheck = value;
                          });

                          UpdateSettingFunction.config.saveAutomaticUpdateCheck(value);
                        },
                      ),
                      const Divider(),

                      ListTile(
                        leading: const Icon(Icons.search),
                        title: const Text("Check Update"),
                        onTap: () {
                          FunctionUtil.item.showUpdateAlertDialog(context);
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
                      "Manual Update",
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
                        leading: const Icon(Icons.manage_search),
                        title: const Text("Visit Releases Page"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          launchUrl(Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"), mode: LaunchMode.externalApplication);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
            floatingActionButton: FunctionUtil.item.getRestartFloatingActionButton(context),
          );
        }
      }
    );
  }
}