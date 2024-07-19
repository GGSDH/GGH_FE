import 'package:dio/dio.dart';

import '../models/api_result.dart';

abstract class AuthDataSource {

  Future<ApiResult> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  });

}