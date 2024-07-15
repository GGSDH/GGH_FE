import 'package:dio/dio.dart';

abstract class AuthRepository {

  Future<Response> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  });

}