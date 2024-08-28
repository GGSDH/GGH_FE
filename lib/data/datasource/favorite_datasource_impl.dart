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
}
