import 'package:gyeonggi_express/data/models/sigungu_code.dart';

import '../models/api_result.dart';
import '../models/response/lane_response.dart';
import '../models/response/local_restaurant_response.dart';
import '../models/response/popular_destination_response.dart';
import '../models/response/tour_area_pagination_response.dart';
import '../models/trip_theme.dart';

abstract class TripRepository {
  Future<ApiResult<List<Lane>>> getRecommendedLanes(List<SigunguCode> sigunguCodes);

  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants(List<SigunguCode> sigunguCodes);

  Future<ApiResult<List<PopularDestination>>> getPopularDestinations();

  Future<ApiResult<TourAreaPaginationResponse>> getTourAreas({
    required List<SigunguCode> sigunguCodes,
    required TripTheme tripTheme,
    required int page,
    int size = 20
  });
}