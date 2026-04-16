import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_artwork/home/home_funcion.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';

class FullScreenImage extends StatefulWidget {
  final Uint8List? bytes;
  final Future futureResponse;
  final double buttonSize;

  const FullScreenImage({super.key, required this.bytes, required this.futureResponse, required this.buttonSize});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  bool showUI = true;
  
  @override
  Widget build(BuildContext context) {
    final bytes = widget.bytes;

    showUI ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge) : SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      appBar: showUI ? AppBar(
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
      ) : null,
      extendBodyBehindAppBar: true,
      body: bytes == null ? const Center(
        child: CircularProgressIndicator()
      ) : GestureDetector(
        onTap: () {
          setState(() {
            showUI = !showUI;
          });
        },
        child: InteractiveViewer(
          maxScale: 16.0,
          child: SizedBox.expand(
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      floatingActionButton: showUI ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              heroTag: "Download",
              onPressed: () async {
                ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                AppLocalizations? locale = AppLocalizations.of(context);
                
                HomeFuncion.storage.saveImageAndShowPath(await widget.futureResponse, messenger, locale);
              },
              tooltip: AppLocalizations.of(context)!.home_fullScreenImage_button_download,
              child: Icon(
                Icons.download,
                size: widget.buttonSize * 0.5,
              ),
            ),
          ),
        ],
      ) : null,
    );
  }
}