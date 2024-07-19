import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/api_result.dart';
import '../models/response/base_response.dart';
import '../models/response/error_response.dart';

import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/api_result.dart';
import '../models/response/base_response.dart';
import '../models/response/error_response.dart';

extension DioExtensions on Dio {
  Future<ApiResult<T>> makeRequest<T>(
      Future<Response> Function() request,
      T Function(Object? json) fromJsonT,
      ) async {
    try {
      final response = await request();

      final data = response.data as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final baseResponse = BaseResponse.fromJson(data, fromJsonT,);
        return Success(baseResponse.data);
      } else {
        final errorResponse = ErrorResponse.fromJson(data);
        return Error(errorResponse.errorMessage, errorResponse.errorCode);
      }
    } catch (e) {
      return Error(e.toString(), "500");
    }
  }
}
