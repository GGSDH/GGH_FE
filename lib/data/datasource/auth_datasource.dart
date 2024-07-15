import 'package:dio/dio.dart';

abstract class AuthDataSource {

  Future<Response> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  });

}