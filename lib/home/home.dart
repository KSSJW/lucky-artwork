import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lucky_artwork/home/home_full_screen_image.dart';
import 'package:lucky_artwork/home/home_funcion.dart';
import 'package:lucky_artwork/setting/api/api_setting.dart';
import 'package:lucky_artwork/util/function_util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late Future futureResponse;
  Uint8List? bytes;
  late Stopwatch stopwatch;
  bool imageLoading = false;
  double _opacity = 0.0;

  bool showExitButton = false;
  double buttonSize = 56.0;
  bool enabledCacheAndHistory = true;
  bool showLatency = true;
  bool enabledFadeInAnimationForImage = true;

  Future loadConfig() async {
    final results = await Future.wait([
      FunctionUtil.display.isEnabledExitButton(),
      FunctionUtil.display.getButtonSize(),
      FunctionUtil.storage.isEnabledCacheAndHistory(),
      FunctionUtil.display.isEnabledFadeInAnimationForImage()
    ]);

    setState(() {
      showExitButton = results[0] as bool;
      buttonSize = results[1] as double;
      enabledCacheAndHistory = results[2] as bool;
      enabledFadeInAnimationForImage = results[3] as bool;
    });
  }

  Future fetchData() async {
    setState(() => imageLoading = true);

    try {
      var api = await FunctionUtil.network.getAPI();

      if (await FunctionUtil.display.isEnabledLatency()) {
        showLatency = true;
        stopwatch = Stopwatch()..start();
      } else {
        showLatency = false;
      }

      final response = await http.get(Uri.parse(api));

      if (showLatency) stopwatch.stop();

      if (response.statusCode == 200) {
        bytes = response.bodyBytes;
        
        if (enabledCacheAndHistory) await HomeFuncion.storage.cacheImage(response); // 缓存

        setState(() {
          imageLoading = false;
          if (enabledFadeInAnimationForImage) _opacity = 0.0;
        });

        return response;
      } else {
        setState(() {
          imageLoading = false;
          if (enabledFadeInAnimationForImage) _opacity = 0.0;
        });
      }
    } catch (e) {
      setState(() {
        imageLoading = false;
        if (enabledFadeInAnimationForImage) _opacity = 0.0;
      });
      throw Exception(e);
    }
  }

  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    loadConfig();
    futureResponse = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Lucky Artwork")),
      body: FutureBuilder(
        future: futureResponse,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(  // 加载中
              child: SpinKitSquareCircle(
                color: isDark ? Colors.white : Colors.blueGrey,
                duration : const Duration(milliseconds: 600),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(  // 错误提示
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text("${snapshot.error}")
                ],
              ),
            );
          } else if (snapshot.hasData) {

            if (enabledFadeInAnimationForImage) {

              // 在当前帧的渲染完成之后
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _opacity = 1.0;
                });
              });
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (showLatency) Row(
                  children: [
                    Icon(
                      Icons.speed,
                      color: stopwatch.elapsedMilliseconds < 3000 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text("${stopwatch.elapsedMilliseconds} ms"),
                  ],
                ),
                const SizedBox(height: 6),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(bytes: bytes!, futureResponse: futureResponse, buttonSize: buttonSize),
                      ),
                    ).then((_) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    });
                  },
                  child:  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height > 224.0 ? MediaQuery.of(context).size.height - 168.0 : MediaQuery.of(context).size.height,
                    ),
                    child: enabledFadeInAnimationForImage ? AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 200),
                      child: Image.memory(
                        bytes!,
                        fit: BoxFit.contain
                      ),
                    ) : Image.memory(
                      bytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  const Text("No Data"),
                  Text.rich(
                    TextSpan(
                      text: "Try changing the API",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => const ApiSettingPage()),
                          );
                        }
                    )
                  ),
                ],
              ),
            );
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
                Icons.power_settings_new,
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
                if (imageLoading) return;

                ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                HomeFuncion.storage.saveImageAndShowPath(await futureResponse, messenger);
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
            child: imageLoading ? FloatingActionButton(
              heroTag: "Loading",
              onPressed: () {},
              tooltip: "Loading",
              child: SizedBox(
                width: buttonSize * 0.5,
                height: buttonSize * 0.5,
                child: const CircularProgressIndicator(),
              ),
            ) : FloatingActionButton(
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