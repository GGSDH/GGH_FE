import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';

abstract class FavoriteDataSource {
  Future<ApiResult<List<TourAreaSummary>>> getFavoriteTourAreas();

  Future<ApiResult<List<Lane>>> getFavoriteLanes();

  Future<ApiResult<bool>> addFavoriteLane(int laneId);

  Future<ApiResult<bool>> removeFavoriteLane(int laneId);

  Future<ApiResult<bool>> addFavoriteTourArea(int tourAreaId);

  Future<ApiResult<bool>> removeFavoriteTourArea(int tourAreaId);

  Future<ApiResult<bool>> addFavoriteAiLane(int laneId);

  Future<ApiResult<bool>> removeFavoriteAiLane(int laneId);
}
