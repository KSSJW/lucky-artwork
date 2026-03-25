import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool enabledCacheAndHistory= true;
  List<File> imageFiles = [];

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledCacheAndHistory = prefs.getBool("enabled_cache_and_history") ?? true;
    });

    return true;
  }

  Future<void> loadCacheImages() async {
    Directory cacheDir = await getTemporaryDirectory();

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      cacheDir = Directory('$home/.cache/com.kssjw.lucky_artwork/images');
    }

    if (Platform.isAndroid) {
      final imagesDir = Directory("${cacheDir.path}/images");
      cacheDir = imagesDir;
    }
    
    if (await cacheDir.exists()) {
      setState(() {
        imageFiles = cacheDir
          .listSync()
          .where((f) => f is File && RegExp(r'\.(png|jpg|jpeg|webp|raw)$').hasMatch(f.path))
          .map((f) => f as File)
          .toList()
        ..sort((a, b) {
          final aName = a.path.split('/').last;
          final bName = b.path.split('/').last;

          final aStamp = int.tryParse(RegExp(r'image_(\d+)').firstMatch(aName)?.group(1) ?? '0') ?? 0;
          final bStamp = int.tryParse(RegExp(r'image_(\d+)').firstMatch(bName)?.group(1) ?? '0') ?? 0;

          return bStamp.compareTo(aStamp);
        });
      });
    }
  }

  Future<void> refreshHistory() async {
    Directory cacheDir = await getTemporaryDirectory();

    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '.';
      cacheDir = Directory('$home/.cache/com.kssjw.lucky_artwork/images');
    }

    if (Platform.isAndroid) {
      final imagesDir = Directory("${cacheDir.path}/images");
      cacheDir = imagesDir;
    }

    if (await cacheDir.exists()) {
      final files = cacheDir
        .listSync()
        .where((f) => f is File && RegExp(r'\.(png|jpg|jpeg|webp|raw)$').hasMatch(f.path))
        .map((f) => f as File)
        .toList()
      ..sort((a, b) {
        final aName = a.path.split('/').last;
        final bName = b.path.split('/').last;

        final aStamp = int.tryParse(RegExp(r'image_(\d+)').firstMatch(aName)?.group(1) ?? '0') ?? 0;
        final bStamp = int.tryParse(RegExp(r'image_(\d+)').firstMatch(bName)?.group(1) ?? '0') ?? 0;

        return bStamp.compareTo(aStamp);
      });

      setState(() {
        imageFiles = files;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
    loadCacheImages();
  }

  @override
  Widget build(BuildContext context) {

    if (!enabledCacheAndHistory) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.manage_history,
                size: 80,
              ),
              SizedBox(height: 16),
              Text("Cache and History are Disabled"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: imageFiles.isEmpty
          ? const Center(child: Text("No History"))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 三列
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                final file = imageFiles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => FullScreenImage(file: file),
                    ));
                  },
                  child: FutureBuilder<Uint8List>(
                    future: file.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final File file;

  const FullScreenImage({super.key, required this.file});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  late double buttonSize;

  Future<double> getButtonSize() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getDouble("button_size") ?? 56.0;
  }

  void loadConfig() async {
    double tempSize = await getButtonSize();
    setState(() {
      buttonSize = tempSize;
    });
  }

  String getExtension(String path) {
    return path.substring(path.lastIndexOf('.'));
  }

  Future<void> saveImage(File file) async {
    final messenger = ScaffoldMessenger.of(context);
    
    if (Platform.isLinux) {
      final dir = await getDownloadsDirectory();

      if (dir == null) {
        messenger.showSnackBar(
          SnackBar(content: Text("Failed to save image")),
        );

        return;
      }

      final ext = getExtension(file.path);
      final newPath = "${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}$ext";
      await file.copy(newPath);
      messenger.showSnackBar(
        SnackBar(content: Text("Image saved to: $newPath")),
      );

      return;
    }

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.photos,
      ].request();

      if (statuses[Permission.storage]!.isGranted || statuses[Permission.photos]!.isGranted) {
        final bytes = await file.readAsBytes();
        final ext = getExtension(file.path);

        final result = await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}$ext"
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

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<Uint8List>(
          future: widget.file.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "Download",
              onPressed: () async {
                saveImage(widget.file);
              },
              tooltip: "Download",
              child: Icon(
                Icons.download,
                size: buttonSize * 0.5,
              ),
            ),
          ),
        ]
      )
    );
  }
}