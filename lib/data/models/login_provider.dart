import 'package:json_annotation/json_annotation.dart';

enum LoginProvider {
  @JsonValue("KAKAO")
  kakao,
  @JsonValue("APPLE")
  apple;

  static LoginProvider fromJson(String value) {
    switch (value) {
      case 'KAKAO':
        return LoginProvider.kakao;
      case 'APPLE':
        return LoginProvider.apple;
      default:
        throw ArgumentError('Unknown LoginProvider: $value');
    }
  }
}

extension LoginProviderExtension on LoginProvider {
  String get name {
    switch (this) {
      case LoginProvider.kakao:
        return 'KAKAO';
      case LoginProvider.apple:
        return 'APPLE';
    }
  }
}