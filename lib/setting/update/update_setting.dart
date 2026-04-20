import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/update/update_setting_function.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateSetting extends StatefulWidget {
  const UpdateSetting({super.key});

  @override
  State<StatefulWidget> createState() => UpdateSettingState();
}

class UpdateSettingState extends State<UpdateSetting> {
  late Future configLoadFuture;

  bool automaticUpdateCheck = false;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    bool rawAutomaticUpdateCheck = prefs.getBool("automatic_update_check") ?? false;

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
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.updateSetting_appbar_title)),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.arrow_circle_up,
                  size: 80,
                  color: Colors.green,
                ),

                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.updateSetting_desc_content1),
                    Text(AppLocalizations.of(context)!.updateSetting_desc_content2)
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      AppLocalizations.of(context)!.updateSetting_list_updateInspector,
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
                        title: Text(AppLocalizations.of(context)!.updateSetting_updateInspector_automaticUpdateCheck),
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
                        title: Text(AppLocalizations.of(context)!.updateSetting_updateInspector_checkUpdate),
                        onTap: () {
                          UpdateSettingFunction.item.showUpdateAlertDialog(context);
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
                      AppLocalizations.of(context)!.updateSetting_list_manualUpdate,
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
                        leading: const Icon(Icons.manage_search),
                        title: Text(AppLocalizations.of(context)!.updateSetting_manualUpdate_visitReleasesPage),
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