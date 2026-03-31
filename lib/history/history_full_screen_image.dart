import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucky_artwork/history/history_function.dart';

class FullScreenImage extends StatefulWidget {
  final File file;
  final double buttonSize;

  const FullScreenImage({super.key, required this.file, required this.buttonSize});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  bool showUI = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showUI ? AppBar(
        backgroundColor: Colors.transparent,
      ) : null,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Uint8List> (
        future: widget.file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  showUI = !showUI;
                });
              },
              child: InteractiveViewer(
                maxScale: 1024.0,
                child: SizedBox.expand(
                  child: Image.file(
                    widget.file,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: showUI ? Row(
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
                ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                HistoryFunction().saveImageAndShowPath(widget.file, messenger);
              },
              tooltip: "Download",
              child: Icon(
                Icons.download,
                size: widget.buttonSize * 0.5,
              ),
            ),
          ),
        ]
      ) : null,
    );
  }
}