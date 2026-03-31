import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/home/home_funcion.dart';

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

    return Scaffold(
      appBar: showUI ? AppBar(
        backgroundColor: Colors.transparent,
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
          maxScale: 1024.0,
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
                HomeFuncion().saveImageAndShowPath(await widget.futureResponse, messenger);
              },
              tooltip: "Download",
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