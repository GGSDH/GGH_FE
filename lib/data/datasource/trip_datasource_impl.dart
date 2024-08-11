import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/trip_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';

class TripDataSourceImpl implements TripDataSource {
  final Dio _dio;

  TripDataSourceImpl(this._dio);

  @override
  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants() async {
    return _dio.makeRequest<List<LocalRestaurant>>(
      () => _dio.get('v1/restaurant'),
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
}