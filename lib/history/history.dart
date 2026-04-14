import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_artwork/history/history_full_screen_image.dart';
import 'package:lucky_artwork/history/history_function.dart';
import 'package:lucky_artwork/setting/developer_options/developer_options_function.dart';
import 'package:lucky_artwork/util/function_util.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> with AutomaticKeepAliveClientMixin{
  late Future configLoadFuture;

  bool enabledCacheAndHistory= true;
  List<File> imageFiles = [];
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};
  double buttonSize= 56.0;
  double imageColumns = 3.0;
  bool showExploreButton = true;

  bool limitCaching = false;

  ScrollController scrollController = ScrollController();
  int pageSize = 50;
  int currentMax = 50;
  double initItemSize = 112;

  Future<bool> loadConfig() async {
    final result = await Future.wait([
      /* 0 */ FunctionUtil.storage.isEnabledCacheAndHistory(),
      /* 1 */ FunctionUtil.display.getButtonSize(),
      /* 2 */ FunctionUtil.display.getImageColumns(),
      /* 3 */ FunctionUtil.display.isEnabledExploreButton(),
      /* 4 */ DeveloperOptionsFunction.config.isLimitCaching()
    ]);

    double rawImageColumns = result[2] as double;

    if (rawImageColumns > 6) rawImageColumns = 3;

    setState(() {
      enabledCacheAndHistory = result[0] as bool;
      buttonSize = result[1] as double;
      imageColumns = rawImageColumns;
      showExploreButton = result[3] as bool;
      limitCaching = result[4] as bool;
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

    if (!mounted) return;

    double screenWidth = MediaQuery.of(context).size.width;
    initItemSize = screenWidth / imageColumns;

    if (initItemSize < 200) initItemSize = 200;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    configLoadFuture = loadConfig();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if(limitCaching) {
          PaintingBinding.instance.imageCache.clearLiveImages();
          PaintingBinding.instance.imageCache.clear();
        }
        
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

    int rowsPerPage = (screenHeight ~/ itemSize) * 2; // 显示行数
    
    int pageSize = (rowsPerPage * imageColumns.toInt()).toInt();  // 每页数量

    // 如果计算结果和当前不一致，就更新
    if (pageSize != this.pageSize) {
      this.pageSize = pageSize;
      currentMax = pageSize;
    }

    if (!enabledCacheAndHistory) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.manage_history,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text("Cache and History are Disabled"),
            ],
          ),
        ),
      );
    }

    return FutureBuilder(
      future: configLoadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        return Scaffold(
          appBar: AppBar(
            title: const Text("History"),
            backgroundColor: Colors.transparent,
            foregroundColor: isDark ? Colors.white : Colors.black,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark ? [
                    Colors.transparent.withAlpha(192),
                    Colors.transparent,
                  ] : [
                    Colors.white,
                    Colors.white.withAlpha(0),
                  ],
                ),
              ),
            ),
            actions: [
              if (!isSelectionMode) IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
                onPressed: refreshHistory,
              ),
              IconButton(
                icon: isSelectionMode ? const Icon(Icons.close) : const Icon(Icons.select_all),
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
          body: imageFiles.isEmpty ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.history_toggle_off,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text("No History"),
              ],
            ),
          ) : GridView.builder(
            controller: scrollController,
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
              childAspectRatio: 3 / 4,
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
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        cacheWidth: initItemSize.toInt(),
                      ),
                    ),

                    if (isSelectionMode && isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent.withAlpha(100),
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
                ),
              );
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              if (showExploreButton && !isSelectionMode) SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: FloatingActionButton(
                  heroTag: "explore",
                  onPressed: () {
                    int num = Random().nextInt(imageFiles.length);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(file: imageFiles[num], buttonSize: buttonSize),
                      ),
                    ).then((result) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                      if (result == null) return;
                      if (result?["toDelete"]) refreshHistory();
                    });
                  },
                  tooltip: "Explore",
                  child: Icon(
                    Icons.explore,
                    size: buttonSize * 0.5,
                  ),
                ),
              ),

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
                              const Text("Are you sure you want to delete this record?"),
                              const SizedBox(height: 8),
                              const Text(
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

              if (isSelectionMode) const SizedBox(width: 12),

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
      },
    );
  }
}