import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/favorite_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';

class FavoriteDatasourceImpl implements FavoriteDataSource {
  final Dio _dio;

  FavoriteDatasourceImpl(this._dio);

  @override
  Future<ApiResult<List<Lane>>> getFavoriteLanes() {
    return _dio.makeRequest<List<Lane>>(
        () => _dio.get('v1/like/lane'),
        (data) => (data as List)
            .map((e) => Lane.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<ApiResult<List<TourAreaSummary>>> getFavoriteTourAreas() {
    return _dio.makeRequest<List<TourAreaSummary>>(
        () => _dio.get('v1/like/tourArea'),
        (data) => (data as List)
            .map((e) => TourAreaSummary.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<ApiResult<bool>> addFavoriteLane(int laneId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/lane/$laneId/like'), (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> addFavoriteTourArea(int tourAreaId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/tour-area/$tourAreaId/like'),
        (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> removeFavoriteLane(int laneId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/lane/$laneId/unlike'), (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> removeFavoriteTourArea(int tourAreaId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/tour-area/$tourAreaId/unlike'),
        (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> addFavoriteAiLane(int laneId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/lane/aiLane/$laneId/like'), (data) => data as bool);
  }

  @override
  Future<ApiResult<bool>> removeFavoriteAiLane(int laneId) {
    return _dio.makeRequest<bool>(
        () => _dio.post('v1/lane/aiLane/$laneId/unlike'), (data) => data as bool);
  }
}
