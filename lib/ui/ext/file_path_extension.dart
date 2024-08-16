import 'dart:io';

import 'package:path_provider/path_provider.dart';

Map<String, String> _filePathCache = {};

extension FilePathExtension on String {
  Future<String> getFilePath() async {
    if (Platform.isIOS) {
      if (_filePathCache.containsKey(this)) {
        return _filePathCache[this]!;
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.parent.path}/tmp/$this';

      if (_filePathCache.length > 100) {
        _filePathCache.clear();
      }

      _filePathCache[this] = filePath;

      print('filePath: $filePath');

      return filePath;
    } else {
      return this;
    }
  }

  void clearFilePathCache() {
    _filePathCache.remove(this);
  }
}
