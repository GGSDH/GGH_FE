import 'package:dio/dio.dart';

import '../models/api_result.dart';

abstract class AuthRepository {

  Future<ApiResult> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  });

}