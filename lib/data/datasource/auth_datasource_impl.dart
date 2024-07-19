import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/request/social_login_request.dart';
import 'package:gyeonggi_express/data/models/response/social_login_response.dart';

import '../models/api_result.dart';
import '../models/response/base_response.dart';
import '../models/response/error_response.dart';
import 'auth_datasource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;

  AuthDataSourceImpl(this._dio);

  @override
  Future<ApiResult> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  }) async {
    final loginRequest = LoginRequest(
        accessToken: accessToken,
        refreshToken: refreshToken
    );

    return _dio.makeRequest<SocialLoginResponse>(
      () => _dio.post(
        'v1/oauth/$provider/login',
        data: loginRequest.toJson(),
      ),
      (data) => SocialLoginResponse.fromJson(data as Map<String, dynamic>)
    );
  }
}