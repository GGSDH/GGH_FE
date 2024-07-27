import 'package:json_annotation/json_annotation.dart';

enum LoginProvider {
  @JsonValue("KAKAO")
  kakao,
  @JsonValue("APPLE")
  apple
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