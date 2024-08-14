import 'package:gyeonggi_express/data/datasource/trip_datasource.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';

import '../models/api_result.dart';
import '../models/response/lane_response.dart';
import '../models/response/local_restaurant_response.dart';

class TripRepositoryImpl implements TripRepository {
  final TripDataSource _tripDataSource;

  TripRepositoryImpl(this._tripDataSource);

  @override
  Future<ApiResult<List<Lane>>> getRecommendedLanes() => _tripDataSource.getRecommendedLanes();

  @override
  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants() => _tripDataSource.getLocalRestaurants();

  @override
  Future<ApiResult<List<PopularDestination>>> getPopularDestinations() => _tripDataSource.getPopularDestinations();
}