import 'dart:io';
import 'package:path_provider/path_provider.dart';

Map<String, String> _filePathCache = {};
String? _iosAppDocDir;

extension FilePathExtension on String {
  Future<String> getFilePath() async {
    if (Platform.isIOS) {
      if (_filePathCache.containsKey(this)) {
        return _filePathCache[this]!;
      }

      if (_iosAppDocDir == null || _iosAppDocDir!.isEmpty) {
        final appDocDir = await getApplicationDocumentsDirectory();
        _iosAppDocDir = appDocDir.parent.path;
      }

      final filePath = '$_iosAppDocDir/tmp/$this';

      if (_filePathCache.length > 100) {
        _filePathCache.clear();
      }

      _filePathCache[this] = filePath;

      return filePath;
    } else {
      return this;
    }
  }

  void clearFilePathCache() {
    _filePathCache.remove(this);
  }
}
