import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:gyeonggi_express/data/models/request/social_login_request.dart';
import 'package:gyeonggi_express/data/models/response/onboarding_response.dart';
import 'package:gyeonggi_express/data/models/response/social_login_response.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_bloc.dart';

import '../models/api_result.dart';
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
}