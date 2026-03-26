import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lucky_artwork/util/function_util.dart';
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
  double buttonSize= 56.0;
  double imageColumns = 3.0;

  Future<bool> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledCacheAndHistory = prefs.getBool("enabled_cache_and_history") ?? true;
      buttonSize = prefs.getDouble("button_size") ?? 56.0;
      imageColumns = prefs.getDouble("image_columns") ?? 3.0;
    });

    return true;
  }

  Future<void> loadCacheImages() async {
    Directory cacheDir = await FunctionUtilOfStorage().getCacheDir();
    
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
    Directory cacheDir = await FunctionUtilOfStorage().getCacheDir();

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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
      appBar: isDark ? AppBar(
        title: const Text("History"),
        backgroundColor: Colors.transparent.withAlpha(64),
        foregroundColor: Colors.white,
      ) : AppBar(
        title: const Text("History"),
        backgroundColor: Colors.white.withAlpha(64),
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: imageFiles.isEmpty ? const Center(
        child: Text("No History")
      ) : ListView(
        children: [
          GridView.builder(
            shrinkWrap: true, // 让 GridView 自适应高度
            physics: const NeverScrollableScrollPhysics(),  // 禁止 GridView 自己滚动
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: imageColumns.toInt(), // 列
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: imageFiles.length,
            itemBuilder: (context, index) {
              final file = imageFiles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(file: file, buttonSize: buttonSize),
                    ),
                  ).then((result) {
                    if (result == null) return;
                    if (result?["toDelete"]) refreshHistory();
                  });
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
        ],
      ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final File file;
  final double buttonSize;

  const FullScreenImage({super.key, required this.file, required this.buttonSize});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {

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
      Map<Permission, PermissionStatus> statuses = await FunctionUtilOfStorage().requestImagePermissionsPnAndroid();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Uint8List> (
        future: widget.file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InteractiveViewer(
              maxScale: 1024.0,
              child: SizedBox.expand(
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain,
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              heroTag: "Delete",
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Are you sure you want to delete this record?"),
                          SizedBox(height: 8),
                          Text(
                            "This operation will delete it from your history.",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.file.delete();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop({"toDelete": true});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: "Delete",
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.delete,
                size: widget.buttonSize * 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              heroTag: "Download",
              onPressed: () async {
                saveImage(widget.file);
              },
              tooltip: "Download",
              child: Icon(
                Icons.download,
                size: widget.buttonSize * 0.5,
              ),
            ),
          ),
        ]
      )
    );
  }
}