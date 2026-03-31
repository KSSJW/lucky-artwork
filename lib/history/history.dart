import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucky_artwork/history/history_full_screen_image.dart';
import 'package:lucky_artwork/history/history_function.dart';
import 'package:lucky_artwork/util/function_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool enabledCacheAndHistory= true;
  List<File> imageFiles = [];
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};
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
    refreshHistory();
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
        actions: [
          if (!isSelectionMode) IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: refreshHistory,
          ),
          IconButton(
            icon: isSelectionMode ? Icon(Icons.close) : Icon(Icons.select_all),
            tooltip: isSelectionMode ? "Close" : "Selection",
            onPressed: () {
              if (!isSelectionMode) {
                setState(() {
                  selectedIndexes.clear();
                  isSelectionMode = true;
                });
              } else {
                setState(() {
                  isSelectionMode = false;
                  selectedIndexes.clear();
                });
              }
            },
          ),
        ],
      ) : AppBar(
        title: const Text("History"),
        backgroundColor: Colors.white.withAlpha(64),
        foregroundColor: Colors.black,
        actions: [
          if (!isSelectionMode) IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: refreshHistory,
          ),
          IconButton(
            icon: isSelectionMode ? Icon(Icons.close) : Icon(Icons.select_all),
            tooltip: isSelectionMode ? "Close" : "Selection",
            onPressed: () {
              if (!isSelectionMode) {
                setState(() {
                  selectedIndexes.clear();
                  isSelectionMode = true;
                });
              } else {
                setState(() {
                  isSelectionMode = false;
                  selectedIndexes.clear();
                });
              }
            },
          ),
        ],
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
              final isSelected = selectedIndexes.contains(index);

              return GestureDetector(
                onTap: () {
                  if (isSelectionMode) {

                    if (isSelected) {
                      setState(() {
                        selectedIndexes.remove(index);
                      });
                    } else {
                      setState(() {
                        selectedIndexes.add(index);
                      });
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(file: file, buttonSize: buttonSize),
                      ),
                    ).then((result) {
                      if (result == null) return;
                      if (result?["toDelete"]) refreshHistory();
                    });
                  }
                },
                child: FutureBuilder<Uint8List>(
                  future: file.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1, // 正方形格子
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),

                          if (isSelectionMode && isSelected)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent.withAlpha(100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          if (isSelectionMode) Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              isSelected
                                ? Icons.check_circle // 已选中时显示实心圆圈
                                : Icons.radio_button_unchecked, // 未选中时显示空心圆圈
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      );
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isSelectionMode) SizedBox(
            width: buttonSize,
            height: buttonSize,
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
                          onPressed: () async {
                            final navigator = Navigator.of(context);

                            for (var index in selectedIndexes) {
                              final file = imageFiles[index];
                              
                              if (await file.exists()) file.delete();
                            }

                            await refreshHistory();
                            setState(() {
                              isSelectionMode = false;
                              selectedIndexes.clear();
                            });

                            navigator.pop();
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
                size: buttonSize * 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          if (isSelectionMode) SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "Download",
              onPressed: () async {
                final message = ScaffoldMessenger.of(context);
                int status = -1;

                for (var index in selectedIndexes) {
                  final file = imageFiles[index];
                  
                  if (await file.exists()) {
                    status = await HistoryFunction().saveImage(file);
                  }
                }

                HistoryFunction().showSnackBar(message, status);

                setState(() {
                  isSelectionMode = false;
                  selectedIndexes.clear();
                });
              },
              tooltip: "Download",
              child: Icon(
                Icons.download,
                size: buttonSize * 0.5,
              ),
            ),
          ),
        ]
      ),
    );
  }
}