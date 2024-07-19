import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource.dart';

import '../models/api_result.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<ApiResult> socialLogin({
    required String accessToken,
    required String refreshToken,
    required String provider
  }) => _authDataSource.socialLogin(
    accessToken: accessToken,
    refreshToken: refreshToken,
    provider: provider
  );
}