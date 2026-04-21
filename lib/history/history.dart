import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_artwork/history/history_full_screen_image.dart';
import 'package:lucky_artwork/history/history_function.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
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

  Future<bool> _init() async {
    await Future.wait([
      loadConfig(),
      Future.delayed(const Duration(milliseconds: 300), () {
        refreshHistory();
      }),
    ]);

    return true;
  }

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

    configLoadFuture = _init();

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
              Text(AppLocalizations.of(context)!.history_cacheAndHistoryAreDisabled),
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
            title: Text(AppLocalizations.of(context)!.history_appbar_title),
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
                tooltip: AppLocalizations.of(context)!.history_appbar_button_refresh,
                onPressed: refreshHistory,
              ),
              IconButton(
                icon: isSelectionMode ? const Icon(Icons.close) : const Icon(Icons.select_all),
                tooltip: isSelectionMode ? AppLocalizations.of(context)!.history_appbar_button_selection_close : AppLocalizations.of(context)!.history_appbar_button_selection,
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
                Text(AppLocalizations.of(context)!.history_noHistory),
              ],
            ),
          ) : GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              bottom: 100,
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
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                if (showExploreButton && !isSelectionMode) SizedBox(
                  width: buttonSize,
                  height: buttonSize,
                  child: FloatingActionButton(
                    heroTag: "Explore",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          int num = Random().nextInt(imageFiles.length);

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog.fullscreen(
                                child: Scaffold(
                                  appBar: AppBar(
                                    title: Text(AppLocalizations.of(context)!.history_explore_appbar_title(imageFiles.length, num)),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    flexibleSpace: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent.withAlpha(192),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  extendBodyBehindAppBar: true,
                                  body: Center(
                                    child: Image.file(
                                      imageFiles[num],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  floatingActionButton: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: buttonSize,
                                        height: buttonSize,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          tooltip: AppLocalizations.of(context)!.history_explore_button_close,
                                          child: Icon(
                                            Icons.close,
                                            size: buttonSize * 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: buttonSize,
                                        height: buttonSize,
                                        child: FloatingActionButton(
                                          onPressed: () {
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
                                          tooltip: AppLocalizations.of(context)!.history_explore_button_open,
                                          child: Icon(
                                            Icons.zoom_out_map,
                                            size: buttonSize * 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: buttonSize,
                                        height: buttonSize,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            setState(() {
                                              num = Random().nextInt(imageFiles.length);
                                            });
                                          },
                                          tooltip: AppLocalizations.of(context)!.history_explore_button_next,
                                          child: Icon(
                                            Icons.refresh,
                                            size: buttonSize * 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    tooltip: AppLocalizations.of(context)!.history_button_explore,
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
                            title: Text(AppLocalizations.of(context)!.history_dialog_delete_title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.history_dialog_delete_content1),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.history_dialog_delete_content2,
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
                                    child: Text(AppLocalizations.of(context)!.history_dialog_delete_cancel),
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
                                    child: Text(AppLocalizations.of(context)!.history_dialog_delete_delete),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    tooltip: AppLocalizations.of(context)!.history_button_delete,
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
                      AppLocalizations? locale = AppLocalizations.of(context);
                      int status = -1;
                      int total = selectedIndexes.length;
                      final progress = ValueNotifier<int>(0);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.history_dialog_saving),
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
                      HistoryFunction.display.showSnackBar(message, status, locale);
                      
                      setState(() {
                        isSelectionMode = false;
                        selectedIndexes.clear();
                      });
                    },
                    tooltip: AppLocalizations.of(context)!.history_button_download,
                    child: Icon(
                      Icons.download,
                      size: buttonSize * 0.5,
                    ),
                  ),
                ),
              ]
            ),
          ),
        );
      },
    );
  }
}