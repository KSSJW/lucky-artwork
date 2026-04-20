import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/developer_options/developer_options_function.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:system_info3/system_info3.dart';

class DeveloperOptions extends StatefulWidget {
  const DeveloperOptions({super.key});

  @override
  State<StatefulWidget> createState() => DeveloperOptionsState();
}

class DeveloperOptionsState extends State<DeveloperOptions> {
  late Future configLoadFuture;

  late Timer _timer;
  final rssNotifier = ValueNotifier<int>(0);
  final maxRssNotifier = ValueNotifier<int>(0);

  final limitCachingNotifier = ValueNotifier<bool>(false);

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      /* 0 */DeveloperOptionsFunction.config.isLimitCaching()
    ]);

    limitCachingNotifier.value = result[0];

    return true;
  }

  @override
  void initState() {
    super.initState();
  
    configLoadFuture = loadConfig();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      rssNotifier.value = ProcessInfo.currentRss >> 20;
      maxRssNotifier.value = ProcessInfo.maxRss >> 20;
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _timer.cancel();
      },
      child: FutureBuilder(
        future: configLoadFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(title: Text(AppLocalizations.of(context)!.developerOptions_appbar_title)),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [

                  const Icon(
                    Icons.code,
                    size: 80,
                    color: Colors.teal,
                  ),

                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.developerOptions_desc_content1),
                      Text(AppLocalizations.of(context)!.developerOptions_desc_content2)
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        AppLocalizations.of(context)!.developerOptions_list_configuration,
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
                          leading: const Icon(Icons.settings_backup_restore),
                          title: Text(AppLocalizations.of(context)!.developerOptions_configuration_reset),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!.developerOptions_dialog_resetConfiguration_title),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context)!.developerOptions_dialog_resetConfiguration_content1),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!.developerOptions_dialog_resetConfiguration_content2,
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
                                          child: Text(AppLocalizations.of(context)!.developerOptions_dialog_resetConfiguration_cancel),
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
                                          child: Text(AppLocalizations.of(context)!.developerOptions_dialog_resetConfiguration_reset),
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

                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        AppLocalizations.of(context)!.developerOptions_list_performance,
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
                          leading: const Icon(Icons.data_usage),
                          title: Text(AppLocalizations.of(context)!.developerOptions_performance_ramOverview),
                          subtitle: ValueListenableBuilder<int>(
                            valueListenable: rssNotifier,
                            builder: (_, rssMb, _) {
                              return rssMb == 0 ? Text("...") : Text("$rssMb MB / ${(SysInfo.getAvailablePhysicalMemory() >> 20) + rssMb} MB    Max: ${maxRssNotifier.value} MB");
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: rssNotifier,
                                  builder: (_, rssMb, _) {
                                    return LinearProgressIndicator(
                                      value: maxRssNotifier.value / ((SysInfo.getAvailablePhysicalMemory() >> 20) + rssMb),
                                      backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(64),
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable: rssNotifier,
                                  builder: (_, rssMb, _) {
                                    return LinearProgressIndicator(
                                      value: rssMb / ((SysInfo.getAvailablePhysicalMemory() >> 20) + rssMb),
                                      backgroundColor: Colors.transparent,
                                      color: Theme.of(context).colorScheme.primary,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(),

                        ValueListenableBuilder(valueListenable: limitCachingNotifier, builder: (_, limitCaching, _) {
                          return SwitchListTile(
                            title: Text(AppLocalizations.of(context)!.developerOptions_performance_limitCaching),
                            subtitle: Text(AppLocalizations.of(context)!.developerOptions_performance_limitCaching_desc),
                            secondary: const Icon(Icons.memory),
                            value: limitCaching,
                            onChanged: (value) {
                              limitCachingNotifier.value = value;

                              DeveloperOptionsFunction.config.saveLimitCaching(value);
                            },
                          );
                        }),
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
      ),
    );
  }
}