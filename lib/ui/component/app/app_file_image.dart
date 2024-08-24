import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';

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
      final filePath = await widget.imageFilePath.getFilePath();
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
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
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
