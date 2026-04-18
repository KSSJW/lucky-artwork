import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lucky_artwork/home/home_full_screen_image.dart';
import 'package:lucky_artwork/home/home_funcion.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
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
    setState(() {
      imageLoading = true;
      if (enabledFadeInAnimationForImage) _opacity = 0.0;
    });

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
        });

        if (enabledFadeInAnimationForImage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _opacity = 1.0;
            });
          });
        }

        return response;
      } else {
        setState(() {
          imageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        imageLoading = false;
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
      appBar: AppBar(
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
                Colors.white.withAlpha(192),
                Colors.white.withAlpha(128),
                Colors.white.withAlpha(64),
                Colors.white.withAlpha(0),
              ],
            ),
          ),
        ),
        title: const Text("Lucky Artwork"),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: futureResponse,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(  // 加载中
              child: Stack(
                children: [
                  if (bytes != null) SizedBox.expand(
                    child: Image.memory(
                      bytes!,
                      fit: BoxFit.cover,
                      cacheWidth: MediaQuery.of(context).size.width.toInt(),
                    ),
                  ),
                  
                  if (bytes != null) BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: isDark ? Colors.transparent.withAlpha(128) : Colors.transparent.withAlpha(64)),
                  ),

                  SpinKitSquareCircle(
                    color: isDark ? Colors.white : Colors.blueGrey,
                    duration : const Duration(milliseconds: 600),
                  ),
                ],
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
            return Stack(
              children: [

                SizedBox.expand(
                  child: enabledFadeInAnimationForImage ? AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Image.memory(
                      bytes!,
                      fit: BoxFit.cover,
                      cacheWidth: MediaQuery.of(context).size.width.toInt(),
                    ),
                  ) : Image.memory(
                    bytes!,
                    fit: BoxFit.cover,
                    cacheWidth: MediaQuery.of(context).size.width.toInt(),
                  ),
                ),

                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: isDark ? Colors.transparent.withAlpha(128) : Colors.transparent.withAlpha(64)),
                ),

                Center(
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: 8 + (kToolbarHeight + MediaQuery.of(context).padding.top) * 0.5,
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
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
                            duration: const Duration(milliseconds: 500),
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
                  Text(AppLocalizations.of(context)!.home_noData),
                  Text.rich(
                    TextSpan(
                      text: AppLocalizations.of(context)!.home_tryChangingTheApi,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => const ApiSetting()),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
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
                tooltip: AppLocalizations.of(context)!.home_button_exit,
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
                  AppLocalizations? locale = AppLocalizations.of(context);
                  
                  HomeFuncion.storage.saveImageAndShowPath(await futureResponse, messenger, locale);
                },
                tooltip: AppLocalizations.of(context)!.home_button_download,
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
                tooltip: AppLocalizations.of(context)!.home_button_download_loading,
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
                tooltip: AppLocalizations.of(context)!.home_button_next,
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
  }
}