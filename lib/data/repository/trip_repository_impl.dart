import 'package:gyeonggi_express/data/datasource/trip_datasource.dart';
import 'package:gyeonggi_express/data/models/request/tour_area_search_request.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_pagination_response.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';

import '../models/api_result.dart';
import '../models/response/lane_response.dart';
import '../models/response/local_restaurant_response.dart';
import '../models/sigungu_code.dart';
import '../models/trip_theme.dart';

class TripRepositoryImpl implements TripRepository {
  final TripDataSource _tripDataSource;

  TripRepositoryImpl(this._tripDataSource);

  @override
  Future<ApiResult<List<Lane>>> getRecommendedLanes(List<SigunguCode> sigunguCodes) => _tripDataSource.getRecommendedLanes(sigunguCodes);

  @override
  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants(List<SigunguCode> sigunguCodes) => _tripDataSource.getLocalRestaurants(sigunguCodes);

  @override
  Future<ApiResult<List<PopularDestination>>> getPopularDestinations() => _tripDataSource.getPopularDestinations();

  @override
  Future<ApiResult<TourAreaPaginationResponse>> getTourAreas({
    required List<SigunguCode> sigunguCodes,
    required TripTheme tripTheme,
    required int page,
    int size = 20
  }) => _tripDataSource.getTourAreas(
    page: page,
    size: size,
    request: TourAreaSearchRequest(sigunguCode: sigunguCodes, tripTheme: tripTheme)
  );
}