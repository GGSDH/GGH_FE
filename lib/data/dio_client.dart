import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    final options = BaseOptions(
      contentType: Headers.jsonContentType,
      baseUrl: Config.baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    );

    _dio = Dio(options)
    ..httpClientAdapter = IOHttpClientAdapter()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true
      )
    );
  }

  Dio get dio => _dio;
}