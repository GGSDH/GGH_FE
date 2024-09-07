import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/tour_area_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';

class TourAreaDataSourceImpl extends TourAreaDataSource {
  final Dio _dio;

  TourAreaDataSourceImpl(this._dio);

  @override
  Future<ApiResult<TourAreaDetail>> getTourAreaDetail(int tourAreaId) {
    return _dio.makeRequest<TourAreaDetail>(
        () => _dio.get('v1/tour-area/$tourAreaId'),
        (data) => TourAreaDetail.fromJson(data as Map<String, dynamic>));
  }

  @override
  Future<ApiResult<bool>> likeTourArea(int tourAreaId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/tour-area/$tourAreaId/like'),
        (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> unlikeTourArea(int tourAreaId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/tour-area/$tourAreaId/unlike'),
        (data) => data as bool);
  }
}
