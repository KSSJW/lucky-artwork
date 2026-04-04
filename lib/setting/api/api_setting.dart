import 'package:flutter/material.dart';
import 'package:lucky_artwork/setting/api/api_setting_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingPage extends StatefulWidget {
  const ApiSettingPage({super.key});

  @override
  ApiSettingPageState createState() => ApiSettingPageState();
}

class ApiSettingPageState extends State<ApiSettingPage> {
  final TextEditingController _controller = TextEditingController();
  String selectedApi = "";

  final List<String> builtInApis = [
    "https://manyacg.top/sese",
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
      appBar: AppBar(title: const Text("API Settings")),
      body: Column(
        children: [
          Text("The API needs to return an image, not JSON."),
          Text("You can edit the text box to add custom APIs."),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Custom API URL",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allApis.length,
              itemBuilder: (context, index) {
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
                  trailing: isBuiltIn
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeCustomApi(api),
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
        label: const Text("Save"),
      ),
    );
  }
}