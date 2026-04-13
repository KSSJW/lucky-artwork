import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/setting/developer_options/developer_options_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({super.key});

  @override
  State<StatefulWidget> createState() => DeveloperOptionsPageState();
}

class DeveloperOptionsPageState extends State<DeveloperOptionsPage> {
  late Future configLoadFuture;

  int rssMb = 0;
  late Timer _timer;

  bool limitCaching = false;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      /* 0 */DeveloperOptionsFunction.config.isLimitCaching()
    ]);

    setState(() {
      limitCaching = result[0];
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
  
    configLoadFuture = loadConfig();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        rssMb = ProcessInfo.currentRss >> 20;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
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
            appBar: AppBar(title: const Text("Developer Options")),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.code,
                  size: 80,
                  color: Colors.teal,
                ),

                const SizedBox(height: 16),
                const Column(
                  children: [
                    Text("Used for testing or advanced control."),
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                const SizedBox(height: 16),

                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Configuration",
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
                        leading: const Icon(Icons.settings_backup_restore),
                        title: const Text("Reset Configuration"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Reset Configuration"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Are you sure you want to reset the configuration?"),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "The software configuration will be reset, but the history will still be retained.",
                                      style: TextStyle(
                                        color: Colors.orange
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await DeveloperOptionsFunction.config.resetConfig();
                                          if (context.mounted) Phoenix.rebirth(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text("Reset"),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
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
                      "Performance",
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
                        leading: const Icon(Icons.data_usage),
                        title: Text("Current Resident Set Size"),
                        subtitle: Text("$rssMb MB"),
                        onTap: () {},
                      ),

                      const Divider(),

                      SwitchListTile(
                        title: const Text("Limit Caching"),
                        subtitle: const Text("Use a more conservative caching strategy."),
                        secondary: const Icon(Icons.memory),
                        value: limitCaching,
                        onChanged: (value) {
                          setState(() {
                            limitCaching = value;
                          });

                          DeveloperOptionsFunction.config.saveLimitCaching(value);
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