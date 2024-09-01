import 'package:gyeonggi_express/data/models/request/tour_area_search_request.dart';
import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/models/response/recommend_lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_pagination_response.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';

import '../models/api_result.dart';
import '../models/request/recommended_lane_request.dart';
import '../models/response/lane_response.dart';

abstract class TripDataSource {

  Future<ApiResult<List<Lane>>> getRecommendedLanes(List<SigunguCode> sigunguCodes);

  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants(List<SigunguCode> sigunguCodes);

  Future<ApiResult<List<PopularDestination>>> getPopularDestinations();

  Future<ApiResult<TourAreaPaginationResponse>> getTourAreas({
    required TourAreaSearchRequest request,
    required int page,
    int size = 20
  });

  Future<ApiResult<RecommendedLaneResponse>> getRecommendedLane({
    required RecommendedLaneRequest request
  });

}