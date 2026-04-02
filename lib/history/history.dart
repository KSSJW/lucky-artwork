import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_artwork/history/history_full_screen_image.dart';
import 'package:lucky_artwork/history/history_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> with AutomaticKeepAliveClientMixin{
  bool enabledCacheAndHistory= true;
  List<File> imageFiles = [];
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};
  double buttonSize= 56.0;
  double imageColumns = 3.0;

  ScrollController scrollController = ScrollController();
  int pageSize = 50;
  int currentMax = 50;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      FunctionUtil.config.isEnabledCacheAndHistory(),
      FunctionUtil.display.getButtonSize(),
      FunctionUtil.display.getImageColumns()
    ]);
    setState(() {
      enabledCacheAndHistory = result[0] as bool;
      buttonSize = result[1] as double;
      imageColumns = result[2] as double;
    });

    return true;
  }

  Future<void> refreshHistory() async {
    Directory cacheDir = await FunctionUtil.storage.getCacheDir();

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    refreshHistory();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          currentMax += pageSize;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double itemSize = screenWidth / imageColumns; // 每个正方形格子的边长

    int rowsPerPage = (screenHeight ~/ itemSize); // 显示行数
    
    int pageSize = (rowsPerPage * imageColumns.toInt() * 1.5).toInt();  // 每页数量

    // 如果计算结果和当前不一致，就更新
    if (pageSize != pageSize) {
      pageSize = pageSize;
      currentMax = pageSize;
    }

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
      ) : GridView.builder(
        controller: scrollController,
        shrinkWrap: true, // 让 GridView 自适应高度
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: imageColumns.toInt(), // 列
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: (currentMax < imageFiles.length) ? currentMax : imageFiles.length,
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
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  if (result == null) return;
                  if (result?["toDelete"]) refreshHistory();
                });
              }
            },
            child: FutureBuilder(
              future: loadConfig(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                final navigator = Navigator.of(context);
                final message = ScaffoldMessenger.of(context);
                int status = -1;
                int total = selectedIndexes.length;
                final progress = ValueNotifier<int>(0);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Saving Images"),
                      content: ValueListenableBuilder<int>(
                        valueListenable: progress,
                        builder: (context, current, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LinearProgressIndicator(value: total == 0 ? 0 : current / total),
                              Text("$current / $total"),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );

                for (var index in selectedIndexes) {
                  final file = imageFiles[index];
                  
                  if (await file.exists()) status = await HistoryFunction.storage.saveImage(file);
                  progress.value++;
                }

                navigator.pop();
                HistoryFunction.display.showSnackBar(message, status);
                
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