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
        final baseResponse = BaseResponse.fromJson(data, fromJsonT);
        return Success(baseResponse.data);
      } else {
        final errorResponse = ErrorResponse.fromJson(data);
        return Error(errorResponse.errorMessage, errorResponse.errorCode);
      }
    } on DioException catch (e) {
      String errorMessage = e.message ?? 'Unknown error occurred';
      String errorCode = e.response?.statusCode?.toString() ?? '500';

      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
          errorCode = responseData['code']?.toString() ?? errorCode;
        }
      }

      print('Error: $errorMessage');
      print('Error Code: $errorCode');
      print('Stack trace: ${e.stackTrace}');

      return Error(errorMessage, errorCode);
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return Error(e.toString(), "500");
    }
  }
}
