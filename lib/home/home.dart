import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lucky_artwork/util/function_util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with RouteAware {
  late Future futureResponse;
  Uint8List? bytes;
  late Stopwatch stopwatch;
  bool showExitButton = false;
  double buttonSize = 56.0;
  bool enabledCacheAndHistory = true;
  bool showLatency = true;

  Future loadConfig() async {
    final results = await Future.wait([
      FunctionUtilOfDisplay().isEnabledExitButton(),
      FunctionUtilOfDisplay().getButtonSize(),
      FunctionUtilOfStorage().isEnabledCacheAndHistory(),
    ]);

    setState(() {
      showExitButton = results[0] as bool;
      buttonSize = results[1] as double;
      enabledCacheAndHistory = results[2] as bool;
    });
  }

  Future fetchData() async {
    var api = await FunctionUtilOfNetwork().getAPI();

    if (await FunctionUtilOfDisplay().isEnabledLatency()) {
      showLatency = true;
      stopwatch = Stopwatch()..start();
    } else {
      showLatency = false;
    }

    final response = await http.get(Uri.parse(api));

    if (showLatency) stopwatch.stop();

    if (response.statusCode == 200) {
      bytes = response.bodyBytes;
      
      if (enabledCacheAndHistory) await cacheImage(response); // 缓存

      return response;
    } else {
      throw Exception("Get Error: ${response.statusCode}");
    }
  }

  Future<void> cacheImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    String extension = FunctionUtilOfStorage().getExtensionOfContentType(contentType);
    Directory cacheDir = await FunctionUtilOfStorage().getCacheDir();

    if (!cacheDir.existsSync()) cacheDir.createSync(recursive: true);

    final file = File("${cacheDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.$extension");
    await file.writeAsBytes(response.bodyBytes);
  }

  Future<void> saveImage(http.Response response) async {
    final contentType = response.headers['content-type'];
    String extension = FunctionUtilOfStorage().getExtensionOfContentType(contentType);
    final messenger = ScaffoldMessenger.of(context);
    
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
      Map<Permission, PermissionStatus> statuses = await FunctionUtilOfStorage().requestImagePermissionsPnAndroid();

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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(bytes: bytes!, buttonSize: buttonSize),
                      ),
                    );
                  },
                  child:  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height > 224.0 ? MediaQuery.of(context).size.height - 168.0 : MediaQuery.of(context).size.height,
                    ),
                    child: Image.memory(
                      bytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
          if (showExitButton) const SizedBox(width: 12),

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

class FullScreenImage extends StatefulWidget {
  final Uint8List? bytes;
  final double buttonSize;

  const FullScreenImage({super.key, required this.bytes, required this.buttonSize});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  
  @override
  Widget build(BuildContext context) {
    final bytes = widget.bytes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: bytes == null ? const Center(
        child: CircularProgressIndicator()
      ) : InteractiveViewer(
        maxScale: 1024.0,
        child: SizedBox.expand(
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}