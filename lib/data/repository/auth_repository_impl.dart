import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:gyeonggi_express/data/models/response/social_login_response.dart';

import '../models/api_result.dart';
import '../models/response/onboarding_response.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<ApiResult<SocialLoginResponse>> socialLogin({
    required String accessToken,
    required String refreshToken,
    required LoginProvider provider
  }) => _authDataSource.socialLogin(
    accessToken: accessToken,
    refreshToken: refreshToken,
    provider: provider
  );

  @override
  Future<ApiResult<List<OnboardingTheme>>> getOnboardingThemes() => _authDataSource.getOnboardingThemes();
}