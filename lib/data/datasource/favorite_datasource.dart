import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';

abstract class FavoriteDataSource {
  Future<ApiResult<List<TourAreaSummary>>> getFavoriteTourAreas();

  Future<ApiResult<List<Lane>>> getFavoriteLanes();
}
