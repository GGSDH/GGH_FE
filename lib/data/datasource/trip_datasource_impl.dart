import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/trip_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_response.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';

import '../models/request/tour_area_search_request.dart';
import '../models/response/lane_response.dart';

class TripDataSourceImpl implements TripDataSource {
  final Dio _dio;

  TripDataSourceImpl(this._dio);

  @override
  Future<ApiResult<List<Lane>>> getRecommendedLanes(
    List<SigunguCode> sigunguCodes
  ) async {
    return _dio.makeRequest<List<Lane>>(
      () => _dio.get('v1/lane', queryParameters: {
        'sigunguCodes': sigunguCodes.map((e) => e.name).join(',')
      }),
      (data) =>
      (data as List).map((e) =>
          Lane.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants(
    List<SigunguCode> sigunguCodes
  ) async {
    return _dio.makeRequest<List<LocalRestaurant>>(
      () => _dio.get('v1/restaurant', queryParameters: {
        'sigunguCodes': sigunguCodes.map((e) => e.name).join(',')
      }),
      (data) =>
      (data as List).map((e) =>
          LocalRestaurant.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<List<PopularDestination>>> getPopularDestinations() {
    return _dio.makeRequest<List<PopularDestination>>(
      () => _dio.get('v1/ranking'),
      (data) =>
      (data as List).map((e) =>
          PopularDestination.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<List<TourArea>>> getTourAreas(TourAreaSearchRequest request) {
    return _dio.makeRequest<List<TourArea>>(
      () => _dio.get('v1/tour-area/search', data: request.toJson()),
      (data) =>
      (data as List).map((e) =>
          TourArea.fromJson(e as Map<String, dynamic>)).toList()
    );
  }
}