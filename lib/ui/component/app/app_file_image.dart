import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';

class AppFileImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: FutureBuilder<String>(
        future: _getResolvedFilePath(imageFilePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return placeholder;
          } else if (snapshot.hasError || !snapshot.hasData) {
            return errorWidget;
          } else {
            return Image.file(
              File(snapshot.data!),
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return errorWidget;
              },
            );
          }
        },
      ),
    );
  }

  Future<String> _getResolvedFilePath(String relativePath) async {
    final filePath = await relativePath.getFilePath();
    if (!await File(filePath).exists()) {
      return '';
    }
    return filePath;
  }
}
