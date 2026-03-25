import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with RouteAware {
  late Future futureResponse;
  Uint8List? bytes;
  late bool showLatency;
  late bool showExitButton;
  late Stopwatch stopwatch;
  late double buttonSize;

  Future<double> getButtonSize() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getDouble("button_size") ?? 56.0;
  }

  Future<String> getAPI() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString("api_url") ?? "https://manyacg.top/sese";  // 默认情况
  }

  Future<bool> getLatency() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_latency") ?? true;
  }

  Future<bool> getExitButton() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getBool("show_exit_button") ?? false;
  }

  void loadConfig() async {
    bool tempShowExitbutton = await getExitButton();
    double tempSize = await getButtonSize();
    setState(() {
      showExitButton = tempShowExitbutton;
      buttonSize = tempSize;
    });
  }

  Future fetchData() async {
    var api = getAPI();

    if (await getLatency()) {
      showLatency = true;
      stopwatch = Stopwatch()..start();
    } else {
      showLatency = false;
    }

    final response = await http.get(Uri.parse(await api));

    if (showLatency) stopwatch.stop();

    if (response.statusCode == 200) {
      bytes = response.bodyBytes;
      await cacheImage(response); // 缓存

      return response;
    } else {
      throw Exception("Get Error: ${response.statusCode}");
    }
  }

  Future<void> cacheImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    String extension = "raw";
    Directory cacheDir = await getTemporaryDirectory();

    // 根据 content-type 决定扩展名
    if (contentType?.contains("png") ?? false) {
      extension = "png";
    } else if (contentType?.contains("jpeg") ?? false) {
      extension = "jpg";
    } else if (contentType?.contains("webp") ?? false) {
      extension = "webp";
    }

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      cacheDir = Directory('$home/.cache/com.kssjw.lucky_artwork/images');
    }

    if (Platform.isAndroid) {
      final imagesDir = Directory("${cacheDir.path}/images");
      cacheDir = imagesDir;
    }

    if (!cacheDir.existsSync()) cacheDir.createSync(recursive: true);

    final file = File("${cacheDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.$extension");
    await file.writeAsBytes(response.bodyBytes);
  }

  Future<void> saveImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    final messenger = ScaffoldMessenger.of(context);

    String extension = "raw";

    // 根据 content-type 决定扩展名
    if (contentType?.contains("png") ?? false) {
      extension = "png";
    } else if (contentType?.contains("jpeg") ?? false) {
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
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.photos,
      ].request();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final result = await ImageGallerySaverPlus.saveImage(
          response.bodyBytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}.$extension"
        );

        if (result['isSuccess']) {
          messenger.showSnackBar(
            SnackBar(content: Text("Image saved to: /Pictures")),
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
    loadConfig();
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
                if (showLatency) Text("Latency: ${stopwatch.elapsedMilliseconds} ms"),
                SizedBox(height: 6),
                Image.memory(bytes!),
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
          
          if (showExitButton) SizedBox(
            width: buttonSize,
            height: buttonSize,
            child:  FloatingActionButton(
              heroTag: "Exit",
              onPressed: () {
                exit(0);  // 退出
              },
              tooltip: "Exit",
              child: Icon(
                Icons.cancel_outlined,
                size: buttonSize * 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "Download",
              onPressed: () async {
                saveImage(await futureResponse);
              },
              tooltip: "Download",
              child: Icon(
                Icons.download,
                size: buttonSize * 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "Next",
              onPressed: () {
                setState(() {
                  futureResponse = fetchData(); // 刷新
                });
              },
              tooltip: "Next",
              child: Icon(
                Icons.refresh,
                size: buttonSize * 0.5,
              ),
            ),
          ),          
        ],
      ),
    );
  }
}