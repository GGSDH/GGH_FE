import 'dart:io';

import 'package:path_provider/path_provider.dart';

extension FilePathExtension on String {
  Future<String> getFilePath() async {
    if (Platform.isIOS) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDirPath = appDocDir.parent.path;
      final filePath = '$appDirPath/tmp/$this';
      return filePath;
    } else {
      return this;
    }
  }
}