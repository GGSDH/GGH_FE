import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:gyeonggi_express/data/models/response/onboarding_response.dart';
import 'package:gyeonggi_express/data/models/response/social_login_response.dart';

import '../models/api_result.dart';

abstract class AuthRepository {
  Future<ApiResult<SocialLoginResponse>> socialLogin({
    required String accessToken,
    required String refreshToken,
    required LoginProvider provider
  });

  Future<ApiResult<List<OnboardingTheme>>> getOnboardingThemes();
}
