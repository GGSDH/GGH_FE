import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';

import '../../../util/isolate_util.dart';

class AppFileImage extends StatefulWidget {
  final String imageFilePath;
  final double width;
  final double height;
  final Widget placeholder;
  final Widget errorWidget;

  const AppFileImage({
    super.key,
    required this.imageFilePath,
    this.width = 100.0,
    this.height = 100.0,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  _AppFileImageState createState() => _AppFileImageState();
}

class _AppFileImageState extends State<AppFileImage> {
  String? resolvedFilePath;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(AppFileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageFilePath != widget.imageFilePath) {
      _resetState();
      _loadImage();
    }
  }

  void _resetState() {
    setState(() {
      isLoading = true;
      hasError = false;
      resolvedFilePath = null;
    });
  }

  Future<void> _loadImage() async {
    try {
      final filePath = await computeIsolate(_resolveFilePath, widget.imageFilePath);
      if (await File(filePath).exists()) {
        setState(() {
          resolvedFilePath = filePath;
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  static Future<String> _resolveFilePath(String imageFilePath) async {
    return await imageFilePath.getFilePath();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.placeholder;
    } else if (hasError || resolvedFilePath == null) {
      return widget.errorWidget;
    } else {
      return Image.file(
        File(resolvedFilePath!),
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget;
        },
      );
    }
  }
}