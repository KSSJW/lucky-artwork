import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_artwork/history/history_function.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';

class FullScreenImage extends StatefulWidget {
  final File file;
  final double buttonSize;

  const FullScreenImage({super.key, required this.file, required this.buttonSize});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  bool showUI = true;

  late Future<bool> existsFuture;

  @override
  void initState() {
    super.initState();
    
    existsFuture = widget.file.exists();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder (
        future: existsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  showUI = !showUI;
                });
              },
              child: InteractiveViewer(
                maxScale: 16.0,
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
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.history_fullScreenImage_dialog_delete_title),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.history_fullScreenImage_dialog_delete_content1),
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.history_fullScreenImage_dialog_delete_content2,
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
                                child: Text(AppLocalizations.of(context)!.history_fullScreenImage_dialog_delete_cancel),
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
                                child: Text(AppLocalizations.of(context)!.history_fullScreenImage_dialog_delete_delete),
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
                AppLocalizations? locale = AppLocalizations.of(context);

                HistoryFunction.storage.saveImageAndShowPath(widget.file, messenger, locale);
              },
              tooltip: AppLocalizations.of(context)!.history_button_download,
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