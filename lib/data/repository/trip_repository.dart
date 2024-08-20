import 'package:gyeonggi_express/data/models/sigungu_code.dart';

import '../models/api_result.dart';
import '../models/response/lane_response.dart';
import '../models/response/local_restaurant_response.dart';
import '../models/response/popular_destination_response.dart';
import '../models/response/tour_area_response.dart';
import '../models/trip_theme.dart';

abstract class TripRepository {
  Future<ApiResult<List<Lane>>> getRecommendedLanes();

  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants();

  Future<ApiResult<List<PopularDestination>>> getPopularDestinations();

  Future<ApiResult<List<TourArea>>> getTourAreas(List<SigunguCode> sigunguCodes, TripTheme tripTheme);
}