import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/lane_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';

class LaneDatasourceImpl implements LaneDatasource {
  final Dio _dio;

  LaneDatasourceImpl(this._dio);

  @override
  Future<ApiResult<LaneDetail>> getLaneDetail(int laneId) {
    return _dio.makeRequest<LaneDetail>(() => _dio.get('v1/lane/$laneId'),
        (data) => LaneDetail.fromJson(data as Map<String, dynamic>));
  }

  @override
  Future<ApiResult<bool>> likeLane(int laneId) {
    return _dio.makeRequest<bool>(() => _dio.post('v1/lane/$laneId/like'),
        (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> unlikeLane(int laneId) {
    return _dio.makeRequest<bool>(() => _dio.post('v1/lane/$laneId/unlike'),
        (data) => data as bool);
  }
}
