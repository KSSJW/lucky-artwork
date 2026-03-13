import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucky_artwork/json/many_acg_json.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 0;

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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting")
          ]
        ),
      )
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<ManyACGApiResponse> futureResponse;

  Future<ManyACGApiResponse> fetchData() async {
    final response = await http.get(Uri.parse("https://manyacg.top/api/v1/artwork/random"));

    if (response.statusCode == 200) {
      return ManyACGApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Get Error: ${response.statusCode}");
    }
  }
  
  @override
  void initState() {
    super.initState();
    futureResponse = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lucky Artwork")),
      body: FutureBuilder<ManyACGApiResponse>(
        future: futureResponse,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 加载中
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // 错误提示
          } else if (snapshot.hasData) {
            final item = snapshot.data!.data[0]; // 拿到第一条作品

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text("Title: ${item.title}", style: const TextStyle(fontSize: 18)),
                Text("Author: ${item.artist.name}"),
                const SizedBox(height: 12),
                // 显示所有图片
                ...item.pictures.map((pic) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Image ${pic.index} (${pic.width}x${pic.height})"),
                    Image.network(pic.regular),
                    const SizedBox(height: 16),
                  ],
                )),
              ],
            );
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            futureResponse = fetchData(); // 点击刷新
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  String version = "1.0.0-alpha.1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.api),
            title: Text("API"),
            subtitle: Text("Under construction ..."),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.update),
            title: Text("Update"),
            subtitle: Text("Update ..."),
            onTap: () => {
              launchUrl(Uri.parse("https://github.com/KSSJW/lucky-artwork/releases/latest"), mode: LaunchMode.externalApplication)
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("Info"),
            subtitle: Text("Info ..."),
            onTap: () => {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog (
                    title: Text("Lucky Artwork"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: "Version: "),
                              TextSpan(
                                text: version,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(text: "\n\n"),

                              TextSpan(text: "Project: "),
                              TextSpan(
                                text: "lucky-artwork",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://github.com/KSSJW/lucky-artwork"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(text: "Author: "),
                              TextSpan(
                                text: "KSSJW",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://github.com/KSSJW"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                              TextSpan(text: "\n\n"),

                              TextSpan(text: "Thanks to the API providers, who provided the soul of this software."),
                              TextSpan(text: "\n\n"),

                              TextSpan(
                                text: "ManyACG",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://manyacg.top"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: const Text("Cancel"),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              )
            },
          ),
        ]
      )
    );
  }
}