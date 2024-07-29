import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:gyeonggi_express/data/models/request/social_login_request.dart';
import 'package:gyeonggi_express/data/models/response/onboarding_response.dart';
import 'package:gyeonggi_express/data/models/response/social_login_response.dart';

import '../models/api_result.dart';
import '../models/request/onboarding_request.dart';
import '../models/request/update_nickname_request.dart';
import '../models/response/profile_response.dart';
import 'auth_datasource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;

  AuthDataSourceImpl(this._dio);

  @override
  Future<ApiResult<SocialLoginResponse>> socialLogin({
    required String accessToken,
    required String refreshToken,
    required LoginProvider provider
  }) async {
    final loginRequest = LoginRequest(
        accessToken: accessToken,
        refreshToken: refreshToken
    );

    return _dio.makeRequest<SocialLoginResponse>(
      () => _dio.post(
        'v1/oauth/${provider.name}/login',
        data: loginRequest.toJson(),
      ),
      (data) => SocialLoginResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<List<OnboardingTheme>>> getOnboardingThemes() async {
    return _dio.makeRequest<List<OnboardingTheme>>(
      () => _dio.get('v1/trip/onboarding/themes'),
      (data) =>
      (data as List).map((e) =>
          OnboardingTheme.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<Response?>> setOnboardingInfo({
    required List<String> themeIds,
  }) async {
    final onboardingRequest = OnboardingRequest(themeIds: themeIds);

    return _dio.makeRequest<Response?>(
      () => _dio.post(
        'v1/trip/onboarding',
        data: onboardingRequest.toJson(),
      ),
      (data) => null
    );
  }

  @override
  Future<ApiResult<ProfileResponse>> getProfileInfo() async {
    return _dio.makeRequest<ProfileResponse>(
      () => _dio.get('v1/member'),
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<ProfileResponse>> updateNickname({
    required String nickname
  }) async {
    final updateNicknameRequest = UpdateNicknameRequest(nickname: nickname);

    return _dio.makeRequest<ProfileResponse>(
      () => _dio.put(
        'v1/member/nickname',
        data: updateNicknameRequest.toJson(),
      ),
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>)
    );
  }
}