import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Welcome to this software. Please read the following terms carefully before you begin using it:"),
                    SizedBox(height: 16),

                    Text(
                      "1. License:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("You may only use this software in compliance with this agreement. This software is for personal learning and communication purposes only and may not be used for illegal or infringing activities."),
                    SizedBox(height: 8),

                    Text(
                      "2. Data and Privacy:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("When calling third-party APIs or user-defined APIs, HTTP requests may contain necessary technical information (such as device identifiers, request headers, cookies, authentication tokens, etc.) and data you actively provide in the request (such as account, email, location, or other parameters). This information may involve privacy during transmission. We recommend that you:"),
                    SizedBox(height: 4),

                    Text("- Provide relevant data only when necessary;"),
                    Text("- Avoid including sensitive information in requests;"),
                    Text("- Use security protocols such as HTTPS to ensure encrypted data transmission"),
                    Text("- When configuring custom APIs, ensure they are legal, compliant, and meet privacy protection requirements."),
                    SizedBox(height: 8),

                    Text(
                      "3. Third-Party API Usage:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("This software obtains data by calling third-party APIs. You understand and agree that:"),
                    SizedBox(height: 4),

                    Text("- The data and services of third-party APIs are the responsibility of the respective providers, and this software is not responsible for their accuracy, legality, or availability."),
                    Text("- When using third-party APIs, you must comply with the API provider's terms of service and privacy policy."),
                    Text("- This software shall not be liable for any consequences arising from the interruption, change, or termination of third-party API services."),
                    SizedBox(height: 8),

                    Text(
                      "4. User-Defined API Usage:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("This software allows users to configure and call custom APIs. You understand and agree that:"),
                    SizedBox(height: 4),

                    Text("- You are solely responsible for ensuring that the configured APIs are legal, compliant, and do not infringe upon the rights of others."),
                    Text("- You shall bear all risks, losses, or legal liabilities arising from the use of custom APIs."),
                    Text("- This software is not responsible for the content, stability, or security of user-defined APIs."),
                    SizedBox(height: 8),

                    Text(
                      "5. User Responsibility:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("You shall ensure that you comply with relevant laws and regulations while using this software and shall not upload or disseminate illegal, infringing, or inappropriate content."),
                    SizedBox(height: 8),

                    Text(
                      "6. Disclaimer:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("This software is provided \"as is\" and is not liable for any errors, data loss, or other losses that may occur during use."),
                    SizedBox(height: 8),

                    Text(
                      "7. Agreement Changes:",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text("We reserve the right to modify this agreement as necessary. The modified agreement will be published and take effect in the updated version."),
                    SizedBox(height: 16),

                    Text("Clicking \"Agree\" indicates that you have read and accepted the above terms.")
                  ],
                ),
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future futureResponse;
  Uint8List? bytes;

  Future fetchData() async {
    final response = await http.get(Uri.parse("https://manyacg.top/sese"));

    if (response.statusCode == 200) {
      bytes = response.bodyBytes;
      return response;
    } else {
      throw Exception("Get Error: ${response.statusCode}");
    }
  }

  Future<void> saveImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    final messenger = ScaffoldMessenger.of(context);

    String extension = "png";

    // 根据 content-type 决定扩展名
    if (contentType?.contains("jpeg") ?? false) {
      extension = "jpg";
    } else if (contentType?.contains("webp") ?? false) {
      extension = "webp";
    }
    
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) {
        messenger.showSnackBar(
          SnackBar(content: Text("Failed to save image")),
        );

        return;
      }

      final file = File("${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}.$extension");
      await file.writeAsBytes(response.bodyBytes);
      messenger.showSnackBar(
        SnackBar(content: Text("Image saved to: ${file.path}")),
      );

      return;
    }

    if (Platform.isAndroid) {

      if (await Permission.storage.request().isGranted) {
        final result = await ImageGallerySaverPlus.saveImage(
          response.bodyBytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}.$extension"
        );

        if (result['isSuccess']) {
          final savedPath = result['filePath'];
          messenger.showSnackBar(
            SnackBar(content: Text("Image saved to: $savedPath")),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("Failed to save image")),
          );
        }

        return;
      }
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
      body: FutureBuilder(
        future: futureResponse,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 加载中
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // 错误提示
          } else if (snapshot.hasData) {            
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 12),
                Image.memory(bytes!)
              ],
            );
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              exit(0);  // 退出
            },
            tooltip: "Exit",
            child: const Icon(Icons.cancel_outlined),
          ),
          const SizedBox(width: 12),

          FloatingActionButton(
            onPressed: () async {
              saveImage(await futureResponse);
            },
            tooltip: "Next",
            child: Icon(Icons.download),
          ),
          const SizedBox(width: 12),

          FloatingActionButton(
            onPressed: () {
              setState(() {
                futureResponse = fetchData(); // 刷新
              });
            },
            tooltip: "Next",
            child: Icon(Icons.refresh),
          ),
        ],
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
  String version = "1.0.0-alpha.3";

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