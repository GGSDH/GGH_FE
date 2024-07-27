enum LoginProvider {
  kakao, apple
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