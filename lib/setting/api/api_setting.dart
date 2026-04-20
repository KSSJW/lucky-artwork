import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:lucky_artwork/setting/api/api_setting_function.dart';
import 'package:lucky_artwork/setting/api/api_setting_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSetting extends StatefulWidget {
  const ApiSetting({super.key});

  @override
  ApiSettingState createState() => ApiSettingState();
}

class ApiSettingState extends State<ApiSetting> {
  final TextEditingController _controller = TextEditingController();
  String selectedApi = "";

  final List<String> builtInApis = [
    "https://manyacg.top/sese",
    "https://pixiv.yuki.sh/api/recommend?size=regular",
    "https://app.zichen.zone/api/acg/api.php",
    "https://www.dmoe.cc/random.php",
    "https://img.paulzzh.com/touhou/random"
  ];

  List<String> customApis = [];

  @override
  void initState() {
    super.initState();
    loadApi();
  }

  Future<void> loadApi() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      customApis = prefs.getStringList("custom_apis") ?? [];
      selectedApi = prefs.getString("api_url") ?? builtInApis.first;
      _controller.text = selectedApi;
    });
  }

  void addCustomApi() {
    final newApi = _controller.text.trim();
    if (
      newApi.isNotEmpty
      && !builtInApis.contains(newApi)
      && !customApis.contains(newApi)
    ) {
      setState(() {
        customApis.add(newApi);
      });

      ApiSettingFunction.config.saveCustomApis(customApis);
    }
  }

  void removeCustomApi(String api) {
    setState(() {
      customApis.remove(api);
    });
    
    ApiSettingFunction.config.saveCustomApis(customApis);
  }

  @override
  Widget build(BuildContext context) {
    final allApis = [...builtInApis, ...customApis];

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.apiSetting_appbar_title)),
      body: Column(
        children: [
          const Icon(
            Icons.api,
            size: 80,
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 16),
          Column(
            children: [
              Text(AppLocalizations.of(context)!.apiSetting_desc_content1),
              Text(AppLocalizations.of(context)!.apiSetting_desc_content2),
              Text(AppLocalizations.of(context)!.apiSetting_desc_content3),
            ],
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.apiSetting_inputDecoration_label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allApis.length +1,
              itemBuilder: (context, index) {
                if (index == allApis.length) {
                  return const SizedBox(height: 100); 
                }

                final api = allApis[index];
                final isBuiltIn = builtInApis.contains(api);
                return ListTile(
                  title: Text(api),
                  leading: RadioGroup<String>(
                    groupValue: selectedApi,
                    onChanged: (value) {
                      setState(() {
                        selectedApi = value!;
                        _controller.text = value;
                      });

                      ApiSettingFunction.config.saveApi(value!);
                    },
                    child: Radio<String>(value: api),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // 检查连通性按钮
                      ApiCheckButton(api: api),

                      // 删除按钮
                      if (!isBuiltIn) IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red
                        ),
                        onPressed: () => removeCustomApi(api),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedApi = api;
                      _controller.text = api;
                    });

                    ApiSettingFunction.config.saveApi(api);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "ApiSettingSave",
        onPressed: () {
          final customApi = _controller.text.trim();
          final chosenApi = customApi.isNotEmpty ? customApi : selectedApi;
          if (chosenApi.isNotEmpty) {
            if (!builtInApis.contains(customApi) &&
                !customApis.contains(customApi) &&
                customApi.isNotEmpty) {
              addCustomApi();
            }
            ApiSettingFunction.config.saveApi(chosenApi);
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.save),
        label: Text(AppLocalizations.of(context)!.apiSetting_button_save),
      ),
    );
  }
}